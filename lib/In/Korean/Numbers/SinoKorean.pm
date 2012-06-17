package In::Korean::Numbers::SinoKorean;

use utf8;
use POSIX;
use 5.006;
use strict;
use warnings;

our $VERSION = '0.01'; # Also update POD version below

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

# Map Hangul to integer
my %int_to_char_map = (
  0 => '영',
  1 => '일',
  2 => '이',
  3 => '삼',
  4 => '사',
  5 => '오',
  6 => '육',
  7 => '칠',
  8 => '팔',
  9 => '구',
  10 => '십',
  100 => '백',
  1000 => '천',
  10000 => '만',
);

my %char_to_int_map; # Lazily created from %int_to_char_map

# All numbers are expressed as a combination of the following units
my @units = (10000, 1000, 100, 10, 1);

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sub new {
  my $class = shift;
  return bless {}, $class;
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
sub getHangul {

  my( $self, $num ) = get_args( @_ );

  return undef if not defined $num;

  # Must be positive integer
  return undef if not is_positive_int_or_zero( $num );
  
  my @hangul = ();

  my $remaining = $num;

  foreach my $unit ( @units ) {

    last if $remaining == 0; # Performance reasons only

    # Find the mutiple for the current unit.
    # E.g., 502,217 for key=10,000, then multiple = 52
    my $multiple = floor( $remaining / $unit );

    next if $multiple < 1;

    $remaining %= $unit;

    # Recursively call to get value greater than 10
    my $multiple_str = $multiple >= 10 ? getHangul( $self, $multiple ) : int_to_char( $multiple );

    # Don't push Hangul value for 1 unless currently handling 1 unit
    push @hangul, $multiple_str unless $multiple == 1 && $unit != 1;
    push @hangul, int_to_char( $unit ) if $unit != 1;
  }

  return join( '', @hangul ) if @hangul;

  return '영';
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
sub getInt {

  my( $self, $hangul ) = get_args( @_ );

  return undef if not defined $hangul;

  # Tokenize so process each character separately
  my @tokens = split( //,  $hangul );
  
  my $total = 0;
  
  while( @tokens ) {
    my $char_char = shift @tokens;
    my $char_int = char_to_int( $char_char );

    # If invalid input, return undef
    return undef if ! defined( $char_int );
    
    # If 만,  multiply everything by 10,000
    if ( $char_char eq '만' ) {
      if ( $total ) {
        $total *= 10000;
      } else {
        $total = 10000;
      }
      next;
    }

    # If:
    #   (1) char value is greater than 9, 
    #   (2) no more characters left
    #   (3) next character is 만 
    # Then add value
    elsif ( $char_int > 9 || ! @tokens || $tokens[0] eq '만' ) {
      $total += $char_int;
    }

    # If char 0-9 and not final, get next char (units)
    else {
      my $unit_char = shift @tokens;
      my $unit_int = char_to_int( $unit_char );
      $total += ( $char_int * $unit_int );
    }
  }

  return $total;
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
sub get_args {
  my( $self, $val );

  if ( @_ >= 2 ) {
    ( $self, $val ) = @_; 
  } elsif ( @_ == 1 ) {
    ( $val ) = @_;
  } 
  
  return ( $self, $val );
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sub int_to_char {
  my $int = shift;
  return $int_to_char_map{ $int };
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sub char_to_int {
  my $char = shift;

  if (! %char_to_int_map ) {
    %char_to_int_map = ();

    for my $int ( keys %int_to_char_map ) {
      my $hangul = $int_to_char_map{ $int };
      $char_to_int_map{ $hangul } = $int; # Inverse of int_to_char_map
    }
  }

  my $int = $char_to_int_map{ $char };

  return $int;
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Source: http://www.perlmonks.org/?node_id=614452
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
sub is_positive_int_or_zero {
  my $val = shift;
  $val =~ s/^\s+//;          # leading whitespace
  $val =~ s/\s+$//;          # trailing whitespace
  return $val =~ /^[+]?\d+$/;
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
1;
__END__

=head1 NAME

In::Korean::Numbers::SinoKorean - Convert integers to Sino-Korean text (in Hangul) and vice versa.

=head1 VERSION

Version 0.01

=cut

=head1 SYNOPSIS

    use In::Korean::Numbers;

    # Object-oriented API
    my $sk     = In::Korean::Numbers::SinoKorean->new();
    my $hangul = $sk->getHangul( 42 );       # 사십이
    my $int    = $sk->getHangul( '백이십삼' );  # 123
    
    # Procedural API
    $hangul = In::Korean::Numbers::SinoKorean::getHangul( 42 );       # 사십이
    $int    = In::Korean::Numbers::SinoKorean::getHangul( '백이십삼' );  # 123
    
=head1 SUBROUTINES/METHODS

=head2 new
Constructor that takes no arguments returns a new
C<In::Korean::Numbers::SinoKorean> object.

=head2 getHangul
Given a positive integer, returns string for Sino-Korean (as Hangul).

  my $hangul = $sk->getHangul( 42 );       # 사십이
  $hangul = In::Korean::Numbers::SinoKorean::getHangul( 42 );       # 사십이

=head2 getInt
Given a positive integer in Sino-Korean (as Hangul), returns number.

    my $int    = $sk->getHangul( '백이십삼' );  # 123
    $int    = In::Korean::Numbers::SinoKorean::getHangul( '백이십삼' );  # 123

=cut
