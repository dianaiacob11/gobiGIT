#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;

use Getopt::Long;
use LWP::Simple;
use Digest::MD5;
my $ctx = Digest::MD5->new;

my ($dir, $debug);
if (@ARGV < 1){ die "Usage: $0 --dir <path_to_MGI_file_directory> [--d|debug]\n";}

my $result = GetOptions (
'dir=s' => \$dir,
'd|debug' => \$debug
);

&usage() unless defined($dir);
my $count = 0;
opendir(DIR, $dir) or die "Cannot open $dir!";
my @dir = readdir DIR;

foreach my $file (@dir) {
    my $filePath = $dir."/".$file;
    open (DATEI, $filePath) or die "\nCannot open $filePath!\n";
    my @fileContent=<DATEI>;
    shift(@fileContent);
    
    foreach my $line (@fileContent){
        my @line_array = split(/\t/,$line);
        my $allele_id         = defined($line_array[0]) ? $line_array[0] : '' ;
        $allele_id            =~ s/\s+//g;
        my $len               = length($allele_id);
        my $allele_name       = defined($line_array[2]) ? $line_array[2] : '' ;
        my $chr               = defined($line_array[3]) ? $line_array[3] : '' ;
        my $allele_type       = defined($line_array[5]) ? $line_array[5] : '' ;
        my $allele_attributes = defined($line_array[6]) ? $line_array[6] : '' ;
        my $transmission      = defined($line_array[7]) ? $line_array[7] : '' ;
        my $phenotype         = defined($line_array[8]) ? $line_array[8] : '' ;
        
        if($len > 0 ){
            #print $allele_id.", ".$allele_name.", ".$chr.", ".$allele_type.", ".$allele_attributes.", ".$transmission."\n";
            &parsePhenotype($phenotype, $allele_id);
        }
    }

}

sub usage{
    print "Incorrect parameters \n";
    print "Usage: ./parseMGI --dir <path_to_MGI_file_directory> [--d|debug]\n";
}



sub parsePhenotype{
    my $pheno_string = $_[0]; # e.g. growth/size/body | homeostasis | limbs/digits/tail | skeleton
    my $allele_id    = $_[1]; # e.g. MGI:3604810
    my @pheno_array  = split(/\s+|\s+/, $pheno_string);
    foreach my $phenotype (@pheno_array)
    {
        if($phenotype ne "|")
        {
            my $phenotype_id = &getMD5ForPhenotype($phenotype);
            print $phenotype.",  ".$phenotype_id.",   ".$allele_id."\n";
            $count++;
            # insert in mgi_phenotype db
        }
    }

}

print $count."\n";

sub getMD5ForPhenotype{
    my $phenotype = $_[0];
    
    $ctx->add($phenotype);
    my $digest = $ctx->hexdigest;
    
    return $digest;
}

__END__
#TODO: write pom
