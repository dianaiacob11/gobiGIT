package MODULES::PlotsExtract;

use strict;
use warnings;
use diagnostics;

use DBI;
use DBD::mysql;

use lib '.';
require MODULES::Database;

my $db = MODULES::Database::connectToDB("gobi");

sub                 get_analysisMGI_phenotypes_nr{
   
    my $dbTable1            = 'mgi_phenotypes';
    my $dbTable2            = 'mgi';
    my $dbTable3            = 'nr_mapping';
    my $query               = "";

    $query   = " SELECT p.phenotype_name,m.allele_name,count(*) AS count "
             . " FROM ".$dbTable1." p "
             . " JOIN ".$dbTable2." m "
             . " ON p.mgi_allele_id = m.allele_id "
             . " WHERE m.allele_name IN (SELECT gene_name FROM ".$dbTable3.")"
             . " GROUP BY p.phenotype_name, m.allele_name "
             . " ORDER BY count DESC ";

    my $sth       = $db->prepare($query);

    $sth->execute() or die $DBI::errstr;

    my @row;
    my $phenotypes = '';
    my $nr = '';
    my $count      = '';
    while(@row = $sth->fetchrow_array){
        $phenotypes  = join(',', $phenotypes, $row[0]);
        chomp($phenotypes);
        
        $nr = join(',', $nr, $row[1]);
        chomp($nr);
        
        $count  = join(',', $count, $row[2]);
        chomp($count);
    }
    
    $phenotypes =~ s/.//;
    $nr         =~ s/.//;
    $count      =~ s/.//;

    return ($phenotypes, $nr, $count);
    
}

sub                 get_analysisMGI_types_nr{
    
    my $dbTable1            = 'mgi';
    my $dbTable2            = 'nr_mapping';
    my $query               = "";
    
    $query   = " SELECT m.allele_type, m.allele_name, COUNT(*) AS count "
             . " FROM ".$dbTable1." m "
             . " WHERE m.allele_name IN (SELECT gene_name FROM ".$dbTable2.")"
             . " GROUP BY m.allele_type, m.allele_name "
             . " ORDER BY count DESC ";
    
    my $sth       = $db->prepare($query);
    
    $sth->execute() or die $DBI::errstr;
    
    my @row;
    my $types = '';
    my $nr = '';
    my $count      = '';
    while(@row = $sth->fetchrow_array){
        $types  = join(',', $types, $row[0]);
        chomp($types);
        
        $nr = join(',', $nr, $row[1]);
        chomp($nr);
        
        $count  = join(',', $count, $row[2]);
        chomp($count);
    }
    
    $types =~ s/.//;
    $nr         =~ s/.//;
    $count      =~ s/.//;
    
    return ($types, $nr, $count);
    
}

sub                 get_analysisMPI_phenotypes_strain_zscore2{
    
    my $dbTable1           = 'mpi_measnum';
    my $dbTable2           = 'mpi_strainmeans';
    my $dbTable3           = 'mpi_rs';
    my $query              = "";
    
    $query   = " SELECT m.phenotype, s.strain, COUNT(*) AS count "
             . " FROM ".$dbTable1." m "
             . " JOIN ".$dbTable2." s "
             . " ON m.measnum = s.measnum "
             . " WHERE score > 2 "
             . " AND s.strain IN (SELECT strain_name FROM ".$dbTable3.")"
             . " GROUP BY m.phenotype, s.strain "
             . " ORDER BY count DESC";
    
    my $sth       = $db->prepare($query);
    
    $sth->execute() or die $DBI::errstr;
    
    my @row;
    my $phenotypes = '';
    my $nr = '';
    my $count      = '';
    while(@row = $sth->fetchrow_array){
        if($row[2] > 2){
            $phenotypes  = join(',', $phenotypes, $row[0]);
            chomp($phenotypes);
            
            $nr = join(',', $nr, $row[1]);
            chomp($nr);
            
            $count  = join(',', $count, $row[2]);
            chomp($count);
        }
    }
    
    $phenotypes =~ s/.//;
    $nr         =~ s/.//;
    $count      =~ s/.//;
    
    return ($phenotypes, $nr, $count);
    
}

