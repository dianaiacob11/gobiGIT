#!/usr/bin/perl

use strict;
use warnings;
use diagnostics;

use lib '/Users/DianaIacob/perl5/lib/perl5/';
use Statistics::R;

my $R = Statistics::R->new();

=co
sub plotString_Dataset_vs_Reference{
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
    
    print "<p>$rowNames, $dataset, $reference</p>";
    $R->startR();
    
    $R->send(qq(mydata <- data.frame(row.names = c($rowNames), Dataset = c($dataset), Reference= c($reference))));
            print "<p>q2</p>";
    $R->send(qq (c(pdf("$filename", width = $width, height=7), x<-barplot(t(as.matrix(mydata)), col=c("lightgreen", "lightblue"), border=NA, ylab= "$ylab", xlab = "$xlab", beside=TRUE))));
    $R->send(qq (legend("topright", c("$legend_totalDataset", "$legend_totalReference"),fill=c("lightgreen", "lightblue"))));
    $R->send(qq (text(x, 0, labels = c($label), cex = 0.7, pos=3, offset=1.7)));
    $R->send(qq (dev.off()));

    print "<p>Plot done: $filename</p>";
    $R->stopR();
}

# perl /mnt/project/microbium/scripts/analysisLC3_distribution_RI.pl
sub plotString_Dataset_vs_Reference_Stacked{
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
    $R->send(qq (mydata <- cbind(rbind(x3,x2,x1,0,0,0),rbind(0,0,0,y3,y2,y1))[,c(1,7,2,8,3,9,4,10,5,11,6,12)]) );
    $R->send(qq (c(pdf("$filename", width=10, height=7), x<-barplot(mydata, space=c(.75,.25), names=x_labels, col=c("blue", "red", "pink"), border=NA, ylab= "$ylab"))));
    #$R->send(qq (text(colMeans(mydata), par('usr')[3] - 0.25, labels = x_labels, srt = 45, adj = 1, xpd = TRUE, cex=.6)));
    #$R->send(text(x, cbind(rbind$x3-10), labels=round(cbind(rbind$x3)), col="black");
    #text(x, mydata$Male+10, labels=100-round(mydata$Male))
    $R->send(qq (axis(2)));
    $R->send(qq (legend("topright", cex = 0.8, c("$legend1", "$legend2", "$legend3"), fill = c("blue", "red", "pink"), bty = "n")));
    $R->send(qq (dev.off()));
    
    print "Plot done: ".$filename."!\n";
}
=cut
&plotString();
# perl /mnt/project/microbium/scripts/analysisSEQUENCE_residue_distribution.pl
sub plotString{
    #my $rowNames                = $_[0];
    #my $dataset                 = $_[1];
    #my $filename                = $_[2];
    #my $xlab                    = $_[3];
    #my $ylab                    = $_[4];
    #my $legendText              = $_[5];
    #my $label                   = $_[6];
    
    my $rowNames = "'pheno1', 'pheno2', 'pheno3'";
    my $dataset = "'nr1', 'nr2', 'nr3', 'nr4'";
    my $filename = "/Users/DianaIacob/Desktop/plotTest.pdf";
    my $xlab = "Phenotypes";
    my $ylab = "Nuclear receptors";
    my $legendText = "MGI Phenotypes for Nuclear Receptors";

    
    $R->send(qq (mydata <- data.frame(row.names = c($rowNames), Dataset = c($dataset))));
    $R->send(qq (c(png("$filename", width=1500, height=900), x<-barplot(t(as.matrix(mydata)), col="lightblue", border=NA, ylab= "$ylab", xlab = "$xlab"))));
    $R->send(qq (legend("topright", c("$legendText"), fill = "lightblue")));
    #$R->send(qq (text(x, 0, labels = c($label), cex = 0.8, pos=3, offset=3)));
    $R->send(qq (dev.off()));
    
    print "Plot done: ".$filename."!\n";
}
=co

# perl /mnt/project/microbium/scripts/analysisSEQUENCE_length.pl
sub plotHistogram_Percentage{
    my $x                       = $_[0];
    my $y                       = $_[1];
    my $filename                = $_[2];
    my $xlab                    = $_[3];
    my $ylab                    = $_[4];
    my $legendText              = $_[5];
    my $breaks                  = $_[6];
    my $line                    = $_[7];
    
    $R->send(qq (x <- c($x)));
    $R->send(qq (y <- c($y)));
    $R->send(qq (line <- c($line)));
    $R->send(qq (h = hist(x, y, breaks=$breaks, main="")));
    $R->send(qq (h\$density = h\$counts/sum(h\$counts)*100));
    $R->send(qq (labs <- paste(round(h\$density, 2), "%", sep="")));
    $R->send(qq (c(pdf("$filename", width=20, height=12))));
    $R->send(qq (plot(h, freq=F, labels = labs, main="", xlab = "$xlab", ylab = "$ylab", col="lightgreen", labels.cex=1.5)));
    $R->send(qq (lines(line, line, col="blue")));
    $R->send(qq (legend("topright", c("$legendText"),fill = "lightgreen")));
    $R->send(qq (dev.off()));
    
    print "Plot done:". $filename ."!\n";
    
}

