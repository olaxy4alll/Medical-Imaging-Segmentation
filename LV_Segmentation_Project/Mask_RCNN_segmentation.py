# example of inference with a pre-trained coco model
import os
import sys

import cv2
import scipy.io
from matplotlib import patches
from matplotlib.patches import Polygon
import matplotlib.pyplot as plt
import numpy as np
from skimage.measure import find_contours

os.environ["CUDA_VISIBLE_DEVICES"] = "-1"
from keras.preprocessing.image import load_img
from keras.preprocessing.image import img_to_array
from mrcnn.visualize import display_instances, random_colors, apply_mask
from mrcnn.config import Config
from mrcnn.model import MaskRCNN

# define 81 classes that the coco model knowns about
class_names = ['BG', 'ventricle', 'bicycle', 'car', 'motorcycle', 'airplane',
               'bus', 'train', 'truck', 'boat', 'traffic light',
               'fire hydrant', 'stop sign', 'parking meter', 'bench', 'bird',
               'cat', 'dog', 'horse', 'sheep', 'cow', 'elephant', 'bear',
               'zebra', 'giraffe', 'backpack', 'umbrella', 'handbag', 'tie',
               'suitcase', 'frisbee', 'skis', 'snowboard', 'sports ball',
               'kite', 'baseball bat', 'baseball glove', 'skateboard',
               'surfboard', 'tennis racket', 'bottle', 'wine glass', 'cup',
               'fork', 'knife', 'spoon', 'bowl', 'banana', 'apple',
               'sandwich', 'orange', 'broccoli', 'carrot', 'hot dog', 'pizza',
               'donut', 'cake', 'chair', 'couch', 'potted plant', 'bed',
               'dining table', 'toilet', 'tv', 'laptop', 'mouse', 'remote',
               'keyboard', 'cell phone', 'microwave', 'oven', 'toaster',
               'sink', 'refrigerator', 'book', 'clock', 'vase', 'scissors',
               'teddy bear', 'hair drier', 'toothbrush', 'person']


# define the test configuration
class TestConfig(Config):
    NAME = "ventricle"
    GPU_COUNT = 1
    IMAGES_PER_GPU = 1
    NUM_CLASSES = 1 + 1
    # number of training steps per epoch
    STEPS_PER_EPOCH = 5


def evaluation_single_image(imageName):
    # define the model
    rcnn = MaskRCNN(mode='inference', model_dir='./', config=TestConfig())
    # load coco model weights
    # load model weights
    model_path = 'mask_rcnn_left_ventricle_cfg_0005.h5'
    rcnn.load_weights(model_path, by_name=True)
    # load photograph
    img = load_img(imageName)
    img = img_to_array(img)
    # make prediction
    results = rcnn.detect([img], verbose=0)
    # get dictionary for first prediction
    r = results[0]
    # show photo with bounding boxes, masks, class labels and scores
    # my_res1= display_instances2(imageName,img, r['rois'], r['masks'], r['class_ids'], class_names, r['scores'])
    display_instances_single_image(imageName, img, r['rois'], r['masks'], r['class_ids'], class_names, r['scores'])
    # return my_res1

def display_instances_single_image(name, image, boxes, masks, class_ids, class_names,
                                   scores=None, title="",
                                   figsize=(3, 3), ax=None,
                                   show_mask=True, show_bbox=True,
                                   colors=None, captions=None):
    """
    boxes: [num_instance, (y1, x1, y2, x2, class_id)] in image coordinates.
    masks: [height, width, num_instances]
    class_ids: [num_instances]
    class_names: list of class names of the dataset
    scores: (optional) confidence scores for each box
    title: (optional) Figure title
    show_mask, show_bbox: To show masks and bounding boxes or not
    figsize: (optional) the size of the image
    colors: (optional) An array or colors to use with each object
    captions: (optional) A list of strings to use as captions for each object
    """
    # Number of instances
    N = boxes.shape[0]
    if not N:
        print("\n*** No instances to display *** \n")
        # else:
        assert tuple(boxes.shape[0]) == tuple(masks.shape[-1]) == tuple(class_ids.shape[0])

    # If no axis is passed, create one and automatically call show()
    auto_show = False
    if not ax:
        fig, ax = plt.subplots(1, figsize=figsize)
        auto_show = True

    # Generate random colors
    colors = colors or random_colors(N)

    # Show area outside image boundaries.
    height, width = image.shape[:2]
    ax.set_ylim(height + 10, -10)
    ax.set_xlim(-10, width + 10)
    ax.axis('off')
    ax.set_title(title)

    masked_image = image.astype(np.uint32).copy()
    for i in range(N):
        color = colors[i]

        # Bounding box
        if not np.any(boxes[i]):
            # Skip this instance. Has no bbox. Likely lost in image cropping.
            continue
        y1, x1, y2, x2 = boxes[i]
        if show_bbox:
            p = patches.Rectangle((x1, y1), x2 - x1, y2 - y1, linewidth=2,
                                  alpha=0.7, linestyle="dashed",
                                  edgecolor=color, facecolor='none')
            ax.add_patch(p)

        # Label
        if not captions:
            class_id = class_ids[i]
            score = scores[i] if scores is not None else None
            label = class_names[class_id]
            caption = "{} {:.3f}".format(label, score) if score else label
        else:
            caption = captions[i]
        ax.text(x1, y1 + 8, caption,
                color='w', size=11, backgroundcolor="none")

        # Mask
        mask = masks[:, :, i]
        if show_mask:
            masked_image = apply_mask(masked_image, mask, color)

        # Mask Polygon
        # Pad to ensure proper polygons for masks that touch image edges.
        padded_mask = np.zeros(
            (mask.shape[0] + 2, mask.shape[1] + 2), dtype=np.uint8)
        padded_mask[1:-1, 1:-1] = mask
        contours = find_contours(padded_mask, 0.5)
        for verts in contours:
            # Subtract the padding and flip (y, x) to (x, y)
            verts = np.fliplr(verts) - 1
            p = Polygon(verts, facecolor="none", edgecolor=color)
            ax.add_patch(p)
    ax.imshow(masked_image.astype(np.uint8))
    plt.savefig('./SegmentedImages/' + os.path.basename(name))
    # return masked_image.astype(np.uint8)


