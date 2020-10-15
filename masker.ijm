run("Clear Results");

Dialog.create("check:"); Dialog.addMessage("Make sure the image filenames do not have spaces otherwise this will not work!");Dialog.show();

input = getDirectory("Choose Image Directory");
output = getDirectory("Choose Output Directory");

list = getFileList(input);
var n_channels; Dialog.create("Channels");
Dialog.addMessage("Please enter the number of channels you have?");
Dialog.addNumber("Channels",n_channels); Dialog.show();
n_channels = Dialog.getNumber();

var c; Dialog.create("reference"); Dialog.addMessage("Enter the number of the reference channel to make the mask");
Dialog.addNumber("Channel number: ",c); Dialog.show(); c = Dialog.getNumber();


Dialog.create("check:"); Dialog.addMessage("Make sure Split Channels is unchecked!");Dialog.show();

var i=0;

while(i < list.length)
{
	
	file = input+list[i]; open(file);

	T = getTitle();	selectWindow(T);

	run("Split Channels");
	selectWindow("C"+c+"-"+T);
	setThreshold(1000, 65505);
	setOption("BlackBackground", true);
	run("Convert to Mask");
	run("16-bit");	

	for (j = 1; j <= n_channels; j++) 
	{	
		if(j!=c)
		{
			run("Colocalization Threshold", "channel_1=C"+c+"-"+T+" channel_2=C"+j+"-"+T+" use=None channel=[Red : Green] show include");
			run("Split Channels");
			selectWindow("Colocalized Pixel Map RGB Image (blue)"); close();
			selectWindow("Colocalized Pixel Map RGB Image (green)");close();
			selectWindow("Colocalized Pixel Map RGB Image (red)"); run("16-bit");
			saveAs("Tiff",output+"MASK_"+T+"_slice"+c+"_referenced_to_Slice"+j+".tiff");
		}
	}

	run("Close All");

	i++;

}

Dialog.create("Completed"); Dialog.addMessage("Completed! Please check your "+output+" folder to see the saved masked images.");Dialog.show();
