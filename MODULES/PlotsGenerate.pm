package MODULES::PlotsGenerate;

use strict;
use warnings;
use diagnostics;

use lib '/Users/DianaIacob/perl5/lib/perl5/';
use Statistics::R;

my $R = Statistics::R->new();

sub                 plotVerticalString{
    my $x_axis                  = $_[0];
    my $y_axis                  = $_[1];
    my $filename                = $_[2];
    my $xlab                    = $_[3];
    my $ylab                    = $_[4];
    my $legend_phenotypes       = $_[5];
    my $legend_nr               = $_[6];
    my $label                   = $_[7];

    $R->send(qq (x_labels <- c($x_axis)));
    $R->send(qq (mydata <- data.frame(row.names = c($x_axis), Count = c($y_axis))));
    $R->send(qq (c(pdf("$filename", width=25, height=12),mp <- par(mar=c(25,7,4,2)))));
    $R->send(qq (mp <- barplot(t(as.matrix(mydata)), col="lightblue", border=NA, axes = FALSE, axisnames = FALSE, ylab="$ylab", cex.lab=1.5, cex.axis=3)));
    $R->send(qq (text(mp, par('usr')[3], labels = x_labels, srt = 45, adj = 1, xpd = TRUE, cex=1.5)));
    $R->send(qq (axis(2)));
    $R->send(qq (text(mp, 0, labels = c($label), cex = 0.8, pos=3, offset=3)));
    $R->send(qq (dev.off()));
    
    print "Plot done: ".$filename."!\n";
}

sub                 plotHeatmap{
    my $csv      = $_[0];
    my $filename = $_[1];
    
    $R->send(qq (library(gplots)));
    $R->send(qq (source("http://bioconductor.org/biocLite.R")));
    $R->send(qq (biocLite("Heatplus")));
    $R->send(qq (library(Heatplus)));
    $R->send(qq (library(RColorBrewer)));
    
    $R->send(qq (data <- read.csv("$csv", comment.char="#")));
    $R->send(qq (rnames <- data[,1]));
    $R->send(qq (mat_data <- data.matrix(data[,2:ncol(data)])));
    $R->send(qq (rownames(mat_data) <- rnames));
 
    $R->send(qq (c(pdf("$filename", width=20, height=20))));
    $R->send(qq (scaleyellowred <- colorRampPalette(c("lightyellow", "red"), space = "rgb")));
    $R->send(qq (heatmap.2(mat_data, margins =c(20,20), cexRow=2, cexCol=2, scale="none", key=T, keysize=0.5,
    density.info="none", trace="none", Rowv = NA, Colv = NA, symm=F ,symkey=T, col = scaleyellowred)));
    $R->send(qq (dev.off()));

    print "Plot done: ".$filename."!\n";
}
=co

sub                 plotString_Dataset_vs_Reference{
    my $rowNames                = $_[0];
    my $dataset                 = $_[1];
    my $reference               = $_[2];
    my $filename                = $_[3];
    my $xlab                    = $_[4];
    my $ylab                    = $_[5];
    my $legend_totalDataset     = $_[6];
    my $legend_totalReference   = $_[7];
    my $label                   = $_[8];
    my $width                   = $_[9];

    $R->run(qq(mydata <- data.frame(row.names = c($rowNames), Dataset = c($dataset), Reference= c($reference))));
    $R->run(qq (c(pdf("$filename", width = $width, height=7), x<-barplot(t(as.matrix(mydata)), col=c("lightgreen", "lightblue"), border=NA, ylab= "$ylab", xlab = "$xlab", beside=TRUE))));
    $R->run(qq (legend("topright", c("$legend_totalDataset", "$legend_totalReference"),fill=c("lightgreen", "lightblue"))));
    $R->run(qq (text(x, 0, labels = c($label), cex = 0.7, pos=3, offset=1.7)));
    $R->run(qq (dev.off()));

    print "Plot done: ".$filename." \n";
}


sub                 plotString_Dataset_vs_Reference_Percentage{
    my $rowNames                = $_[0];
    my $dataset                 = $_[1];
    my $reference               = $_[2];
    my $filename                = $_[3];
    my $xlab                    = $_[4];
    my $ylab                    = $_[5];
    my $legend_totalDataset     = $_[6];
    my $legend_totalReference   = $_[7];
    my $label                   = $_[8];
    my $width                   = $_[9];
    my $total_aa_dataset        = $_[10];
    my $total_aa_reference      = $_[11];
    
    $R->run(qq(mydata <- data.frame(row.names = c($rowNames), Dataset = c($dataset)/$total_aa_dataset*100, Reference= c($reference)/$total_aa_reference*100)));
    $R->run(qq (c(pdf("$filename", width = 15, height=7), x<-barplot(t(as.matrix(mydata)), col=c("lightgreen", "darkblue"), border=NA, ylab= "$ylab", xlab = "$xlab", beside=TRUE))));
    $R->run(qq (legend("topright", c("$legend_totalDataset", "$legend_totalReference"),fill=c("lightgreen", "darkblue"))));
    #$R->run(qq (text(x, 0, labels = c($label), cex = 0.5, pos=3, offset=1.7)));
    $R->run(qq (dev.off()));
    
    print "Plot done: ".$filename." \n";
}