sub                 get_analysisMPI_phenotypes_nr_zscore2{
    
    my $dbTable1           = 'mpi_measnum';
    my $dbTable2           = 'mpi_strainmeans';
    my $dbTable3           = 'mpi_rs';
    my $query              = "";
    
    $query   = " SELECT m.phenotype, p.gene_name, COUNT(*) AS count "
             . " FROM ".$dbTable1." m "
             . " JOIN ".$dbTable2." s "
             . " ON m.measnum = s.measnum "
             . " JOIN ".$dbTable3." p "
             . " ON p.strain_name =  s.strain"
             . " WHERE score > 2 "
             . " GROUP BY m.phenotype, p.gene_name "
             . " ORDER BY count DESC";

    my $sth       = $db->prepare($query);
    $sth->execute() or die $DBI::errstr;
 
    my @row;
    my $phenotypes = '';
    my $nr = '';
    my $count      = '';

    while(@row = $sth->fetchrow_array){
        if($row[2] > 25000){
            $phenotypes  = join(',', $phenotypes, $row[0]);
            chomp($phenotypes);
            
            $nr = join(',', $nr, $row[1]);
            chomp($nr);
            
            $count  = join(',', $count, $row[2]);
            chomp($count);
        }
    }
    
    $phenotypes =~ s/.//;
    $nr         =~ s/.//;
    $count      =~ s/.//;
    
    return ($phenotypes, $nr, $count);
    
}

sub                 get_analysisMPI_phenotypes_nr_zscore2_neg{
    
    my $dbTable1           = 'mpi_measnum';
    my $dbTable2           = 'mpi_strainmeans';
    my $dbTable3           = 'mpi_rs';
    my $query              = "";
    
    $query   = " SELECT m.phenotype, p.gene_name, COUNT(*) AS count "
             . " FROM ".$dbTable1." m "
             . " JOIN ".$dbTable2." s "
             . " ON m.measnum = s.measnum "
             . " JOIN ".$dbTable3." p "
             . " ON p.strain_name =  s.strain"
             . " WHERE score < -2 "
             . " GROUP BY m.phenotype, p.gene_name "
             . " ORDER BY count DESC";
    
    my $sth       = $db->prepare($query);
    $sth->execute() or die $DBI::errstr;
    
    my @row;
    my $phenotypes = '';
    my $nr = '';
    my $count      = '';
    
    while(@row = $sth->fetchrow_array){
        if($row[2] > 45000){
            $phenotypes  = join(',', $phenotypes, $row[0]);
            chomp($phenotypes);
            
            $nr = join(',', $nr, $row[1]);
            chomp($nr);
            
            $count  = join(',', $count, $row[2]);
            chomp($count);
        }
    }
    
    $phenotypes =~ s/.//;
    $nr         =~ s/.//;
    $count      =~ s/.//;
    
    return ($phenotypes, $nr, $count);
    
}


sub                 get_analysisMPI_phenotypes_strain_zscore2_neg{
    
    my $dbTable1           = 'mpi_measnum';
    my $dbTable2           = 'mpi_strainmeans';
    my $dbTable3           = 'mpi_rs';
    my $query              = "";
    
    $query   = " SELECT m.phenotype, s.strain, COUNT(*) AS count "
             . " FROM ".$dbTable1." m "
             . " JOIN ".$dbTable2." s "
             . " ON m.measnum = s.measnum "
             . " WHERE score < -2 "
             . " AND s.strain IN (SELECT strain_name FROM ".$dbTable3.")"
             . " GROUP BY m.phenotype, s.strain "
             . " ORDER BY count DESC";
    
    my $sth       = $db->prepare($query);
    
    $sth->execute() or die $DBI::errstr;
    
    my @row;
    my $phenotypes = '';
    my $nr = '';
    my $count      = '';
    while(@row = $sth->fetchrow_array){
        if($row[2] > 150000){
            $phenotypes  = join(',', $phenotypes, $row[0]);
            chomp($phenotypes);
            
            $nr = join(',', $nr, $row[1]);
            chomp($nr);
            
            $count  = join(',', $count, $row[2]);
            chomp($count);
        }
    }
    
    $phenotypes =~ s/.//;
    $nr         =~ s/.//;
    $count      =~ s/.//;
    
    return ($phenotypes, $nr, $count);
    
}