sub plotHistogram_Frequency{
    my $x                       = $_[0];
    my $y                       = $_[1];
    my $filename                = $_[2];
    my $xlab                    = $_[3];
    my $ylab                    = $_[4];
    my $legendText              = $_[5];
    my $breaks                  = $_[6];
    
    $R->send(qq (x <- c($x)));
    $R->send(qq (y <- c($y)));
    $R->send(qq (c(png("$filename", width=1500, height=900), hist(x, y, breaks=$breaks, label = TRUE, main="", xlab = "$xlab", ylab = "$ylab", col="lightgreen"), legend("topright", c("$legendText"),fill = "lightgreen"), dev.off())));
    
    print "Plot done: ".$filename."!\n";
    
}

#perl /mnt/project/microbium/scripts/analysisSOMENA.pl
#perl /mnt/project/microbium/scripts/analysisTMSEG.pl
sub plotPie{
    my $slices_dataset          = $_[0];
    my $labels_dataset          = $_[1];
    my $slices_reference        = $_[2];
    my $labels_reference        = $_[3];
    my $filename                = $_[4];
    
    $R->send(qq (library(plotrix)));
    $R->send(qq (slices_dataset     <- c($slices_dataset)));
    $R->send(qq (lbls_dataset       <- c($labels_dataset)));
    $R->send(qq (slices_reference   <- c($slices_reference)));
    $R->send(qq (lbls_reference     <- c($labels_reference)));
    
    $R->send(qq (c(pdf("$filename", width = 20),par(mfrow = c(1,2)))));
    $R->send(qq (c(pie(slices_dataset, labels = lbls_dataset, main="Dataset"))));
    $R->send(qq (c(pie(slices_reference, labels = lbls_reference, main="Reference"))));
    $R->send(qq (dev.off()));
    
    print "Plot done: ".$filename."!\n";

}

#perl /mnt/project/microbium/scripts/analysisMDISORDER_regions_for_threshold.pl
sub plotLiniar{
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

#perl /mnt/project/microbium/scripts/analysisMETASTUDENT_distribution.pl
sub plotVerticalXLabel{
    my $x_label     = $_[0];
    my $y           = $_[1];
    my $filename    = $_[2];
    my $ylab        = $_[3];
    # my $legend      = $_[4];
    
    $R->send(qq (x_labels <- c($x_label)));
    $R->send(qq (y <- c($y)));
    $R->send(qq (c(pdf("$filename", width = 90),mp <- par(mar=c(13,7,4,2)))));
    $R->send(qq (mp <- barplot(y, col="lightblue", border=NA, axes = FALSE, axisnames = FALSE, ylab="$ylab") ));
    $R->send(qq (text(mp, par('usr')[3] - 0.25, labels = x_labels, srt = 45, adj = 1, xpd = TRUE, cex=.6)));
    # $R->send(qq (legend("topleft", cex = 0.8, "$legend")));
    $R->send(qq (axis(2)));
    $R->send(qq (axis(4, las=0)));

    
    print "Plot done: ".$filename."!\n";
}

#perl /mnt/project/microbium/scripts/analysisBLAST_organism_distribution.pl
sub plotOrganisms{
    my $x_label     = $_[0];
    my $y           = $_[1];
    my $filename    = $_[2];
    my $ylab        = $_[3];
    my $legend      = $_[4];
    
    $R->send(qq (x_labels <- c($x_label)));
    $R->send(qq (y <- c($y)));
    $R->send(qq (c(pdf("$filename", width = 20),mp <- par(mar=c(13,7,4,2)))));
    $R->send(qq (mp <- barplot(y, col="lightblue", border=NA, axes = FALSE, axisnames = FALSE, ylab="$ylab") ));
    $R->send(qq (text(mp, par('usr')[3] - 0.25, labels = x_labels, srt = 45, adj = 1, xpd = TRUE, cex=.6)));
    $R->send(qq (legend("topleft", cex = 0.8, "$legend", bty = "n")));
    $R->send(qq (axis(2)));
    $R->send(qq (axis(4, las=0)));
    
    
    print "Plot done: ".$filename."!\n";
}


sub plotVerticalXLabel_Dataset_vs_Reference{
    my $rowNames    = $_[0];
    my $dataset     = $_[1];
    my $reference   = $_[2];
    my $filename    = $_[3];
    my $ylab        = $_[4];
    
    $R->send(qq (x_labels <- c($rowNames)));
    $R->send(qq (mydata <- data.frame(row.names = c($rowNames), Dataset = c($dataset), Reference= c($reference))));
    $R->send(qq (c(pdf("$filename", width=25, height=12),mp <- par(mar=c(13,7,4,2)))));
    $R->send(qq (mp <- barplot(t(as.matrix(mydata)), col=c("lightgreen", "lightblue"), border=NA, axes = FALSE, axisnames = FALSE, ylab="$ylab", beside=TRUE)));
    $R->send(qq (text(colMeans(mp), par('usr')[3] - 0.25, labels = x_labels, srt = 45, adj = 1, xpd = TRUE, cex=.6)));
    $R->send(qq (axis(2)));
    $R->send(qq (axis(4, las=0)));
    
    
    print "Plot done: ".$filename."!\n";
}
=cut

1;
