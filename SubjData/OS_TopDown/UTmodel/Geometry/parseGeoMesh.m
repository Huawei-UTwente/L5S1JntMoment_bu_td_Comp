filename = 'l_foot.vtp';

try
   tree = xmlread(filename);
catch
   error('Failed to read XML file %s.',filename);
end

% Recurse over child nodes. This could run into problems 
% with very deeply nested trees.
try
   theStruct = parseChildNodes(tree);
catch
   error('Unable to parse XML file %s.',filename);
end

% plot the 3d mesh files
PointData = theStruct.Children(2).Children(2).Children(2).Children(2).Children.Data;
Points = theStruct.Children(2).Children(2).Children(4).Children(2).Children.Data;
Polys = theStruct.Children(2).Children(2).Children(6).Children(4).Children.Data;

scaling = [1.0127706130424028 1.0127706130424028 1.3166232217028573];

figure()
% subplot(1, 2, 1)
% scatter3(PointData(:, 1)*scaling(1), PointData(:, 2)*scaling(2), PointData(:, 3)*scaling(3), '.')
% hold on
% scatter3(0, 0, 0, 'ro')
% xlabel('x')
% ylabel('y')
% zlabel('z')
% hold off
% axis equal
% subplot(1, 2, 2)
scatter3(Points(:, 1)*scaling(1), Points(:, 2)*scaling(2), Points(:, 3)*scaling(3), '.')
hold on
scatter3(0, 0, 0, 'ro')
hold off
xlabel('x')
ylabel('y')
zlabel('z')
axis equal


% ----- Local function PARSECHILDNODES -----
function children = parseChildNodes(theNode)
    % Recurse over node children.
    children = [];
    if theNode.hasChildNodes
       childNodes = theNode.getChildNodes;
       numChildNodes = childNodes.getLength;
       allocCell = cell(1, numChildNodes);

       children = struct(             ...
          'Name', allocCell, 'Attributes', allocCell,    ...
          'Data', allocCell, 'Children', allocCell);

        for count = 1:numChildNodes
            theChild = childNodes.item(count-1);
            children(count) = makeStructFromNode(theChild);
        end
    end
end

% ----- Local function MAKESTRUCTFROMNODE -----
function nodeStruct = makeStructFromNode(theNode)
% Create structure of node info.

    nodeStruct = struct(                        ...
       'Name', char(theNode.getNodeName),       ...
       'Attributes', parseAttributes(theNode),  ...
       'Data', '',                              ...
       'Children', parseChildNodes(theNode));

    if any(strcmp(methods(theNode), 'getData'))
       nodeStruct.Data = str2num(theNode.getData); 
    else
       nodeStruct.Data = '';
    end
end

% ----- Local function PARSEATTRIBUTES -----
function attributes = parseAttributes(theNode)
% Create attributes structure.

    attributes = [];
    if theNode.hasAttributes
       theAttributes = theNode.getAttributes;
       numAttributes = theAttributes.getLength;
       allocCell = cell(1, numAttributes);
       attributes = struct('Name', allocCell, 'Value', ...
                           allocCell);

       for count = 1:numAttributes
          attrib = theAttributes.item(count-1);
          attributes(count).Name = char(attrib.getName);
          attributes(count).Value = attrib.getValue;
       end
    end
end

