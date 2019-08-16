/// @desc A one-shot process function - just process a tmx file from start to end
///       use this for when you want to just load the tiles at the start of a room
///       and nothing fancy
///       Example usage:
///          tiled_oneshot("map1.tmx")
///
/// @arg filename name of the file to process
var filename = argument0;

var all_data = tiled_read(filename);
tiled_create(all_data);
tiled_cleanup(all_data);