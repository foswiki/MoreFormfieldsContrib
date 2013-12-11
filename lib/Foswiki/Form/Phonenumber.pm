# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# MoreFormfieldsContrib is Copyright (C) 2010-2013 Michael Daum http://michaeldaumconsulting.com
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details, published at
# http://www.gnu.org/copyleft/gpl.html

package Foswiki::Form::Phonenumber;

use strict;
use warnings;

use Foswiki::Form::Text ();
our @ISA = ('Foswiki::Form::Text');

sub addStyles {
  #my $this = shift;
  Foswiki::Func::addToZone("head", 
    "MOREFORMFIELDSCONTRIB::CSS",
    "<link rel='stylesheet' href='%PUBURLPATH%/%SYSTEMWEB%/MoreFormfieldsContrib/moreformfields.css' media='all' />");

}

sub addJavascript {
  #my $this = shift;
  Foswiki::Func::addToZone("script", 
    "MOREFORMFIELDSCONTRIB::PHONENUMBER::JS",
    "<script src='%PUBURLPATH%/%SYSTEMWEB%/MoreFormfieldsContrib/phonenumber.js'></script>", 
    "JQUERYPLUGIN::FOSWIKI, JQUERYPLUGIN::LIVEQUERY, JQUERYPLUGIN::VALIDATE");

  if ($Foswiki::cfg{Plugins}{MoreFormfieldsContrib}{Debug}) {
    Foswiki::Plugins::JQueryPlugin::createPlugin("debug");
  }

}

sub renderForEdit {
  my ($this, $topicObject, $value) = @_;

  $this->addJavascript();
  $this->addStyles();

  return (
    '',
    CGI::textfield(
      -class => $this->cssClasses('foswikiInputField foswikiPhoneNumber'),
      -name => $this->{name},
      -size => $this->{size},
      -value => $value
    )
  );
}

sub renderForDisplay {
  my ($this, $format, $value, $attrs) = @_;

  return '' unless defined $value && $value ne '';

  my $number = $value;
  $number =~ s/^\s+//;
  $number =~ s/\s+$//;
  $number =~ s/\s+//g;
  $number =~ s/\(.*?\)//g;
  $number =~ s/^\+/00/;

  my $result = "<a href='sip:$number' class='foswikiPhoneNumber'>$value</a>";
  $format =~ s/\$value/$result/g;

  $this->addStyles();
  $this->addJavascript();

  return $this->SUPER::renderForDisplay($format, $value, $attrs);
}

1;
