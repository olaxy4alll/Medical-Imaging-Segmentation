#fit a mask rcnn on the leftVentricle dataset
import os
os.environ["CUDA_VISIBLE_DEVICES"] = "-1"
from os import listdir
from xml.etree import ElementTree

import skimage
from numpy import zeros
from numpy import asarray
from mrcnn.utils import Dataset
from mrcnn.config import Config
from mrcnn.model import MaskRCNN
import tensorflow as tf

# class that defines and loads the leftVentricle dataset
class LeftVentricleDataset(Dataset):
	# load the dataset definitions
	def load_dataset(self, dataset_dir, is_train=True):
		# define one class
		self.add_class("dataset", 1, "Left-Ventricle-Database")
		# define data locations
		images_dir = dataset_dir + '/images/'
		annotations_dir = dataset_dir + '/annots/'
		masks_dir = dataset_dir + '/masks/'
		# find all images
		for filename in listdir(images_dir):
			# extract image id
			image_id = filename[:-4]
			# skip bad images
			if image_id in ['00300']:
				continue
			# skip all images after 150 if we are building the train set
			if is_train and int(image_id) >= 250:
				continue
			# skip all images before 150 if we are building the test/val set
			if not is_train and int(image_id) < 250:
				continue
			img_path = images_dir + filename
			ann_path = annotations_dir + image_id + '.xml'
			mask_path = masks_dir + filename
			# add to dataset
			self.add_image('dataset', image_id=image_id, path=img_path, annotation=ann_path, mask=mask_path)

	# extract bounding boxes from an annotation file
	def extract_boxes(self, filename):
		# load and parse the file
		tree = ElementTree.parse(filename)
		# get the root of the document
		root = tree.getroot()
		# extract each bounding box
		boxes = list()
		for box in root.findall('.//bndbox'):
			xmin = int(box.find('xmin').text)
			ymin = int(box.find('ymin').text)
			xmax = int(box.find('xmax').text)
			ymax = int(box.find('ymax').text)
			coors = [xmin, ymin, xmax, ymax]
			boxes.append(coors)
		# extract image dimensions
		width = int(root.find('.//size/width').text)
		height = int(root.find('.//size/height').text)
		return boxes, width, height

	# load the masks for an image
	def load_mask(self, image_id):
		# get details of image
		info = self.image_info[image_id]
		# define box file location
		path = info['mask']
		annot_path = info['annotation']
		# load XML
		boxes, w, h = self.extract_boxes(annot_path)
		# print(h)
		# print(w)

		image_mask = skimage.io.imread(self.image_info[image_id]['mask'])
		# print('mask size')
		mw = image_mask.shape[0]
		mh = image_mask.shape[1]
		# create one array for all masks, each on a different channel
		masks = zeros([h, w, len(boxes)], dtype='uint8')
		# create masks
		class_ids = list()
		for i in range(len(boxes)):
			box = boxes[i]
			# print(box[1], '', box[2])
			row_s, row_e = box[1], box[3]
			col_s, col_e = box[0], box[2]
			masks[row_s:row_s+mw, col_s:col_s+mh, i] = image_mask
			# masks = image_mask
			class_ids.append(self.class_names.index('Left-Ventricle-Database'))
		return masks, asarray(class_ids, dtype='int32')

	# load an image reference
	def image_reference(self, image_id):
		info = self.image_info[image_id]
		return info['path']

# define a configuration for the model
class LeftVentricleConfig(Config):
	# define the name of the configuration
	NAME = "left_ventricle_cfg"
	# number of classes (background + leftVentricle)
	NUM_CLASSES = 1 + 1
	# number of training steps per epoch
	STEPS_PER_EPOCH = 130
	# simplify GPU config
	# GPU_COUNT = 1
	# IMAGES_PER_GPU = 1
	# image size definitions
	#IMAGE_MIN_DIM = 32
	#IMAGE_MAX_DIM = 32
	# IMAGE_MIN_DIM = 400
	# IMAGE_MAX_DIM = 512
	 
# prepare train set
train_set = LeftVentricleDataset()
train_set.load_dataset('Left-Ventricle-Database', is_train=True)
train_set.prepare()
print('Train: %d' % len(train_set.image_ids))
# prepare test/val set
test_set = LeftVentricleDataset()
test_set.load_dataset('Left-Ventricle-Database', is_train=False)
test_set.prepare()
print('Test: %d' % len(test_set.image_ids))
# prepare config
config = LeftVentricleConfig()
config.display()
# define the model
model = MaskRCNN(mode='training', model_dir='./', config=config)
# load weights (mscoco) and exclude the output layers
model.load_weights('mask_rcnn_coco.h5', by_name=True, 
exclude=["mrcnn_class_logits", "mrcnn_bbox_fc",  "mrcnn_bbox", 
"mrcnn_mask"])
# train weights (output layers or 'heads')
model.train(train_set, test_set, learning_rate=config.LEARNING_RATE, 
epochs=5, layers='heads')
