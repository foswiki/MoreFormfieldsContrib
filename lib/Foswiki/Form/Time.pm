# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# MoreFormfieldsContrib is Copyright (C) 2010-2014 Michael Daum http://michaeldaumconsulting.com
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

package Foswiki::Form::Time;

use strict;
use warnings;

use Foswiki::Form::FieldDefinition ();
our @ISA = ('Foswiki::Form::FieldDefinition');

BEGIN {
  if ($Foswiki::cfg{UseLocale}) {
    require locale;
    import locale();
  }
}

sub new {
  my $class = shift;
  my $this = $class->SUPER::new(@_);

  my $size = $this->{size} || '';
  $size =~ s/[^\d]//g;
  $size = 20 if (!$size || $size < 1);    # length(31st September 2007)=19
  $this->{size} = $size;

  return $this;
}

sub renderForEdit {
  my ($this, $topicObject, $value) = @_;

  Foswiki::Func::addToZone("script", "FOSWIKI::TIMEFIELD", <<'HERE', "JQUERYPLUGIN");
<script type='text/javascript' src='%PUBURLPATH%/%SYSTEMWEB%/MoreFormfieldsContrib/clockpicker.js'></script>
<script type='text/javascript'>
jQuery(function($) {
  $(".foswikiTimeField").livequery(function() {
    $(this).clockpicker();
  });
});
</script>
HERE

  Foswiki::Func::addToZone("head", "FOSWIKI::TIMEFIELD", <<"HERE", "JQUERYPLUGIN");
<link rel='stylesheet' type='text/css' href='%PUBURLPATH%/%SYSTEMWEB%/MoreFormfieldsContrib/clockpicker.css'></script>
HERE

  return (
    '',
    "<input type='text' name='$this->{name}' size='$this->{size}' value='$value' data-autoclose='true' class='" . $this->cssClasses('foswikiInputField', 'foswikiTimeField') . "' />",
  );
}

1;

