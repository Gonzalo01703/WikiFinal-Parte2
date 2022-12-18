#!"c:/Strawberry/perl/bin/perl.exe"
use strict;
use warnings;
use CGI;
use DBI;

my $q=CGI->new;
print $q -> header('text/xml;charset=UTF-8');
my $owner=$q->param("owner");

if(defined($owner)){
    my @arr=conseguirTitulo($owner);
    my $body=renderList($owner,@arr);
    print renderBody($body);
}

else{
    showList();
}

sub conseguirTitulo{
    my $ownerQuery=$_[0];

    my $user = 'alumno';
    my $password= 'pweb1';
    my $dsn ='DBI:MariaDB:database=pweb1;host=192.168.1.9';
    my $dbh = DBI ->connect($dsn,$user,$password) or die ("No se pudo conectar");

    my $sth=$dbh->prepare("SELECT title FROM Articles WHERE owner=?");
    $sth->execute($ownerQuery);

    my @arr;
    while(my @row=$sth->fetchrow_array){
        push(@arr,$row[0]);
    }

    $sth->finish;
    $dbh->disconnect;
    return @arr;
}

sub renderList{ 

    my @list=@_;
    my $owner=shift(@list);
    my $body="<article>\n";
    foreach my $line(@list){
        $body.=<<BODY;
        <article>
            <owner>$owner</owner>
            <title>$line</title>
        </article>
BODY

    }
    return $body."</article>\n";

}
sub showList{            
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