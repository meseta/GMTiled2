var tag_to_skip = argument0;

while DerpXmlRead_Read() {
    show_debug_message("Parse to skip: " + DerpXmlRead_CurType() + ", " + DerpXmlRead_CurValue())
	switch (DerpXmlRead_CurType()) {
		case "CloseTag":
			if (DerpXmlRead_CurValue() == tag_to_skip) return;
			break;
		case "Whitespace":
		case "OpenTag":
		default:
			break;
	}
}