sub                 plotString_Dataset_vs_Reference_Stacked{
    my $rowNames                = $_[0];
    my $dataset_0_40            = $_[1];
    my $dataset_41_80           = $_[2];
    my $dataset_81_100          = $_[3];
    my $reference_0_40          = $_[4];
    my $reference_41_80         = $_[5];
    my $reference_81_100        = $_[6];
    my $filename                = $_[7];
    my $xlab                    = $_[8];
    my $ylab                    = $_[9];
    my $legend1                 = $_[10];
    my $legend2                 = $_[11];
    my $legend3                 = $_[12];
    my $label                   = $_[13];
    
    $R->send(qq (x1 <- c($dataset_0_40)));
    $R->send(qq (x2 <- c($dataset_41_80)));
    $R->send(qq (x3 <- c($dataset_81_100)));
    $R->send(qq (y1 <- c($reference_0_40)));
    $R->send(qq (y2 <- c($reference_41_80)));
    $R->send(qq (y3 <- c($reference_81_100)));
    
    $R->send(qq (x_labels <- c($rowNames)));
    # Select columns based on how many elements are will be on the x axis
    my @tmp_data = split(',', $dataset_0_40);
    my $num_columns = @tmp_data;
    my $selected_columns = '';
    for (my $i = 0; $i < $num_columns; $i++) {
	$selected_columns .= $i+1;
	$selected_columns .= ',';
	$selected_columns .= $num_columns+$i+1;
	$selected_columns .= ',';
    }
    #remove trailing comma
    chop($selected_columns);

    $R->send(qq (mydata <- cbind(rbind(x3,x2,x1,0,0,0),rbind(0,0,0,y3,y2,y1))[,c($selected_columns)]) );
    $R->send(qq (c(pdf("$filename", width=8, height=7), x<-barplot(mydata, space=c(.75,.25), names=x_labels, col=c("darkblue", "lightblue", "lightgreen"), border=NA, ylab= "$ylab"))));
    $R->send(qq (axis(2)));
    $R->send(qq (legend("topright", cex = 0.8, c("$legend1", "$legend2", "$legend3"), fill = c("darkblue", "lightblue", "lightgreen"), bty = "n")));
    $R->send(qq (dev.off()));
    
    print "Plot done: ".$filename." \n";
}

sub                  plotPie{
    my $slices_dataset          = $_[0];
    my $labels_dataset          = $_[1];
    my $slices_reference        = $_[2];
    my $labels_reference        = $_[3];
    my $filename                = $_[4];
    my $label_dataset           = $_[5];
    my $label_ref               = $_[6];
    
    $R->send(qq (library(plotrix)));
    $R->send(qq (slices_dataset     <- c($slices_dataset)));
    $R->send(qq (lbls_dataset       <- c($labels_dataset)));
    $R->send(qq (slices_reference   <- c($slices_reference)));
    $R->send(qq (lbls_reference     <- c($labels_reference)));
    
    $R->send(qq (c(pdf("$filename", width = 20),par(mfrow = c(1,2)))));
    $R->send(qq (c(pie(slices_dataset, labels = lbls_dataset, main="$label_dataset"))));
    $R->send(qq (c(pie(slices_reference, labels = lbls_reference, main="$label_ref"))));
    $R->send(qq (dev.off()));
    
    print "Plot done: ".$filename."!\n";
    
}

