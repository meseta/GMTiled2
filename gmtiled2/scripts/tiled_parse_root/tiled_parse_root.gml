/// @desc Begin parsing root of XML

while (DerpXmlRead_Read()) {
	var type = DerpXmlRead_CurType();
	var value =  DerpXmlRead_CurValue();
    show_debug_message("Parse root: " + type + ", " + value)
	
	switch (type) {
		case "Whitespace": // ignore
			break;
		case "OpenTag":
			switch (value) {
				case "?xml": // ignore
					break;
				case "map":
					tiled_parse_map();
					break;
				default:
					show_error("Tiled Parse error: OpenTag " + value + " not supported in root", true)
			}
			break;
		case "CloseTag":
		default:
			show_error("Tiled Parse error: " + type + " not supported in root", true)
			break;
	}
}