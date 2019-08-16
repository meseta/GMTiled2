/// @desc Read a TMX file and parse out all of its data, returning a ds_map
///       Example usage 1: Simply read the tmx file, create the tiles, and then cleanup memory
///			var tiles = tiled_read("map1.tmx");
///         tiled_create(tiles);
///         tiled_cleanup(tiles);
///
///       Example usage 1: Read the tmx file, and create the tiles. Unload the tiles later
///			global.tiles = tiled_read("map1.tmx");
///         tiled_create(global.tiles);
///         // and then later...
///         tiled_destroy(global.tiles);
///
/// @arg filename name of the file to process

var filename = argument0

if (not file_exists(filename)) {
	show_error("TMX file " + filename + " does not exist!", true);	
}

// parse the file
DerpXmlRead_OpenFile(filename)

// datastructures needed
var all_data = ds_map_create();
ds_map_add_map(all_data, "map_attribs", ds_map_create());
ds_map_add_map(all_data, "tilesets", ds_map_create());
ds_map_add_list(all_data, "layers", ds_list_create());
ds_map_add_list(all_data, "new_layers", ds_list_create())
ds_map_add_map(all_data, "original_depths", ds_map_create())
ds_map_add_list(all_data, "new_instances", ds_list_create());

while (DerpXmlRead_Read()) {
	var type = DerpXmlRead_CurType();
	var value =  DerpXmlRead_CurValue();
    show_debug_message("Parse root: " + type + ", " + value)
	
	switch (type) {
		case DerpXmlType_Whitespace: // ignore
			break;
		case DerpXmlType_OpenTag:
			switch (value) {
				case "?xml": // ignore
					break;
				case "map":
					Xtiled_parse_map(all_data);
					break;
				default:
					show_error("Tiled Parse error: OpenTag " + value + " not supported in root", true)
			}
			break;
		case DerpXmlType_CloseTag:
		default:
			show_error("Tiled Parse error: " + type + " not supported in root", true)
			break;
	}
}

// Cleanup DerpXml
DerpXmlRead_CloseFile()

return all_data;