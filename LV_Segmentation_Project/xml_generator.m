function xml_generator(folder_name, file_name, path, with, height, x_min, y_min, x_max, y_max,destination)    
       
    parent_nodes = {'folder','filename','path', 'source', 'size', 'segmented'};
    sizeAtr = {'width','height','depth'};
    objectAtr = {'name','pose','truncated', 'difficult', 'bndbox'};
    bndboxAtr = {'xmin','ymin','xmax', 'ymax'};

    docNode = com.mathworks.xml.XMLUtils.createDocument('annotation');
    annotation = docNode.getDocumentElement;
    for idx = 1:numel(parent_nodes)
        parent_curr_node = docNode.createElement(parent_nodes{idx});
        switch parent_nodes{idx}
            case 'folder'
                parent_curr_node.appendChild(docNode.createTextNode(folder_name));
            case 'filename'
                parent_curr_node.appendChild(docNode.createTextNode(file_name));
            case 'path'
                parent_curr_node.appendChild(docNode.createTextNode(path));            
            case 'source'
                child_node= docNode.createElement('database');
                child_node.appendChild(docNode.createTextNode('Left-Ventricle-Database'));
                parent_curr_node.appendChild(child_node);
            case 'size'
                for id_size = 1:numel(sizeAtr)
                    child_node = docNode.createElement(sizeAtr{id_size});
                    switch sizeAtr{id_size}
                        case 'width' 
                            child_node.appendChild(docNode.createTextNode(with));
                        case 'height' 
                            child_node.appendChild(docNode.createTextNode(height));
                        case 'depth' 
                            child_node.appendChild(docNode.createTextNode('1'));                    
                    end    
                    parent_curr_node.appendChild(child_node);        
                end            
            case 'segmented'
                parent_curr_node.appendChild(docNode.createTextNode('0'));
        end
        annotation.appendChild(parent_curr_node);
    end

    %% object node
    
        parent_curr_node = docNode.createElement('object');
            for id_object = 1:numel(objectAtr)
                child_node = docNode.createElement(objectAtr{id_object});
                switch objectAtr{id_object}
                    case 'name' 
                        child_node.appendChild(docNode.createTextNode('ventricle'));
                    case 'pose' 
                        child_node.appendChild(docNode.createTextNode('Unspecified'));
                    case 'truncated' 
                        child_node.appendChild(docNode.createTextNode('0'));   
                    case 'difficult' 
                        child_node.appendChild(docNode.createTextNode('0'));
                    case 'bndbox'                   
                        for id_bndbox = 1:numel(bndboxAtr)
                            grand_child_node = docNode.createElement(bndboxAtr{id_bndbox});
                            switch bndboxAtr{id_bndbox}
                                case 'xmin'  
                                   grand_child_node.appendChild(docNode.createTextNode(x_min));
                                case 'ymin'  
                                   grand_child_node.appendChild(docNode.createTextNode(y_min));
                                case 'xmax'  
                                   grand_child_node.appendChild(docNode.createTextNode(x_max));
                                case 'ymax'  
                                   grand_child_node.appendChild(docNode.createTextNode(y_max));                                   
                            end        
                            child_node.appendChild(grand_child_node);
                        end                        
                end    
                parent_curr_node.appendChild(child_node);        
            end
        annotation.appendChild(parent_curr_node);  
        
    xml_file_name = char(strcat(extractBetween(file_name,1,5),'.xml'));
    xmlwrite(strcat(destination,xml_file_name),docNode);
end    