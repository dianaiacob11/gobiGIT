package MODULES::Database;

use strict;
use warnings;
use diagnostics;

use DBI;
use DBD::mysql;

sub                 connectToDB{
    my $database    = $_[0];
    my $host        = "164.177.170.83";
    my $user        = "root";
    my $pw          = "";
    
    my $dsn         = "dbi:mysql:$database:$host";
    my $dbh = DBI->connect($dsn, $user, $pw) or die "Error connecting to database.";
    
    return $dbh;
}

sub                 insert_nr_mapping_db{
    my $dbTable = "nr_mapping";
    my $db = &connectToDB("gobi");
    
    my $query = " INSERT IGNORE INTO ".$dbTable." (gene_id, transcript_id, protein_id, gene_name, sequence, mouse_id ) VALUES (?,?,?,?,?,?) ";
    #print $query."\n";
    my $sth = $db->prepare($query);
    $sth->execute($_[0], $_[1], $_[2], $_[3], $_[4], $_[5]);
}

sub                insert_mgi_db{
    my $dbTable = "mgi";
    my $db = &connectToDB("gobi");
    
    my $query = " INSERT IGNORE INTO ".$dbTable." (allele_id, allele_name, chromosome, allele_type, allele_attributes, transmission) VALUES (?,?,?,?,?,?) ";
    #print $query."\n";
    my $sth = $db->prepare($query);
    $sth->execute($_[0], $_[1], $_[2], $_[3], $_[4], $_[5]);
}

sub                 insert_mgi_phenotypes_db{
    my $dbTable = "mgi_phenotypes";
    my $db = &connectToDB("gobi");
    
    my $query = " INSERT INTO ".$dbTable." (md5sum_id, phenotype_name, mgi_allele_id) VALUES (?,?,?) ";
    #print $query."\n";
    my $sth = $db->prepare($query);
    $sth->execute($_[0], $_[1], $_[2]);
}

sub                 insert_mpi_measnum_db{
    my $dbTable = "mpi_measnum";
    my $db = &connectToDB("gobi");
    
    my $query = " INSERT IGNORE INTO ".$dbTable." (measnum, phenotype) VALUES (?,?) ";
    #print $query."\n";
    my $sth = $db->prepare($query);
    $sth->execute($_[0], $_[1]);
}

sub                 insert_mpi_rs_strains_db{
    my $dbTable = "mpi_rs_strains";
    my $db = &connectToDB("gobi");
    
    my $query = " INSERT IGNORE INTO ".$dbTable." (strain_name) VALUES (?) ";
    #print $query."\n";
    my $sth = $db->prepare($query);
    $sth->execute($_[0]);
}

sub                 insert_mpi_rs_db{
    my $dbTable = "mpi_rs";
    my $db = &connectToDB("gobi");
    
    my $query = " INSERT IGNORE INTO ".$dbTable." (gene_name, rs_id, expected, observed, strain_name, substitution) VALUES (?,?,?,?,?,?)";
    #print $query."\n";
    my $sth = $db->prepare($query);
    $sth->execute($_[0], $_[1], $_[2], $_[3], $_[4], $_[5]);
}

sub                 insert_mpi_strainmeans_db{
    
    my $dbTable = "mpi_strainmeans";
    my $db = &connectToDB("gobi");
    
    my $query = " INSERT IGNORE INTO ".$dbTable." (measnum, strain, strain_id, sex, mean, number_mice, minval, maxval, score) VALUES (?,?,?,?,?,?,?,?,?)";
    #print $query."\n";
    my $sth = $db->prepare($query);
    $sth->execute($_[0], $_[1], $_[2], $_[3], $_[4], $_[5], $_[6], $_[7], $_[8]);
}

1;

__END__
