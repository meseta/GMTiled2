// converts #AARRGGBB into GM color using the most hacky method I know how

var value = string_lettersdigits(string_upper(argument0)); // get raw hex
var fake_ds_list = ds_list_create()
ds_list_read(fake_ds_list, "2E0100000100000007000000" + value);
var color = fake_ds_list[| 0] >> 8; // shift out alpha

ds_list_destroy(fake_ds_list);
return color;
