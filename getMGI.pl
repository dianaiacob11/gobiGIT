#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;

use Getopt::Long;
use LWP::Simple;

my ($file, $dir, $debug);
if (@ARGV < 1){ die "Usage: $0 --file <path_to_gene_id_file> --dir <path_to_mgi_folder> [--d|debug]\n";}

my $result = GetOptions (
'file=s' => \$file,
'dir=s' => \$dir,
'd|debug' => \$debug
);

&usage() unless defined($file) && defined($dir);

open (DATEI, $file) or die "Cannot open $file\n";
my @fileContent = <DATEI>;

foreach my $id (@fileContent){
    chomp($id);
    #&saveNCBItoFasta($id);
}

sub usage{
    print "Incorrect parameters \n";
    print "Usage: ./getMGI --gene_id_file <path_to_gene_id_file> --dir <path_to_mgi_folder> [--d|debug]\n";
}

sub saveNCBItoFasta {
    my $id      = $_[0];
    my $url = 'http://www.informatics.jax.org/allele/report.txt?phenotype=Full+Mammalian+Phenotype+%28MP%29+Ontology+&nomen=' . $id;
    chomp $url;
    $url   .= '&chromosome=any&cm=&coordinate=&coordUnit=bp';
    
    my $content = get $url;
    if(defined $content){
        print "Success: ".$url."\n";
        my $fastaFile   = $dir."/".$id.".txt";
        open( FILE, '>', $fastaFile) or die("Could not open file ".$fastaFile." !");
        print FILE $content."\n";
        close (FILE);

    }
    else{
        print "Couldn't get ".$url." \n";
    }
    
}
__END__
#TODO: write pom
