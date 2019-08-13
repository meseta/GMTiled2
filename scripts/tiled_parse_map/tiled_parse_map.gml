/// @desc Parse <map>

while DerpXmlRead_Read() {
	var type = DerpXmlRead_CurType();
	var value =  DerpXmlRead_CurValue();
    show_debug_message("Parse <map>: " + type + ", " + value)
	
	switch (type) {
		case "Whitespace":
			break;
		case "OpenTag":
			switch (value) {
				case "tileset":
					tiled_parse_tileset();
					break;
				case "layer":
					tiled_parse_layer();
					break;
				case "objectgroup":
					tiled_parse_objectgroup();
					break;
				default:
					show_error("Tiled Parse error: OpenTag " + value + " not supported in map", true)
			}
			break;
		case "CloseTag":
			if (value == "map") {
				return;
			}
			else {
				show_error("Tiled Parse error: unexpected CloseTag " + value + " in map", true)
			}
		default:
			show_error("Tiled Parse error: " + type + " not supported in map", true)
			break;
	}
}