sub                 plotLiniar{
    my $x1                      = $_[0];
    my $y1                      = $_[1];
    my $filename                = $_[2];
    my $xlab                    = $_[3];
    my $ylab                    = $_[4];
    my $legendText1             = $_[5];
    my $label1                  = $_[6];
    
    my $x2                      = $_[7];
    my $y2                      = $_[8];
    my $legendText2             = $_[9];
    my $label2                  = $_[10];
    
    $R->send(qq (x1 <- c($x1)));
    $R->send(qq (y1 <- c($y1)));
    $R->send(qq (x2 <- c($x2)));
    $R->send(qq (y2 <- c($y2)));
    
    #set the axes
    $R->send(qq (xmin <- if(min(x1) < min(x2)) min(x1) else min(x2)));
    $R->send(qq (xmax <- if(max(x1) > max(x2)) max(x1) else max(x2)));
    $R->send(qq (ymin <- if(min(y1) < min(y2)) min(y1) else min(y2)));
    $R->send(qq (ymax <- if(max(y1) > max(y2)) max(y1) else max(y2)));
    
    $R->send(qq (c(pdf("$filename"))));
    $R->send(qq (plot(x1, y1, type="o", axes=F, xlab="$xlab", ylab="$ylab", cex.lab=0.75, col="red", xlim=c(xmin,xmax), ylim=c(ymin,ymax))));
    $R->send(qq (lines(x2, y2, type="o", axes=F, pch=22, lty=2, col="blue")));
    $R->send(qq (text(x1, y1,labels = c($y1), cex = 0.5, pos=3, offset = 0.4, col="red")));
    $R->send(qq (text(x2, y2,labels = c($y2), cex = 0.5, pos=1, offset = 0.4, col="blue")));
    $R->send(qq (axis(1, xlim=c(xmin,xmax))));
    $R->send(qq (axis(2, ylim=c(ymin,ymax))));
    $R->send(qq (legend("topright", cex = 0.8, c("$legendText1", "$legendText2"), fill=c("red", "blue"))));
    $R->send(qq (dev.off()));
    
    print "Plot done: ".$filename."!\n";
}

sub                 plotVerticalXLabel_Dataset_vs_Reference{
    my $rowNames    = $_[0];
    my $dataset     = $_[1];
    my $reference   = $_[2];
    my $filename    = $_[3];
    my $ylab        = $_[4];
    my $num_sequences_dataset  = $_[5];
    my $num_sequences_reference = $_[6];
    
    $R->send(qq (x_labels <- c($rowNames)));
    $R->send(qq (mydata <- data.frame(row.names = c($rowNames), Dataset = c($dataset)/$num_sequences_dataset, Reference= c($reference)/$num_sequences_reference)));
    $R->send(qq (c(pdf("$filename", width=25, height=12),mp <- par(mar=c(13,7,4,2)))));
    $R->send(qq (mp <- barplot(t(as.matrix(mydata)), col=c("lightgreen", "lightblue"), border=NA, axes = FALSE, axisnames = FALSE, ylab="$ylab", beside=TRUE)));
    $R->send(qq (text(colMeans(mp), par('usr')[3], labels = x_labels, srt = 45, adj = 1, xpd = TRUE, cex=.6)));
    $R->send(qq (axis(2)));
    $R->send(qq (axis(4, las=0)));
    
    print "Plot done: ".$filename."!\n";
}

sub                 plotVerticalXLabel{
    my $x_label     = $_[0];
    my $y           = $_[1];
    my $filename    = $_[2];
    my $ylab        = $_[3];
    
    $R->send(qq (x_labels <- c($x_label)));
    $R->send(qq (y <- c($y)));
    $R->send(qq (c(pdf("$filename", width = 90),mp <- par(mar=c(13,7,4,2)))));
    $R->send(qq (mp <- barplot(y, col="lightblue", border=NA, axes = FALSE, axisnames = FALSE, ylab="$ylab") ));
    $R->send(qq (text(mp, par('usr')[3] - 0.25, labels = x_labels, srt = 45, adj = 1, xpd = TRUE, cex=.6)));
    $R->send(qq (axis(2)));
    $R->send(qq (axis(4, las=0)));
    
    print "Plot done: ".$filename."!\n";
}

sub                 plotOrganisms{
    my $x_label     = $_[0];
    my $y           = $_[1];
    my $filename    = $_[2];
    my $ylab        = $_[3];
    my $legend      = $_[4];
    
    $R->send(qq (x_labels <- c($x_label)));
    $R->send(qq (y <- c($y)));
    $R->send(qq (c(pdf("$filename", width = 20),mp <- par(mar=c(13,7,4,2)))));
    $R->send(qq (mp <- barplot(y, col="lightblue", border=NA, axes = FALSE, axisnames = FALSE, ylab="$ylab") ));
    $R->send(qq (text(mp, par('usr')[3] - 0.25, labels = x_labels, srt = 45, adj = 1, xpd = TRUE, cex=0.6)));
    $R->send(qq (legend("topleft", cex = 0.8, "$legend", bty = "n")));
    $R->send(qq (axis(2)));
    $R->send(qq (axis(4, las=0)));
    
    print "Plot done: ".$filename."!\n";
}

=cut

1;
