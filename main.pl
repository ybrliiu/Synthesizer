# https://gihyo.jp/dev/serial/01/perl-hackers-hub/001501

use v5.28;
use warnings;
use utf8;
use Carp;
use Data::Dumper;
use Math::Trig qw( pi );
use experimental qw( signatures );
no warnings 'experimental::signatures';

use lib './lib';
use Synthesizer::Scale;
use Synthesizer::Wave::Sin;
use Synthesizer::Wave::Cos;
use Synthesizer::Wave::Tri;
use Synthesizer::Wave::Pulse;
use Synthesizer::Wave::Noise;
use Synthesizer::Filter;
use Synthesizer::Envelope;
use Synthesizer::PitchEnvelope;
use Synthesizer::Oscillator;
use Synthesizer::Sound;
use Synthesizer::OneShot;
use Synthesizer::Wav;

my $c2         = Synthesizer::Scale->new( index => 3 );
my $sin_wave   = Synthesizer::Wave::Sin->new;
my $cos_wave   = Synthesizer::Wave::Cos->new;
my $tri_wave   = Synthesizer::Wave::Tri->new;
my $pulse_wave = Synthesizer::Wave::Pulse->new;
my $noise_wave = Synthesizer::Wave::Noise->new;

my $sin_samples = do {
  my $osc = Synthesizer::Oscillator->new(
    frequency => $c2,
    wave      => $sin_wave,
  );
  my $mod = Synthesizer::Filter->new(
    depth      => 0.5,
    oscillator => Synthesizer::Oscillator->new(
      wave      => $pulse_wave,
      frequency => Synthesizer::Frequency->new( value => 1.0 / 0.5 ),
    ),
  );
  # my $mod = create_pitch_modulator(44100, 'pulse', 0.5, 0.5);
  my $sound = Synthesizer::Sound->new(
    sec                   => 3.0,
    oscillator            => $osc,
    maybe_pitch_modulator => $mod,
  );
  $sound;
};

my $samples_kick = Synthesizer::OneShot->new(
  envelope   => Synthesizer::Envelope->new(
    sec   => 0.25,
    curve => 1.4,
  ),
  oscillator => Synthesizer::Oscillator->new(
    wave      => $sin_wave,
    frequency => Synthesizer::Frequency->new( value => 25 ),
  ),
  maybe_pitch_modulator => Synthesizer::PitchEnvelope->new(
    depth    => 3.5,
    envelope => Synthesizer::Envelope->new(
      sec   => 0.25,
      curve => 1.8,
    ),
  ),
);

my $samples_close_high_hat = Synthesizer::OneShot->new(
  envelope => Synthesizer::Envelope->new(
    sec   => 0.08,
    curve => 2.7,
  ),
  oscillator => Synthesizer::Oscillator->new(
    wave      => $tri_wave,
    frequency => Synthesizer::Frequency->new( value => 16000 ),
  ),
  maybe_pitch_modulator => Synthesizer::Filter->new(
    depth      => 6.0,
    oscillator => Synthesizer::Oscillator->new(
      wave      => $noise_wave,
      frequency => Synthesizer::Frequency->new( value => 1 / 0.06 ),
    ),
  ),
);

my $samples_open_high_hat = Synthesizer::OneShot->new(
  envelope => Synthesizer::Envelope->new(
    sec   => 0.15,
    curve => 2.7,
  ),
  oscillator => Synthesizer::Oscillator->new(
    wave      => $tri_wave,
    frequency => Synthesizer::Frequency->new( value => 16000 ),
  ),
  maybe_pitch_modulator => Synthesizer::Filter->new(
    depth      => 6.0,
    oscillator => Synthesizer::Oscillator->new(
      wave      => $noise_wave,
      frequency => Synthesizer::Frequency->new( value => 1 / 0.06 ),
    ),
  ),
);

my $samples_snare = Synthesizer::OneShot->new(
  envelope => Synthesizer::Envelope->new(
    sec   => 0.16,
    curve => 2.2,
  ),
  oscillator => Synthesizer::Oscillator->new(
    wave      => $tri_wave,
    frequency => Synthesizer::Frequency->new( value => 400 ),
  ),
  maybe_pitch_modulator => Synthesizer::Filter->new(
    depth      => 9.0,
    oscillator => Synthesizer::Oscillator->new(
      wave      => $noise_wave,
      frequency => Synthesizer::Frequency->new( value => 1 / 0.08 ),
    ),
  ),
);

sub samples_as_wav($sound) {
  Synthesizer::Wav->new( sound => $sound )->chunk;
}

sub save_binary_file($filename, $binary) {
  open( my $fh, '>', $filename ) or die 'Cant open file.';
  $fh->binmode;
  $fh->print($binary);
  $fh->close;
}

save_binary_file( 'snare.wav', samples_as_wav($samples_snare) );
save_binary_file( 'open_high_hat.wav', samples_as_wav($samples_open_high_hat) );
save_binary_file( 'close_high_hat.wav', samples_as_wav($samples_close_high_hat) );
save_binary_file( 'kick.wav', samples_as_wav($samples_kick) );
save_binary_file( 'sin.wav', samples_as_wav($sin_samples) );