sub                 get_analysisMGI_phenotypes_distribution{

    my $dbTable            = 'mgi_phenotypes';
    my $query              = "";
    my $query_total        = "";

    $query   = " SELECT phenotype_name, COUNT(*) AS count "
             . " FROM ".$dbTable
             . " GROUP BY phenotype_name "
             . " ORDER BY count DESC";
    $query_total = " SELECT COUNT(*) FROM ".$dbTable;
    
    my $sth       = $db->prepare($query);
    my $sth_total = $db->prepare($query_total);
    
    $sth->execute() or die $DBI::errstr;
    $sth_total->execute() or die $DBI::errstr;
    
    my $total_phenotypes = $sth_total->fetchrow_array;

    my @row;
    my $phenotypes = '';
    my $percentage = '';
    my $count      = '';
    while(@row = $sth->fetchrow_array){
        my $pheno_norm = "'". $row[0] ."'"; # !! otherwise R won't work for string array
        $phenotypes  = join(',', $phenotypes, $pheno_norm);
        chomp($phenotypes);
        
        my $percent = sprintf("%.2f",100 * $row[1]/$total_phenotypes);
        $percentage = join(',', $percentage, $percent);
        chomp($percentage);
        
        my $cnt =  "'".$row[1]."\n(". $percent ."%)'";
        $count  = join(',', $count, $cnt);
        chomp($count);
    }
    
    $phenotypes =~ s/.//;
    $percentage =~ s/.//;
    $count      =~ s/.//;

    return ($phenotypes, $percentage, $count, $total_phenotypes);
}


sub                 get_analysisMGI_type_distribution{
    
    my $dbTable            = 'mgi';
    my $query              = "";
    my $query_total        = "";
    
    $query   = " SELECT allele_type, COUNT(*) AS count "
             . " FROM ".$dbTable
             . " GROUP BY allele_type "
             . " ORDER BY count DESC";
    $query_total = " SELECT COUNT(*) FROM ".$dbTable;
    
    my $sth       = $db->prepare($query);
    my $sth_total = $db->prepare($query_total);
    
    $sth->execute() or die $DBI::errstr;
    $sth_total->execute() or die $DBI::errstr;
    
    my $total_types = $sth_total->fetchrow_array;
    
    my @row;
    my $types = '';
    my $percentage = '';
    my $count      = '';
    while(@row = $sth->fetchrow_array){
        my $type_norm = "'". $row[0] ."'"; # !! otherwise R won't work for string array
        $types  = join(',', $types, $type_norm);
        chomp($types);
        
        my $percent = sprintf("%.2f",100 * $row[1]/$total_types);
        $percentage = join(',', $percentage, $percent);
        chomp($percentage);
        
        my $cnt =  "'".$row[1]."\n(". $percent ."%)'";
        $count  = join(',', $count, $cnt);
        chomp($count);
    }
    
    $types =~ s/.//;
    $percentage =~ s/.//;
    $count      =~ s/.//;
    
    return ($types, $percentage, $count, $total_types);
}

