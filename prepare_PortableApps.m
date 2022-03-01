currentPath = fileparts(mfilename('fullpath'), 'path');
% check Nelson is in good directory .\App\Nelson\PortableApps
modulesPath = [currentPath, '/App/Nelson/PortableApps/modules'];
if ~isdir(modulesPath)
    error('modules path not found.');
end
nelsonGuiFullFilename = [currentPath, '/App/Nelson/PortableApps/bin/win32/NelSon-gui.exe'];
if ~isfile(nelsonGuiFullFilename)
    error('NelSon-gui not found.');
end

nelsonCliFullFilename = [currentPath, '/App/Nelson/PortableApps/bin/win32/nelSon-cli.exe'];
if ~isfile(nelsonCliFullFilename)
    error('NelSon-cli not found.');
end

% check Nelson is win32
commandCheckWin32 = [nelsonCliFullFilename, '  --quiet -e "disp(computer(''arch'')),exit"'];
[s, output] = unix(commandCheckWin32);
if (s ~= 0 || ~contains(output, 'win32'))
    error('NelSon win32 expected.');
end

% Get Version numbers
[s, output] = unix([nelsonCliFullFilename, '  --version']);
if s ~= 0
    error('Cannot read version.');
end
output = replace(output, 'Nelson version: ', '');
output = replace(output, '"', '');
packageVersionText = replace(output, char(10), '');

lastDoPosition = find(packageVersionText == '.', 1, 'last');
displayVersionText =  packageVersionText(1:lastDoPosition-1);

% update version in .\App\Nelson\Nelson.nsi
nelsonNsiPathTemplate = [currentPath, '/App/Nelson/Nelson.nsi.template'];
nelsonNsiPath = [currentPath, '/App/Nelson/Nelson.nsi'];
if ~isfile(nelsonNsiPathTemplate)
    error('Nelson.nsi.template not found.');
end
txt = fileread(nelsonNsiPathTemplate);
txt = replace(txt, '0.0.0.0', packageVersionText);
filewrite(nelsonNsiPath, txt);

% update version in .\App\AppInfo\appinfo.ini
appInfoPathTemplate = [currentPath, '/App/AppInfo/appinfo.ini.template'];
appInfoPath = [currentPath, '/App/AppInfo/appinfo.ini'];

if ~isfile(appInfoPathTemplate)
    error('appinfo.ini.template not found.');
end
txt = fileread(appInfoPathTemplate);
txt = replace(txt, '0.0.0.0', packageVersionText);
txt = replace(txt, '0.0.0', displayVersionText);

filewrite(appInfoPath, txt);