def evaluation_multi_images(imageNames):
    # define the model
    rcnn = MaskRCNN(mode='inference', model_dir='./', config=TestConfig())
    # load coco model weights
    # load model weights
    model_path = 'mask_rcnn_left_ventricle_cfg_0005.h5'
    rcnn.load_weights(model_path, by_name=True)
    # load photograph
    allResult = [];
    for imageName in imageNames:
        img = load_img(imageName)
        img = img_to_array(img)
        # make prediction
        results = rcnn.detect([img], verbose=0)
        # get dictionary for first prediction
        r = results[0]
        # show photo with bounding boxes, masks, class labels and scores
        # my_res1= display_instances2(imageName,img, r['rois'], r['masks'], r['class_ids'], class_names, r['scores'])
        if (r['rois'].shape[0] > 0 and r['masks'].shape[-1] > 0 and r['class_ids'].shape[0] > 0 and r['scores'].shape[
            0] > 0):
            display_instances_multi_images(imageName, img, r['rois'][0], r['masks'][:, :, 0], r['class_ids'][0],class_names, r['scores'][0])
    

def display_instances_multi_images(name, image, boxes, masks, class_ids, class_names,
                                   scores=None, title="",
                                   figsize=(5, 5), ax=None,
                                   show_mask=True, show_bbox=True,
                                   colors=None, captions=None):
    """
    boxes: [num_instance, (y1, x1, y2, x2, class_id)] in image coordinates.
    masks: [height, width, num_instances]
    class_ids: [num_instances]
    class_names: list of class names of the dataset
    scores: (optional) confidence scores for each box
    title: (optional) Figure title
    show_mask, show_bbox: To show masks and bounding boxes or not
    figsize: (optional) the size of the image
    colors: (optional) An array or colors to use with each object
    captions: (optional) A list of strings to use as captions for each object
    """
    # Number of instances
    N = 1
    if not N:
        print("\n*** No instances to display *** \n")
    # If no axis is passed, create one and automatically call show()
    auto_show = False
    if not ax:
        fig, ax = plt.subplots(1, figsize=figsize)
        auto_show = True

    # Generate random colors
    colors = colors or random_colors(N)

    # Show area outside image boundaries.
    height, width = image.shape[:2]
    ax.set_ylim(height + 10, -10)
    ax.set_xlim(-10, width + 10)
    ax.axis('off')
    ax.set_title(title)

    masked_image = image.astype(np.uint32).copy()
    for i in range(N):
        color = colors[i]

        # Bounding box
        # if not np.any(boxes[i]):
        if not np.any(boxes):
            # Skip this instance. Has no bbox. Likely lost in image cropping.
            continue
        # y1, x1, y2, x2 = boxes[i]
        y1, x1, y2, x2 = boxes
        if show_bbox:
            p = patches.Rectangle((x1, y1), x2 - x1, y2 - y1, linewidth=2,
                                  alpha=0.7, linestyle="dashed",
                                  edgecolor=color, facecolor='none')
            ax.add_patch(p)

        # Label
        if not captions:
            # class_id = class_ids[i]
            class_id = class_ids
            # score = scores[i] if scores is not None else None
            score = scores if scores is not None else None
            label = class_names[class_id]
            caption = "{} {:.3f}".format(label, score) if score else label
        else:
            # caption = captions[i]
            caption = captions
        ax.text(x1, y1 + 8, caption,
                color='w', size=11, backgroundcolor="none")

        # Mask
        # mask = masks[:, :, i]
        mask = masks
        if show_mask:
            masked_image = apply_mask(masked_image, mask, color)

        # Mask Polygon
        # Pad to ensure proper polygons for masks that touch image edges.
        padded_mask = np.zeros(
            (mask.shape[0] + 2, mask.shape[1] + 2), dtype=np.uint8)
        padded_mask[1:-1, 1:-1] = mask
        contours = find_contours(padded_mask, 0.5)
        for verts in contours:
            # Subtract the padding and flip (y, x) to (x, y)
            verts = np.fliplr(verts) - 1
            p = Polygon(verts, facecolor="none", edgecolor=color)
            ax.add_patch(p)
    ax.imshow(masked_image.astype(np.uint8))
    # plt.savefig('./segmentedResult/' + os.path.basename(name))
    cv2.imwrite('./SegmentedImages/' + os.path.basename(name) , masked_image.astype(np.uint8))
    # return masked_image.astype(np.uint8)


# evaluation_multi_images('00012.jpg')
# s = 'E:\\MSCV2_Final_Docs\\medical\\final\\Left-Ventricle-Database\\images\\00001.jpg,E:\\MSCV2_Final_Docs\\medical\\final\\Left-Ventricle-Database\\images\\00002.jpg'
# l = s.split(',')
# print(l)
# evaluation_multi_images(l)

if __name__ == '__main__':
    if sys.argv[1] == "multi":
        evaluation_multi_images(sys.argv[2].split(','))
    elif sys.argv[1] == 'single':
        evaluation_single_image(sys.argv[2])


# if __name__ == '__main__':
#     segmentedImage = evaluation_single_image(sys.argv[1])
#     scipy.io.savemat('./segmentedResult/'+os.path.basename(sys.argv[1]).replace('jpg','mat'), dict(data=segmentedImage))