sub                 get_analysisMPI_phenotypes_distribution_zscore2{
    
    my $dbTable1           = 'mpi_measnum';
    my $dbTable2           = 'mpi_strainmeans';
    my $query              = "";
    my $query_total        = "";
    
    $query   = " SELECT m.phenotype, COUNT(*) AS count "
             . " FROM ".$dbTable1." m "
             . " JOIN ".$dbTable2." s "
             . " ON m.measnum = s.measnum "
             . " WHERE score > 2 "
             . " GROUP BY m.phenotype "
             . " ORDER BY count DESC";
    $query_total = " SELECT COUNT(*) FROM ".$dbTable1;
    
    my $sth       = $db->prepare($query);
    my $sth_total = $db->prepare($query_total);
    
    $sth->execute() or die $DBI::errstr;
    $sth_total->execute() or die $DBI::errstr;
    
    my $total_phenotypes = $sth_total->fetchrow_array;
    
    my @row;
    my $phenotypes = '';
    my $percentage = '';
    my $count      = '';
    while(@row = $sth->fetchrow_array){
        my $pheno = $row[0];
        $pheno =~ s/\(//g;
        $pheno =~ s/\)//g;
        $pheno =~ s/\,/\-/g;

        if($row[1] > 20){
            my $pheno_norm = "'". $pheno ."'"; # !! otherwise R won't work for string array
            $phenotypes  = join(',', $phenotypes, $pheno_norm);
            chomp($phenotypes);
            
            my $percent = sprintf("%.2f",100 * $row[1]/$total_phenotypes);
            $percentage = join(',', $percentage, $percent);
            chomp($percentage);
            
            my $cnt =  "'".$row[1]."\n(". $percent ."%)'";
            $count  = join(',', $count, $cnt);
            chomp($count);

        }
    }
    
    $phenotypes =~ s/.//;
    $percentage =~ s/.//;
    $count      =~ s/.//;
    
    return ($phenotypes, $percentage, $count, $total_phenotypes);
}

sub                 get_analysisMPI_phenotypes_distribution_zscore2_neg{
    
    my $dbTable1           = 'mpi_measnum';
    my $dbTable2           = 'mpi_strainmeans';
    my $query              = "";
    my $query_total        = "";
    
    $query   = " SELECT m.phenotype, COUNT(*) AS count "
            . " FROM ".$dbTable1." m "
            . " JOIN ".$dbTable2." s "
            . " ON m.measnum = s.measnum "
            . " WHERE score < -2 "
            . " GROUP BY m.phenotype "
            . " ORDER BY count DESC";
    $query_total = " SELECT COUNT(*) FROM ".$dbTable1;
    
    my $sth       = $db->prepare($query);
    my $sth_total = $db->prepare($query_total);
    
    $sth->execute() or die $DBI::errstr;
    $sth_total->execute() or die $DBI::errstr;
    
    my $total_phenotypes = $sth_total->fetchrow_array;
    
    my @row;
    my $phenotypes = '';
    my $percentage = '';
    my $count      = '';
    while(@row = $sth->fetchrow_array){
        my $pheno = $row[0];
        $pheno =~ s/\(//g;
        $pheno =~ s/\)//g;
        $pheno =~ s/\,/\-/g;
        
        if($row[1] > 20){
            my $pheno_norm = "'". $pheno ."'"; # !! otherwise R won't work for string array
            $phenotypes  = join(',', $phenotypes, $pheno_norm);
            chomp($phenotypes);
            
            my $percent = sprintf("%.2f",100 * $row[1]/$total_phenotypes);
            $percentage = join(',', $percentage, $percent);
            chomp($percentage);
            
            my $cnt =  "'".$row[1]."\n(". $percent ."%)'";
            $count  = join(',', $count, $cnt);
            chomp($count);
            
        }
    }
    
    $phenotypes =~ s/.//;
    $percentage =~ s/.//;
    $count      =~ s/.//;
    
    return ($phenotypes, $percentage, $count, $total_phenotypes);
}

sub                 get_analysisMPI_snp_distribution{

    my $dbTable            = 'mpi_rs';
    my $query              = "";
    my $query_total        = "";

    $query   = " SELECT strain_name, COUNT(strain_name) AS count "
             . " FROM ".$dbTable
             . " GROUP BY strain_name "
             . " ORDER BY count DESC";
    $query_total = " SELECT COUNT(*) FROM ".$dbTable;
    
    my $sth       = $db->prepare($query);
    my $sth_total = $db->prepare($query_total);
    
    $sth->execute() or die $DBI::errstr;
    $sth_total->execute() or die $DBI::errstr;
    
    my $total_snp = $sth_total->fetchrow_array;

    my @row;
    my $strains = '';
    my $percentage = '';
    my $count      = '';
    while(@row = $sth->fetchrow_array){
        my $strain_norm = "'". $row[0] ."'"; # !! otherwise R won't work for string array
        $strains  = join(',', $strains, $strain_norm);
        chomp($strains);
        
        my $percent = sprintf("%.2f",100 * $row[1]/$total_snp);
        $percentage = join(',', $percentage, $percent);
        chomp($percentage);
        
        my $cnt =  "'".$row[1]."\n(". $percent ."%)'";
        $count  = join(',', $count, $cnt);
        chomp($count);
    }
    
    $strains =~ s/.//;
    $percentage =~ s/.//;
    $count      =~ s/.//;

    return ($strains, $percentage, $count, $total_snp);
}

