#!"c:/Strawberry/perl/bin/perl.exe"
use strict;
use warnings;
use CGI;
use DBI;
print "Content-type: text/html\n\n";
print <<HTML;
<!DOCTYPE html>
<html>
<head>
    
    <link rel="stylesheet" type="text/css" href="../estilosPerl124.css">
    <title>Actor id 5 </title>
</head>
<body>
    <a href="listado.pl">retroceder</a>
HTML

my $q=CGI->new;
print $q -> header('text/xml');

my $title=$q->param("title");
my $owner=$q->param("owner");
my $text=$q->param("text");

if(defined($title) and defined($owner) and defined($text)){
    if(renderText($owner,$title)){
        actualizar($title,$owner,$text);
        successUpdate($title,$text);
        
    }
    else{
        showUpdate();
    }
}
else{
    showUpdate();  
}

sub actualizar{
    my $titleQuery=$_[0];
    my $ownerQuery=$_[1];
    my $textQuery=$_[2];
    
    my $user = 'alumno';
    my $password= 'pweb1';
    my $dsn ='DBI:MariaDB:database=pweb1;host=192.168.1.9';
    my $dbh = DBI->connect($dsn,$user,$password) or die ("No se pudo conectar");
    
    
    my $sth=$dbh->prepare("UPDATE Articles SET text=? WHERE title=? AND owner=?");
    $sth->execute($textQuery,$titleQuery,$ownerQuery);
    $sth->finish;
    $dbh->disconnect;

}

sub renderText{
    my $ownerQuery=$_[0];
    my $titleQuery=$_[1];
    
   
    
    my $user = 'alumno';
    my $password= 'pweb1';
    my $dsn ='DBI:MariaDB:database=pweb1;host=192.168.1.9';
    my $dbh = DBI->connect($dsn,$user,$password) or die ("No se pudo conectar");
    
    
    my $sth=$dbh->prepare("SELECT text FROM Articles WHERE owner=? AND title=?");
    $sth->execute($ownerQuery,$titleQuery);
    my @row=$sth->fetchrow_array;
    $sth->finish;
    $dbh->disconnect;
    return $row[0];

}

sub successUpdate{            
    my $titleQuery= $_[0];
    my $textQuery= $_[1];
   
    my $body=<<XML;
    <article>
        <title>$titleQuery</title>
        <text>$textQuery</text>
    </article>
XML
        print(renderBody($body));
}


sub showUpdate{            
    my $body=<<XML;
    <article>
    </article>
XML
        print(renderBody($body));
}

sub renderBody{
    my $body=$_[0];
    my $xml=<<XML;
<?xml version="1.0" encoding="UTF-8"?>
$body
XML
    return $xml;
}
    




