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
    
HTML

my $q=CGI->new;
#print $q -> header('html');
my $owner=$q->param("owner");
my $title=$q->param("title");
my $expresionRegular;

    

my $contenido=" ".renderText($owner,$title)." ";




#sub transformar{
 #   my $contenido= " ".$_[0]." ";
$contenido =~ s/([^#]#{1}([^(#\*\~\`)]+))/<h1>$2<\/h1> /g;

$contenido =~ s/([^#]#{2}([^(#\*\~\`)]+))/<h2>$2<\/h2> /g;

$contenido =~ s/([^#]#{3}([^(#\*\~\`)]+))/<h3>$2<\/h3>/g;

$contenido =~ s/([^#]#{4}([^(#\*\~\`)]+))/<h4>$2<\/h4> /g;

$contenido =~ s/([^#]#{5}([^(#\*\~\`)]+))/<h5>$2<\/h5>/g;

$contenido =~ s/([^#]#{6}([^(#\*\~\`)]+))/<h6>$2<\/h6> /g;


# # #             otros simbolos
$expresionRegular=expresionRegularGenerada("*",2,$contenido);
$contenido =~ s/$expresionRegular/<p><strong>$2<\/strong><\/p> /g;

$expresionRegular=expresionRegularGenerada("*",1,$contenido);
$contenido =~ s/$expresionRegular/<p><em>$2<\/em><\/p> /g;

$expresionRegular=expresionRegularGenerada("~",2,$contenido);
$contenido =~ s/$expresionRegular/<p>$2<\/p> /g;

$expresionRegular=expresionRegularGenerada("_",1,$contenido);
$contenido =~ s/$expresionRegular/<em>$2<\/em> /g;

$expresionRegular=expresionRegularGenerada("*",3,$contenido);
$contenido =~ s/$expresionRegular/<p><strong><em>$2<\/em><\/strong><\/p> /g;

$expresionRegular=expresionRegularGenerada("`",3,$contenido);
$contenido =~ s/$expresionRegular/<p><code>$2<\/code><\/p> /g;

##                links

$contenido =~ s/\[{1}([^\]]+)\]{1}\({1}(.+)\){1}/<a href="$2">$1<\/a> /g; 

print $contenido;

sub expresionRegularGenerada{
    my $simboloCostados=$_[0];
    my $cantidadSimbolos=$_[1];
    my $cadena=$_[2];

    $cadena="([^\\$simboloCostados]\\$simboloCostados\{$cantidadSimbolos}([^\\$simboloCostados]+)\\$simboloCostados\{$cantidadSimbolos}[^\\$simboloCostados])";
    return $cadena;

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

#}