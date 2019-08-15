/// @desc Parse <map><layer><data>
/// @arg layer_map the index of the map needed for adding layer data to

// get attributes
var layer_map = argument0;
ds_map_add(layer_map, "encoding", DerpXmlRead_CurGetAttribute("encoding"));
ds_map_add(layer_map, "compression", DerpXmlRead_CurGetAttribute("compression"));

// get children
while DerpXmlRead_Read() {
	var type = DerpXmlRead_CurType();
	var value =  DerpXmlRead_CurValue();
    show_debug_message("Parse <image>: " + type + ", " + value)
	
	switch (type) {
		case "Whitespace":
			break;
		case "Text":
			ds_map_add(layer_map, "data", value);
			break;
		case "OpenTag":
			break;
		case "CloseTag":
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