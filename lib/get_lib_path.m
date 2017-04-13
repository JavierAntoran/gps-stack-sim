function lib_path = get_lib_path()

    [lib_path, ~, ~] = fileparts(mfilename('fullpath'));

end