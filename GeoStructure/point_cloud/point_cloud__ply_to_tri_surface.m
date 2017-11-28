function [ node_xyz, triangle_node, node_colour ] = point_cloud__ply_to_tri_surface(ply_filename)
%% PLY_TO_TRI_SURFACE converts data from a PLY file to TRI_SURFACE data.
%%-------------------------------------------------------------------------
% Discussion:
%  This routine reads a PLY file, searches for the data that defines
%  a polygonal surface, reduces polygons to triangles, and returns
%  a pair of arrays that define a TRI_SURFACE, that is a triangular
%  mesh of a surface in 3D.
%
% Example:
%  [ node_xyz, triangle_node ] = ply_to_tri_surface('cow.ply');
%  trisurf (triangle_node', node_xyz(1,:), node_xyz(2,:), node_xyz(3,:) );
%  colormap(gray);
%  axis equal;
%
% Discussion:
%  The original version of this program had a mistake that meant it
%  did not properly triangulate files whose faces were not already triangular.
%  This has been corrected (JVB, 25 February 2007).
%
% Modified:
%  01 March 2007
%
% Author:
%  Pascal Getreuer 2004
%  Modifications by John Burkardt
%
% Parameters:
%  Input, string PLY_FILENAME, the name of the PLY file to be read.
%  Output, real NODE_XYZ(3,NODE_NUM), the coordinates of the nodes.
%  Output, integer TRIANGLE_NODE(3,TRIANGLE_NUM), the indices of nodes
%  that make up the triangles.
%
% Local Parameters:
%  COMMENTS, any comments from the file.
%  ELEMENTCOUNT, the number of each type of element in file.
%  ELEMENTS, the element data.
%  LISTFLAG is 1 if there is a list type.
%  PROPERTYTYPES, the element property types.
%  SAMEFLAT is 1 if all types are the same.
%  SIZEOF, size in bytes of each type.
%
% Open the input file in "read text" mode.
%--------------------------------------------------------------------------


% Open the .ply file using fopen()
[ fid, Msg ] = fopen(ply_filename, 'rt');

% Throw error using Msg variable 
if (fid == -1)
    error (Msg);
end

% Open the fid variable as a string
Buf = fscanf(fid, '%s', 1);

% Set up variables to read the header
Position = ftell(fid);
Format = '';
NumComments = 0;
Comments = {};
NumElements = 0;
NumProperties = 0;
Elements = [];
ElementCount = [];
PropertyTypes = [];
% list of element names in the order they are stored in the file
ElementNames = {};  
% structure of lists of property names
PropertyNames = [];  


%--------------------------------------------------------------------------
% While loop to read [header] data from the file
%--------------------------------------------------------------------------
while(1) % Always TRUE. Read a line from the file
    Buf = fgetl(fid);
    BufRem = Buf;
    Token = {};
    Count = 0;
    while(~isempty(BufRem))  % Split the line into tokens.
        [ tmp, BufRem ] = strtok(BufRem);
        if(~isempty(tmp))  % Count the tokens
            Count = Count + 1;
            Token{Count} = tmp;
        end
    end
    if(Count) % If 'Count' var is non-zero, parse the line
        switch lower(Token{1})  % Read the data format.
            case 'format'
                if(2 <= Count)
                    Format = lower(Token{2});
                    if(Count == 3 & ~strcmp(Token{3}, '1.0'))
                        fclose(fid);  % Header not version 1.0, exit
                        error('Only PLY format version 1.0 supported.');
                    end
                end
            case 'comment'  % Read a comment
                NumComments = NumComments + 1;
                Comments{NumComments} = '';
                for i = 2:Count
                    Comments{NumComments} = [Comments{NumComments}, Token{i}, ' '];
                end
            case 'element'  % Read an element name
                if(3 <= Count)
                    if(isfield(Elements, Token{2}))
                        fclose(fid);  % Close if there is an Elements field
                        error(['Duplicate element name, ''', Token{2}, '''.']);
                    end
                    
                    NumElements = NumElements + 1; % Increment
                    NumProperties = 0;  % Variable
                    Elements = setfield(Elements, Token{2}, []);  % Set 'Elements' field 
                    PropertyTypes = setfield(PropertyTypes,Token{2},[]);  % Set 'PropertyTypes' field 
                    ElementNames{NumElements} = Token{2};  % Set 'ElementNames' field 
                    PropertyNames = setfield(PropertyNames,Token{2},{});  % Set 'PropertyNames' field 
                    CurElement = Token{2};
                    ElementCount(NumElements) = str2double(Token{3});  % Set 'Elements' field 
                    
                    if(isnan(ElementCount(NumElements)))
                        fclose(fid);  % Catch if number of elements is not a number
                        error(['Bad element definition: ', Buf]);
                    end
                else                    
                    error(['Bad element definition: ', Buf]);                    
                end
            case 'property'  % Read an element property.              
                if (~isempty(CurElement) & Count >= 3)
                    NumProperties = NumProperties + 1;
                    eval(['tmp=isfield(Elements.',CurElement,',Token{Count});'],...
                        'fclose(fid);error([''Error reading property: '', Buf])');           
                    if (tmp)
                        error(['Duplicate property name, ''',CurElement,'.',Token{2},'''.']);
                    end
                    % Add property subfield to Elements
                    eval(['Elements.',CurElement,'.',Token{Count},'=[];'], ...
                        'fclose(fid);error([''Error reading property: '', Buf])');
                    % Add property subfield to PropertyTypes and save type
                    eval(['PropertyTypes.',CurElement,'.',Token{Count},'={Token{2:Count-1}};'], ...
                        'fclose(fid);error([''Error reading property: '', Buf])');
                    % Record property name order.
                    eval(['PropertyNames.',CurElement,'{NumProperties}=Token{Count};'], ...
                        'fclose(fid);error([''Error reading property: '', Buf])');
                else
                    fclose(fid);
                    if(isempty(CurElement))
                        error(['Property definition without element definition: ', Buf]);
                    else
                        error(['Bad property definition: ', Buf]);
                    end
                end
                % End of header.
            case 'end_header'
                break;
        end
    end
end

%--------------------------------------------------------------------------
% Set reading for specified data format.
%--------------------------------------------------------------------------
if(isempty(Format))
    warning('Data format unspecified, assuming ASCII.');
    Format = 'ascii';
end

switch Format
    case 'ascii'
        Format = 0;
    case 'binary_little_endian'
        Format = 1;
    case 'binary_big_endian'
        Format = 2;
    otherwise
        fclose(fid);
        error(['Data format ''', Format, ''' not supported.']);
end
%--------------------------------------------------------------------------
% Read the rest of the file as ASCII data or, close the file and reopen in 
% "read binary" mode.
%--------------------------------------------------------------------------

if(~Format)
    Buf = fscanf(fid, '%f');
    BufOff = 1;
else
    fclose(fid);
    % Reopen binary file as LITTLE_ENDIAN or BIG_ENDIAN.
    Path = ply_filename;
    if (Format == 1)
        fid = fopen(Path, 'r', 'ieee-le.l64');
    else
        fid = fopen(Path, 'r', 'ieee-be.l64');
    end
%--------------------------------------------------------------------------
% Find the end of the header again.
% Using ftell on the old handle doesn't give the correct position.
%--------------------------------------------------------------------------
    BufSize = 8192;
    Buf = [blanks(10), char(fread(fid,BufSize, 'uchar')')];
    i = [];
    tmp = -11;
    
    while(isempty(i))
        % Look for end_header + CR/LF
        i = findstr(Buf, ['end_header', 13, 10]);
        % Look for end_header + LF
        i = [i, findstr(Buf, ['end_header', 10])];
        if(isempty(i))
            tmp = tmp + BufSize;
            Buf = [Buf(BufSize+1:BufSize+10), char(fread(fid,BufSize, 'uchar')')];
        end
    end
    % Seek to just after the line feed
    fseek (fid, i + tmp + 11 + (Buf(i + 10) == 13), -1);
end

%--------------------------------------------------------------------------
% Read element data: PLY and MATLAB data types (for fread)
%--------------------------------------------------------------------------

PlyTypeNames = {'char','uchar','short','ushort','int','uint','float','double', ...
    'char8','uchar8','short16','ushort16','int32','uint32','float32','double64'};
MatlabTypeNames = {'schar','uchar','int16','uint16','int32','uint32','single','double'};
SizeOf = [1,1,2,2,4,4,4,8];

% Get current element property information
for i = 1:NumElements
    eval(['CurPropertyNames=PropertyNames.', ElementNames{i}, ';']);
    eval(['CurPropertyTypes=PropertyTypes.', ElementNames{i}, ';']);
    NumProperties = size(CurPropertyNames, 2);
    % Read ASCII data
    if(~Format)
        for j = 1:NumProperties
            Token = getfield(CurPropertyTypes, CurPropertyNames{j});
            if (strcmpi(Token{1}, 'list'))
                Type(j) = 1;
            else
                Type(j) = 0;
            end
        end
%--------------------------------------------------------------------------
% Parse the buffer
%--------------------------------------------------------------------------
        if(~any(Type)) 
            % If there are no list types
            Data = reshape(Buf(BufOff:BufOff+ElementCount(i)*NumProperties - 1),...
                NumProperties, ElementCount(i))';
            BufOff = BufOff + ElementCount(i) * NumProperties;
        else
            ListData = cell(NumProperties, 1);
            for k = 1:NumProperties
                ListData{k} = cell(ElementCount(i), 1);
            end
            % If there are list types
            for j = 1:ElementCount(i)
                for k = 1:NumProperties
                    if(~Type(k))
                        Data(j,k) = Buf(BufOff);
                        BufOff = BufOff + 1;
                    else
                        tmp = Buf(BufOff);
                        ListData{k}{j} = Buf(BufOff+(1:tmp))';
                        BufOff = BufOff + tmp + 1;
                    end
                end
            end
        end
        % Read binary data.
    else
%--------------------------------------------------------------------------
% Translate PLY data type names to MATLAB data type names
%--------------------------------------------------------------------------       
        ListFlag = 0;
        SameFlag = 1;
        for j = 1:NumProperties
            Token = getfield(CurPropertyTypes,CurPropertyNames{j});            
            if(~strcmp(Token{1}, 'list'))  % If there are non-list types
                tmp = rem(strmatch(Token{1}, PlyTypeNames, 'exact')-1,8) + 1;
                if(~isempty(tmp))
                    TypeSize(j) = SizeOf(tmp);
                    Type{j} = MatlabTypeNames{tmp};
                    TypeSize2(j) = 0;
                    Type2{j} = '';
                    SameFlag = SameFlag & strcmp(Type{1},Type{j});
                else
                    fclose(fid);
                    error(['Unknown property data type, ''',Token{1},''', in ', ...
                        ElementNames{i},'.',CurPropertyNames{j},'.']);
                end               
            else  % If there are list types
                if(length(Token) == 3)
                    ListFlag = 1;
                    SameFlag = 0;
                    tmp = rem(strmatch(Token{2}, PlyTypeNames, 'exact')-1,8) + 1;
                    tmp2 = rem(strmatch(Token{3}, PlyTypeNames, 'exact')-1,8) + 1;
                    if(~isempty(tmp) & ~isempty(tmp2))
                        TypeSize(j) = SizeOf(tmp);
                        Type{j} = MatlabTypeNames{tmp};
                        TypeSize2(j) = SizeOf(tmp2);
                        Type2{j} = MatlabTypeNames{tmp2};
                    else
                        fclose(fid);
                        error(['Unknown property data type, ''list ',Token{2},' ',Token{3},''', in ', ...
                            ElementNames{i},'.',CurPropertyNames{j},'.']);
                    end
                else
                    fclose(fid);
                    error(['Invalid list syntax in ', ElementNames{i}, '.', ...
                        CurPropertyNames{j}, '.']);
                end
            end
        end
        % Read the file
        if(~ListFlag)            
            if(SameFlag)  % No list types, all the same type (fast)
                Data = fread(fid, [NumProperties, ElementCount(i)], Type{1})';                
            else  % No list types, mixed type               
                Data = zeros(ElementCount(i), NumProperties);                
                for j = 1:ElementCount(i)
                    for k = 1:NumProperties
                        Data(j, k) = fread(fid, 1, Type{k});
                    end
                end
            end
        else
            ListData = cell(NumProperties, 1);
            for k = 1:NumProperties
                ListData{k} = cell(ElementCount(i), 1);
            end           
            if(NumProperties == 1)
                BufSize = 512;
                SkipNum = 4;
                j = 0;
                % List type, one property (fast if lists are usually the same length)
                while(j < ElementCount(i))
                    BufSize = min(ElementCount(i) - j,BufSize);
                    Position = ftell(fid);
                    % Read in BufSize count values, assuming all counts = SkipNum
                    [ Buf, BufSize ] = fread(fid,BufSize,Type{1},SkipNum*TypeSize2(1));
                    % Find first count that is not SkipNum
                    Miss = find(Buf ~= SkipNum);
                    % Seek back to after first count
                    fseek(fid, Position + TypeSize(1), - 1);
                    if(isempty(Miss))  % If Miss var is empty, all counts are SkipNum                        
                        Buf = fread(fid, [SkipNum,BufSize], [int2str(SkipNum), '*',...
                            Type2{1}], TypeSize(1))';                      
                        fseek(fid, -TypeSize(1), 0);  % Undo the last skip.                      
                        for k = 1:BufSize
                            ListData{1}{j+k} = Buf(k,:);
                        end                       
                        j = j + BufSize;
                        BufSize = floor ( 1.5 * BufSize );
                    else
                        % Otherwise, some counts are SkipNum
                        if (1 < Miss(1))
                            Buf2 = fread(fid, [SkipNum,Miss(1)-1],[int2str(SkipNum),...
                                '*',Type2{1}], TypeSize(1))';
                            for k = 1:Miss(1) - 1
                                ListData{1}{j + k} = Buf2(k,:);
                            end
                            j = j + k;
                        end
                        % Read in the list with the missed count
                        SkipNum = Buf(Miss(1));
                        j = j + 1;
                        ListData{1}{j} = fread (fid, [1,SkipNum], Type2{1});
                        BufSize = ceil(0.6 * BufSize);
                    end
                end
            else
                % List type(s), multiple properties (slow)
                Data = zeros(ElementCount(i), NumProperties);
                for j = 1:ElementCount(i)
                    for k = 1:NumProperties
                        if(isempty(Type2{k}))
                            Data(j, k) = fread(fid, 1, Type{k});
                        else
                            tmp = fread(fid, 1, Type{k});
                            ListData{k}{j} = fread(fid, [1,tmp], Type2{k});
                        end
                    end
                end
            end
        end
    end
%--------------------------------------------------------------------------
% Put data into Elements structure
%--------------------------------------------------------------------------       
    for k = 1:NumProperties
        if ((~Format & ~Type(k)) | (Format & isempty(Type2{k})))
            eval(['Elements.', ElementNames{i}, '.', CurPropertyNames{k}, '=Data(:,k);']);
        else
            eval(['Elements.', ElementNames{i}, '.', CurPropertyNames{k}, '=ListData{k};']);
        end
    end
end
% Clear data vars and close file object
clear Data
clear ListData;
fclose(fid);

%--------------------------------------------------------------------------
% Output the data as a triangular mesh pair
%--------------------------------------------------------------------------

% Find 'vertex' element field
Name = {'vertex','Vertex','point','Point','pts','Pts'};
Names = [];

for i = 1:length(Name)
    if(any(strcmp(ElementNames, Name{i})))
        Names = getfield(PropertyNames, Name{i});
        Name = Name{i};
        break;
    end
end

if(any(strcmp(Names,'x')) & any(strcmp(Names,'y')) & any(strcmp(Names,'z')))
    eval(['node_xyz=[Elements.', Name, '.x,Elements.', Name, '.y,Elements.', Name, '.z];']);
else
    node_xyz = zeros(1,3);
end

node_xyz = node_xyz';
node_colour = [];
if(isfield(Elements.vertex, 'diffuse_red'))
    node_colour(1, :) = Elements.vertex.diffuse_red;
    node_colour(2, :) = Elements.vertex.diffuse_green;
    node_colour(3, :) = Elements.vertex.diffuse_blue;
end 

triangle_node = [];

% Find 'face' element field
Name = {'face','Face','poly','Poly','tri','Tri'};
Names = [];
for i = 1:length(Name)
    if(any(strcmp(ElementNames,Name{i})))
        Names = getfield(PropertyNames,Name{i});
        Name = Name{i};
        break;
    end
end

if(~isempty(Names)) % If 'names' field is NOT empty...
    % ...find 'vertex indices' property subfield
    PropertyName = {'vertex_indices','vertex_indexes','vertex_index','indices','indexes'};
    for i = 1:length(PropertyName)
        if(any(strcmp(Names,PropertyName{i})))
            PropertyName = PropertyName{i};
            break;
        end
    end
    % Convert face index list to triangular connectivity.
    if(~iscell(PropertyName))
        eval(['FaceIndices=Elements.', Name, '.', PropertyName, ';']);
        N = length(FaceIndices);
        triangle_node = zeros(3,N*2);
        Extra = 0;
        
        for k = 1:N
            triangle_node(1:3, k) = FaceIndices{k}(1:3)';
            for j = 4:length(FaceIndices{k})
                Extra = Extra + 1;
                triangle_node(1, N + Extra) = FaceIndices{k}(1);
                triangle_node(2, N + Extra) = FaceIndices{k}(j - 1);
                triangle_node(3, N + Extra) = FaceIndices{k}(j);
            end
        end
        % Add 1 to each vertex value; PLY vertices are zero based
        triangle_node = triangle_node(:,1:N + Extra) + 1;
    end
end
return
end

