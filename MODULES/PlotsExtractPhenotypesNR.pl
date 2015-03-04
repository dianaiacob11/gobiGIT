#!/usr/bin/perl

use strict;
use warnings;
use diagnostics;

use DBI;
use DBD::mysql;

require MODULES::Database;

my $db = MODULES::Database::connectToDB("gobi");

sub                 get_analysisMGI_phenotypes_nr_count{

	my $dbTable1            = 'mgi_phenotypes';
	my $dbTable2            = 'mgi';
    my $query              = "";

    $query   = " SELECT p.phenotype_name,m.allele_name,COUNT(*) AS count "
             . " FROM ".$dbTable1." p "
             . " JOIN ".$dbTable2." m "
             . " ON p.mgi_allele_id = m.allele_id"
             . " GROUP BY p.phenotype_name ORDER BY count DESC";

    my $sth       = $db->prepare($query);

    $sth->execute() or die $DBI::errstr;

    my @row;
    my $phenotypes = '';
    my $nr = '';
    my $count      = '';
    while(@row = $sth->fetchrow_array){
        my $pheno_norm = "'". $row[0] ."'"; # !! otherwise R won't work for string array
        $phenotypes  = join(',', $phenotypes, $pheno_norm);
        chomp($phenotypes);
        
        my $nr_norm = "'". $row[1] ."'";
        $nr = join(',', $nr, $nr_norm);
        chomp($nr);
        
        my $cnt =  "'". $row[2] ."'";
        $count  = join(',', $count, $cnt);
        chomp($count);
    }
    
    $phenotypes =~ s/.//;
    $nr 		=~ s/.//;
    $count      =~ s/.//;

    return ($phenotypes, $nr, $count);
}