while DerpXmlRead_Read() {
    show_debug_message("Parse root: " + DerpXmlRead_CurType() + ", " + DerpXmlRead_CurValue())
	switch (DerpXmlRead_CurType()) {
		case "Whitespace": // ignore
			break;
		case "OpenTag":
			switch (DerpXmlRead_CurValue()) {
				case "?xml": // ignore
					break;
				case "map":
					tiled_parse_map();
					break;
				default:
					show_error("Tiled Parse error: OpenTag " + DerpXmlRead_CurValue() + " not supported in root", true)
			}
			break;
		case "CloseTag": 
			show_error("Tiled Pares error: CloseTag " + DerpXmlRead_CurValue() + " not supported in root", true)
			break;
		default:
			show_error("Tiled Parse error: " + DerpXmlRead_CurType() + " not supported in root", true)
			break;
	}
}