sub                 get_analysisMPI_snp_function_distribution{

    my $dbTable            = 'ucsc_variants';
    my $query              = "";
    my $query_total        = "";

    $query   = " SELECT function, COUNT(function) AS count "
             . " FROM ".$dbTable
             . " GROUP BY function "
             . " ORDER BY count DESC";
    $query_total = " SELECT COUNT(*) FROM ".$dbTable;
    
    my $sth       = $db->prepare($query);
    my $sth_total = $db->prepare($query_total);
    
    $sth->execute() or die $DBI::errstr;
    $sth_total->execute() or die $DBI::errstr;
    
    my $total_function = $sth_total->fetchrow_array;

    my @row;
    my $function = '';
    my $percentage = '';
    my $count      = '';
    while(@row = $sth->fetchrow_array){
        my $function_norm = "'". $row[0] ."'"; # !! otherwise R won't work for string array
        $function  = join(',', $function, $function_norm);
        chomp($function);
        
        my $percent = sprintf("%.2f",100 * $row[1]/$total_function);
        $percentage = join(',', $percentage, $percent);
        chomp($percentage);
        
        my $cnt =  "'".$row[1]."\n(". $percent ."%)'";
        $count  = join(',', $count, $cnt);
        chomp($count);
    }
    
    $function =~ s/.//;
    $percentage =~ s/.//;
    $count      =~ s/.//;

    return ($function, $percentage, $count, $total_function);
}

sub                 get_analysisMPI_top10_strains_distribution{
    
    my $dbTable1           = 'mpi_strainmeans';
    my $dbTable2           = 'mpi_rs_strains';
    my $query              = "";
    my $query_total        = "";
    
    $query   = " SELECT DISTINCT strain as current_strain, (SELECT count(*) FROM ".$dbTable1." WHERE strain = current_strain) as count_strain, score "
             . " FROM mpi_strainmeans "
             . " WHERE strain IN (SELECT DISTINCT strain_name FROM ".$dbTable2." ) "
             . " ORDER BY score DESC "
             . " LIMIT 10 ";
    $query_total = " SELECT COUNT(*) FROM ".$dbTable1
                 . " WHERE strain IN (SELECT DISTINCT strain_name FROM ".$dbTable2." )";
    
    my $sth       = $db->prepare($query);
    my $sth_total = $db->prepare($query_total);
    
    $sth->execute() or die $DBI::errstr;
    $sth_total->execute() or die $DBI::errstr;
    
    my $total_strains = $sth_total->fetchrow_array;
    
    my @row;
    my $strains = '';
    my $percentage = '';
    my $count      = '';
    while(@row = $sth->fetchrow_array){
        my $strain_norm = "'". $row[0] ."'"; # !! otherwise R won't work for string array
        $strains  = join(',', $strains, $strain_norm);
        chomp($strains);
        
        my $percent = sprintf("%.2f",100 * $row[1]/$total_strains);
        $percentage = join(',', $percentage, $percent);
        chomp($percentage);
        
        my $cnt =  "'".$row[1]."\n(". $percent ."%)\n".$row[2]."'";
        $count  = join(',', $count, $cnt);
        chomp($count);
    }
    
    $strains =~ s/.//;
    $percentage =~ s/.//;
    $count      =~ s/.//;
    
    return ($strains, $percentage, $count, $total_strains);
}


1;
