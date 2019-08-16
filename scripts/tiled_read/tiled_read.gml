/// @desc Begin parsing root of XML
/// @arg filename name of the file to process

var filename = argument0
// TODO: check for file exists

// Cleanup DerpXml, we don't want to use them
with (objDerpXmlRead) instance_destroy();

// parse the file
DerpXml_Init();
DerpXmlRead_OpenFile(filename)

// datastructures needed
var all_data = ds_map_create();
ds_map_add_map(all_data, "map_attribs", ds_map_create());
ds_map_add_map(all_data, "tilesets", ds_map_create());
ds_map_add_list(all_data, "layers", ds_list_create());

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
with (objDerpXmlRead) instance_destroy();

return all_data;