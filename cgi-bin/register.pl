#!"c:/Strawberry/perl/bin/perl.exe"
use strict;
use warnings;
use CGI;
use DBI;
my $q=CGI->new;
print $q -> header("text/xml");

my $firstName=$q->param("firstName");
my $lastName=$q->param("lastName");
my $userName=$q->param("userName");
my $password=$q->param("password");

if(defined($firstName) and defined($lastName) and defined($userName) and defined($password)){
    if(!verificarUsuario($userName)){
        registro($userName,$password,$firstName,$lastName);
        registroExitoso($userName,$firstName,$lastName);
    }
    else{
        mirarRegistro();
    }
}
else{
    mirarRegistro();
}

sub verificarUsuario{
    my $consultarUsuario=$_[0];
    
    my $user = 'alumno';
    my $password = 'pweb1';
    my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.9";
  
    my $dbh = DBI ->connect($dsn,$user,$password) or die ("No se pudo conectar");
    
    
    my $sql = "select userName from Users where userName=?";
    my $sth=$dbh->prepare($sql);
    $sth->execute($consultarUsuario) or die "error"; 
    my @row=$sth->fetchrow_array;
    $sth->finish;
    $dbh->disconnect;
    return @row;

}
sub registroExitoso{            
    my $owner=$_[0];
    my $firstNameQuery1=$_[1];
    my $lastNameQuery1=$_[2];

    my $body=<<XML;
    
    <user>
        <owner>$owner</owner>
        <firstNameQuery>$firstNameQuery</firstNameQuery>
        <lastNameQuery>$lastNameQuery</lastNameQuery>
    </user>
    XML
        print(renderBody($body));

}

   

