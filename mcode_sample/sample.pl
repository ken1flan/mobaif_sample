use Mcode;

my $mcode_dir = '/usr/local/lib/mobalog/data/dat/mcode';
my $mcode = new Mcode($mcode_dir);

my $src = <<EOF;
<html>
  <body>
    <h1>Hello, mcode!</h1>
  </body>
</html>
EOF

print "$src\n";
print "----\n";

my $output = $mcode->u2any(\$src, 'D');

print "$output\n";
print "----\n";