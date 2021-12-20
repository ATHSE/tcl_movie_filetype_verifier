# tcl_movie_filetype_verifier (aka ftype)
A simple TCL commandline script to verify video media files match their extensions. Supports avi/mkv/mp4/mov/wmv.

This project started out to identify Flash Video files incorrectly named as one of the common video file types,
but since then, it evolved into a simplified header evaluation tool that can determine the supported video file
types also have correct headers.

In its current release form, the script is meant to be run through the shell/commandline, and will automatically
scan any supported video filenames found. The results of the scan will show on screen in two fields left of the
name, and a log will be created (ftype.log) in the same location, with the results. The scan will show one of two
results for each field, [valid] or [*inv*], for the type and subtypes respectively. The scanning is quick, and
does not attempt to read the entire file, or verify the videos are in fact functional or have valid data, this
tool is only reading the header region. The tool doesn't modify any files it scans.

A batchfile is included for Windows users, for everyone else the .tcl should be modified to include the shell 
comment as the first line. The script takes no commandline arguments, ignoring filetypes didn't seem to be of
importance given the speed it processes a directory.
