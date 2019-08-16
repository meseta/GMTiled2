/// @desc Parse <map><layer><data>
/// @arg layer_map the index of the map needed for adding layer data to
var layer_map = argument0;

// get attributes
ds_map_add(layer_map, "encoding", DerpXmlRead_CurGetAttribute("encoding"));
ds_map_add(layer_map, "compression", DerpXmlRead_CurGetAttribute("compression"));

// get children
while DerpXmlRead_Read() {
	var type = DerpXmlRead_CurType();
	var value =  DerpXmlRead_CurValue();
    show_debug_message("Parse <data>: " + type + ", " + value)
	
	switch (type) {
		case DerpXmlType_Whitespace:
			break;
		case DerpXmlType_Text:
			ds_map_add(layer_map, "data", value);
			break;
		case DerpXmlType_OpenTag:
			break;
		case DerpXmlType_CloseTag:
			if (value == "data") {
				return;
			}
			else {
				show_error("Tiled Parse error: unexpected CloseTag " + value + " in data", true)
			}
		default:
			show_error("Tiled Parse error: " + value + " not supported in data", true)
			break;
	}
}