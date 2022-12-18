#!"c:/Strawberry/perl/bin/perl.exe"
use strict;
use warnings;
use CGI;
use DBI;

my $q=CGI->new;
print $q -> header('text/xml');

my $title=$q->param("title");
my $owner=$q->param("owner");
my $text=$q->param("text");


if(defined($title) and defined($owner) and defined($text)){
    if(checkOwner($owner)){
        if(!checkTitle($title,$owner)){
            register($title,$owner,$text);
            successNew($title,$text);
        }
        else{
            showNew();
        }
        
    }
    else{
        showNew();
    }
}
else{
    showNew();  
}

sub checkOwner{
    my $ownerQuery=$_[0];
    
    my $user = 'alumno';
    my $password= 'pweb1';
    my $dsn ='DBI:MariaDB:database=pweb1;host=192.168.1.9';
    my $dbh = DBI->connect($dsn,$user,$password) or die ("No se pudo conectar");
    
    
    my $sth=$dbh->prepare("SELECT userName FROM Users WHERE userName=?");
    $sth->execute($ownerQuery);
    my @row=$sth->fetchrow_array;
    $sth->finish;
    $dbh->disconnect;
    return @row;

}

sub checkTitle{
    my $titleQuery=$_[0];
    my $ownerQuery=$_[1];
    

    my $user = 'alumno';
    my $password= 'pweb1';
    my $dsn ='DBI:MariaDB:database=pweb1;host=192.168.1.9';
    my $dbh = DBI ->connect($dsn,$user,$password) or die ("No se pudo conectar");
    
    
    my $sth=$dbh->prepare("SELECT title FROM Articles WHERE title=? AND owner=?");
    $sth->execute($titleQuery,$ownerQuery);
    my @row=$sth->fetchrow_array;
    $sth->finish;
    $dbh->disconnect;
    return @row;

}

sub register{
    my $titleQuery=$_[0];
    my $ownerQuery=$_[1];
    my $textQuery=$_[2];
    
    my $user = 'alumno';
    my $password= 'pweb1';
    my $dsn ='DBI:MariaDB:database=pweb1;host=192.168.1.9';
    my $dbh = DBI ->connect($dsn,$user,$password) or die ("No se pudo conectar");
    #Prueba para ver si se efecuta, por fin me salio despues de 5 horas pipipi
    #my $sth=$dbh->prepare("INSERT INTO Articles(title,owner,text) VALUES(?,?,?)");
    #$sth->execute("odio","pepe","la vaca dice ohhh");

    
    
    my $sth=$dbh->prepare("INSERT INTO Articles(title,owner,text) VALUES(?,?,?)");
    $sth->execute($titleQuery,$ownerQuery,$textQuery);
    my @row=$sth->fetchrow_array;
    $sth->finish;
    $dbh->disconnect;

}


sub successNew{            
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


sub showNew{            
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
    

    

