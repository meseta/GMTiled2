while DerpXmlRead_Read() {
    show_debug_message("Parse map: " + DerpXmlRead_CurType() + ", " + DerpXmlRead_CurValue())
	switch (DerpXmlRead_CurType()) {
		case "Whitespace":
			break;
		case "OpenTag":
			switch (DerpXmlRead_CurValue()) {
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
					show_error("Tiled Parse error: OpenTag " + DerpXmlRead_CurValue() + " not supported in map", true)
			}
			break;
		case "CloseTag":
			return;
		default:
			show_error("Tiled Parse error: " + DerpXmlRead_CurType() + " not supported in map", true)
			break;
	}
}