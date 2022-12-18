#!"c:/Strawberry/perl/bin/perl.exe"
use strict;
use warnings;
use CGI;
use DBI;

my $q=CGI->new;
print $q -> header('text/xml');
my $userName=$q->param("ower");
my $password=$q->param("password");

if(defined($userName) and defined($password) ){
    if(checkLogin($user,$password)){
        my @arr=checkLogin($user,$password);
        successLogin($arr[0],$arr[3],$arr[2]);
    }
    else{
        showLogin();
    }
}
else{
    showLogin();
}
