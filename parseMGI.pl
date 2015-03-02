#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;

use Getopt::Long;
use LWP::Simple;
use Digest::MD5;
use DBI;
my $ctx = Digest::MD5->new;

my $database = "gobi";
my $db = &connectToDB($database);

my ($dir, $debug);
if (@ARGV < 1){ die "Usage: $0 --dir <path_to_MGI_file_directory> [--d|debug]\n";}

my $result = GetOptions (
'dir=s' => \$dir,
'd|debug' => \$debug
);

&usage() unless defined($dir);

opendir(DIR, $dir) or die "Cannot open $dir!";
my @dir = readdir DIR;

foreach my $file (@dir) {
    my $filePath = $dir."/".$file;
    open (DATEI, $filePath) or die "\nCannot open $filePath!\n";
    my @fileContent=<DATEI>;
    shift(@fileContent);
    
    foreach my $line (@fileContent){
        my @line_array = split(/\t/,$line);
        my $allele_id         = defined($line_array[0]) ? $line_array[0] : "" ;
        $allele_id =~s/\s+//g;
        my $len = length($allele_id);
        my $allele_name       = defined($line_array[2]) ? $line_array[2] : "" ;
        my $chr               = defined($line_array[3]) ? $line_array[3] : "" ;
        my $allele_type       = defined($line_array[5]) ? $line_array[5] : "" ;
        my $allele_attributes = defined($line_array[6]) ? $line_array[6] : "" ;
        my $transmission      = defined($line_array[7]) ? $line_array[7] : "" ;
        my $phenotype         = defined($line_array[8]) ? $line_array[8] : "" ;
        
        if ($len > 0){
        #    insertToMGIDB($allele_id, $allele_name, $chr, $allele_type, $allele_attributes, $transmission);
        #insert in mgi db
        
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
            #print $phenotype."\n".$phenotype_id."\n".$allele_id."\n";
            # insert in mgi_phenotype db
            insertToPhenotypeDB($phenotype_id, $phenotype, $allele_id);
        }
    }

}

sub getMD5ForPhenotype{
    my $phenotype = $_[0];
    
    $ctx->add($phenotype);
    my $digest = $ctx->hexdigest;
    
    return $digest;
}

sub connectToDB{
    
    my $database    = $_[0];
    my $host        = "164.177.170.83";
    my $user        = "root";
    my $pw          = "";
    
    my $dsn         = "dbi:mysql:$database:$host";
    my $dbh = DBI->connect($dsn, $user, $pw) or die "Error connecting to database.";
    
    return $dbh;
}

sub insertToMGIDB{
    
    my $dbTable = "mgi";
    my $query = "INSERT IGNORE INTO ".$dbTable."(allele_id, allele_name, chromosome, allele_type, allele_attributes, transmission ) VALUES (?,?,?,?,?,?)";
    print $query."\n";
    my $sth = $db->prepare($query);
    $sth->execute($_[0], $_[1], $_[2], $_[3], $_[4], $_[5]);    
}

sub insertToPhenotypeDB{
    
    my $dbTable = "mgi_phenotypes";
    my $query = "INSERT INTO ".$dbTable."(md5sum_id, phenotype_name, mgi_allele_id) VALUES (?,?,?)";
    print $query."\n";
    my $sth = $db->prepare($query);
    $sth->execute($_[0], $_[1], $_[2]);    
}

__END__
#TODO: write pom
