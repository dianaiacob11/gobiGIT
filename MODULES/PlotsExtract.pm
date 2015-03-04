package MODULES::PlotsExtract;

use strict;
use warnings;
use diagnostics;

#use DBI;
#use DBD::mysql;

use lib '.';
require MODULES::Database;

#my $db = MODULES::Database::connectToDB("gobi");


sub                 get_analysisMGI_phenotypes_nr{
    
=co
    my $tableDatasetA = 'loctree';
    my $tableDatasetB = "";
    my $query         = "";
    
    my  $query_count_total_datasetA  = " SELECT COUNT(*) FROM ".$tableDatasetA." l "
                                     . " JOIN sequences m ON m.md5sum = l.md5sum "
                                     . " JOIN ticket t ON t.jobID = m.jobID "
                                     . " WHERE m.jobID = '".$jobID."'";
    my $query_count_total_datasetB;
    
    if ($use_reference) {
        $tableDatasetB = 'loctree_reference';
        $query  = " SELECT t2.localization, t1.count_datasetA, t2.count_datasetB FROM "
                ." (SELECT DISTINCT localization, COUNT(*) AS 'count_datasetA' FROM ".$tableDatasetA." l "
                ." JOIN sequences m ON m.md5sum = l.md5sum "
                ." JOIN ticket t ON t.jobID = m.jobID "
                ." WHERE m.jobID = '".$jobID."'"
                ." GROUP BY localization) t1 "
                ." RIGHT OUTER JOIN "
                ." (SELECT DISTINCT localization, COUNT(*) AS 'count_datasetB' FROM ".$tableDatasetB
                ." GROUP BY localization) t2 "
                ." ON t1.localization = t2.localization ";
        $query_count_total_datasetB  = "SELECT COUNT(*) FROM ".$tableDatasetB;
    }
    else {
        $tableDatasetB = 'loctree';
        $query  = " SELECT t1.localization, t1.count_datasetA, t2.count_datasetB FROM "
                ." (SELECT DISTINCT l1.localization, COUNT(*) AS 'count_datasetA' FROM ".$tableDatasetA." l1 "
                ." JOIN sequences m1 ON m1.md5sum = l1.md5sum "
                ." JOIN ticket t1 ON t1.jobID = m1.jobID "
                ." WHERE m1.jobID = '".$jobID."'"
                ." AND m1.dataset = 1"
                ." GROUP BY localization) t1 "
                ." LEFT OUTER JOIN "
                ." (SELECT DISTINCT l2.localization, COUNT(*) AS 'count_datasetB' FROM ".$tableDatasetB." l2 "
                ." JOIN sequences m2 on m2.md5sum = l2.md5sum "
                ." JOIN ticket t2 ON t2.jobID = m2.jobID "
                ." WHERE m2.jobID = '".$jobID."'"
                ." AND m2.dataset = 2"
                ." GROUP BY localization) t2 "
                ." ON t1.localization = t2.localization "
                ." UNION "
                ." SELECT t2.localization, t1.count_datasetA, t2.count_datasetB FROM "
                ." (SELECT DISTINCT l1.localization, COUNT(*) AS 'count_datasetA' FROM ".$tableDatasetA." l1 "
                ." JOIN sequences m1 ON m1.md5sum = l1.md5sum "
                ." JOIN ticket t1 ON t1.jobID = m1.jobID "
                ." WHERE m1.jobID = '".$jobID."'"
                ." AND m1.dataset = 1"
                ." GROUP BY localization) t1 "
                ." RIGHT OUTER JOIN "
                ." (SELECT DISTINCT l2.localization, COUNT(*) AS 'count_datasetB' FROM ".$tableDatasetB." l2 "
                ." JOIN sequences m2 on m2.md5sum = l2.md5sum "
                ." JOIN ticket t2 ON t2.jobID = m2.jobID "
                ." WHERE m2.jobID = '".$jobID."'"
                ." AND m2.dataset = 2"
                ." GROUP BY localization) t2 "
                ." ON t1.localization = t2.localization ";
        $query_count_total_datasetA  .= " AND m.dataset = 1";
        $query_count_total_datasetB   = " SELECT COUNT(*) FROM ".$tableDatasetB." l "
                                      . " JOIN sequences m ON m.md5sum = l.md5sum "
                                      . " JOIN ticket t ON t.jobID = m.jobID "
                                      . " WHERE m.jobID = '".$jobID."' AND m.dataset = 2";

    }
    my $sth                = $db->prepare($query);
    my $sth_total_datasetA = $db->prepare($query_count_total_datasetA);
    my $sth_total_datasetB = $db->prepare($query_count_total_datasetB);
    
    $sth->execute() or die $DBI::errstr;
    $sth_total_datasetA->execute() or die $DBI::errstr;
    $sth_total_datasetB->execute() or die $DBI::errstr;
    
    my $total_datasetA = $sth_total_datasetA->fetchrow_array;
    my $total_datasetB = $sth_total_datasetB->fetchrow_array;
    
    my @row;
    my $localization        = '';
    my $percentage_dataset  = '';
    my $percentage_ref      = '';
    my $percentage_total    = '';
    
    while(@row = $sth->fetchrow_array){
        my $loc_norm = "'". $row[0] ."'"; # !! otherwise R won't work for string array
        $localization  = join(',', $localization, $loc_norm);
        chomp($localization);
        
        my $cd = $row[1]; #count dataset
        my $cr = $row[2]; #count reference
        if(!defined($cd)){
            $cd = 0;
        }
        if(!defined($cr)){
            $cr = 0;
        }
        
        # get percentage for dataset
        my $percentage_dataset_per_sequence = 0;
        if($total_datasetA != 0){
            $percentage_dataset_per_sequence = sprintf("%.1f",100*$cd/$total_datasetA);
        }
        
        my $percentage_dataset_per_sequence_norm =  "'".$cd."\n(". $percentage_dataset_per_sequence ."%)'";
        
        $percentage_dataset = join(',', $percentage_dataset, $percentage_dataset_per_sequence);
        chomp($percentage_dataset);
        
        $percentage_total = join(',', $percentage_total, $percentage_dataset_per_sequence_norm);
        chomp($percentage_total);
        
        # get percentage for reference
        my $percentage_ref_per_sequence = 0;
        if($total_datasetB != 0){
            $percentage_ref_per_sequence = sprintf("%.1f",100*$cr/$total_datasetB);
        }
        my $percentage_ref_per_sequence_norm =  "'".$cr."\n (". $percentage_ref_per_sequence ."%)'";
        
        $percentage_ref = join(',', $percentage_ref, $percentage_ref_per_sequence);
        chomp($percentage_ref);
        
        $percentage_total = join(',', $percentage_total, $percentage_ref_per_sequence_norm);
        chomp($percentage_total);
        
    }
    
    $localization       =~ s/.//;
    $percentage_dataset =~ s/.//;
    $percentage_ref     =~ s/.//;
    $percentage_total   =~ s/.//;
    
    return ($localization, $percentage_dataset, $percentage_ref, $total_datasetA, $total_datasetB, $percentage_total);
=cut
    my $phenotypes = '';
    my $phenotypes_per_nr = '';
    my $plotlabel = '';
    my $total_phenotypes = '';
    
    #extract from db ...
    
    $phenotypes = "'pheno1','pheno2','pheno3'";
    $phenotypes_per_nr = "1,2,3";
    $plotlabel = "'nr1','nr2','nr3'";
    $total_phenotypes = "50";
    
    return ($phenotypes, $phenotypes_per_nr, $plotlabel, $total_phenotypes);
}


1;
