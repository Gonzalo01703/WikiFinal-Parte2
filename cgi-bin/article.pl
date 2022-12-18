#!"c:/Strawberry/perl/bin/perl.exe"
use strict;
use warnings;
use CGI;
use DBI;

my $q=CGI->new;
print $q -> header('text/xml');
my $owner=$q->param("propietario");
my $title=$q->param("titulo");

if(defined($owner) and defined($title) ){
    if(renderText($owner,$title)){
        my $text=renderText($owner,$title);
        successArticle($owner,$title,$text);
    }
    else{
        showArticle();
    }
}


else{
    showArticle();
}


sub renderText{
    my $ownerQuery=$_[0];
    my $titleQuery=$_[1];

    my $user = 'alumno';
    my $password= 'pweb1';
    my $dsn ='DBI:MariaDB:database=pweb1;host=192.168.1.9';
    my $dbh = DBI ->connect($dsn,$user,$password) or die ("No se pudo conectar");

    my $sth=$dbh->prepare("SELECT text FROM Articles WHERE owner=? AND title=?");
    $sth->execute($ownerQuery,$titleQuery);
    my @row=$sth->fetchrow_array;
    $sth->finish;
    $dbh->disconnect;
    return @row[0];
}
sub successArticle{            
    my $ownerQuery= $_[0];
    my $titleQuery= $_[1];
    my $textQuery = $_[2];
    my $body=<<XML;
    <article>
        <owner>$ownerQuery</owner>
        <title>$titleQuery</title>
        <text>$textQuery</text>
    </article>
XML
        print(renderBody($body));
}

sub showArticle{            
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