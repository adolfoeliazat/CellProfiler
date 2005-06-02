function SaveImageAs(handles)

% Help for the Save Image As tool:
% Category: Image Tools
%
% Any image that is displayed can be saved to the hard drive in any
% standard image file format using this tool.  Type 'imformats' in the
% command window to see a list of acceptable file formats. To
% routinely save images that result from running an image analysis
% pipeline, use the SaveImages module.
% 
% See also <nothing relevant>.

% CellProfiler is distributed under the GNU General Public License.
% See the accompanying file LICENSE for details.
%
% Developed by the Whitehead Institute for Biomedical Research.
% Copyright 2003,2004,2005.
%
% Authors:
%   Anne Carpenter <carpenter@wi.mit.edu>
%   Thouis Jones   <thouis@csail.mit.edu>
%   In Han Kang    <inthek@mit.edu>
%
% $Revision$

MsgboxHandle = CPmsgbox('Click twice on the image you wish to save or hit anything on the keyboard to cancel. This window will be closed automatically.');
keyPress=waitforbuttonpress;
if keyPress == 0
    ClickedImage = getimage(gca);
    delete(MsgboxHandle)
    Answers = inputdlg({'Enter file name (no extension)','Enter image file format (e.g. tif,jpg)','If compatible with that file format, save as 16-bit image?'},'Save Image As',1,{'A','tif','no'});
    if isempty(Answers) ~= 1
        FileName = char(Answers{1});
        Extension = char(Answers{2});
        SixteenBit = char(Answers{3});
        if strcmp(SixteenBit,'yes') == 1
            ClickedImage = uint16(65535*ClickedImage);
        end
        CompleteFileName = [FileName,'.',Extension];
        %%% Checks whether the specified file name will overwrite an
        %%% existing file.
        ProposedFileAndPathname = [handles.Current.DefaultOutputDirectory,'/',CompleteFileName];%%% TODO: Fix filename construction.
        OutputFileOverwrite = exist(ProposedFileAndPathname,'file');
        if OutputFileOverwrite ~= 0
            Answer = CPquestdlg(['A file with the name ', CompleteFileName, ' already exists at ', handles.Current.DefaultOutputDirectory,'. Do you want to overwrite it?'],'Confirm file overwrite','Yes','No','No');
            if strcmp(Answer,'Yes') == 1;
                imwrite(ClickedImage, ProposedFileAndPathname, Extension)
                CPmsgbox(['The file ', CompleteFileName, ' has been saved to the default output directory.']);
            end
        else
            imwrite(ClickedImage, ProposedFileAndPathname, Extension)
            CPmsgbox(['The file ', CompleteFileName, ' has been saved to the default output directory.']);
        end
    else
        try %MsgboxHandle might already be deleted if button pressed is esc
            delete(MsgboxHandle);
        end
    end
end