package gui_window::about;
use strict;
use base qw(gui_window);

#------------------#
#   Window�򳫤�   #
#------------------#

sub _new{
	my $self = shift;
	use Tk::Balloon;
	
	my $mw = $::main_gui->mw;
	my $wabtkh = $self->{win_obj};
	#$wabtkh->resizable(0, 0);

	$wabtkh->title($self->gui_jt('KH Coder�ˤĤ���','euc'));

	$wabtkh->Label(
		-image => $wabtkh->Photo(-file => $::config_obj->logo_image_file),
		-borderwidth => 2,
		-relief => 'sunken',
		)->pack(-anchor => 'c');

	my $fra_m = $wabtkh->Frame()->pack(-anchor=>'w');
	my $fra_r = $fra_m->Frame()->pack(-anchor=>'w', -side => 'right');
	my $fra_l = $fra_m->Frame()->pack(-anchor=>'w', -side => 'left');

	$fra_l->Label(
		-text => '  Version:',
		-font => "TKFN",
		)->pack(-anchor=>'w',-pady=>'2',-padx=>'2');

	my $version_perl = $];
	
	my $version_perl_p1 = substr($version_perl,2,3);
	while (substr($version_perl_p1,0,1) eq '0'){
		substr($version_perl_p1,0,1) = '';
	}
	$version_perl_p1 = '0' unless length($version_perl_p1);

	my $version_perl_p2 = substr($version_perl,5,3);
	while (substr($version_perl_p2,0,1) eq '0'){
		substr($version_perl_p2,0,1) = '';
	}
	$version_perl_p2 = '0' unless length($version_perl_p2);

	$version_perl = substr($version_perl,0,2).$version_perl_p1.'.'.$version_perl_p2;

	$fra_r->Label(
		-text => "$::kh_version  [Perl ".$version_perl.", Perl/Tk $Tk::VERSION]",
		-font => "TKFN",
		)->pack(-anchor=>'w',-pady=>'2',-padx=>'2');

	$fra_l->Label(
		-text => '  Web page:',
		-font => "TKFN",
		)->pack(-anchor => 'w',-pady=>'2',-padx=>'2');

	gui_widget::url_lab->open(
		label  => $self->gui_jchar('http://khc.sourceforge.net'),
		url    => 'http://khc.sourceforge.net',
		parent => $fra_r,
		pack   => {-anchor => 'nw',-pady=>'2'},
	);

	$fra_l->Label(
		-text => '  Powered by:',
		-font => "TKFN",
		)->pack(-anchor => 'w',-pady=>'2',-padx=>'2');

	my $fra_r1 = $fra_r->Frame()->pack(-anchor=>'w');

	gui_widget::url_lab->open(
		label  => $self->gui_jchar('ChaSen'),
		url    => 'http://chasen-legacy.sourceforge.jp/',
		parent => $fra_r1,
		pack   => {-side => 'left', -anchor => 'nw',-pady=>'2'},
	);

	$fra_r1->Label(
		-text => '+',
		-font => "TKFN",
		)->pack(-anchor => 'nw',-pady=>'2',-side=>'left');

	gui_widget::url_lab->open(
		label  => $self->gui_jchar('MySQL'),
		url    => 'http://www.mysql.com/',
		parent => $fra_r1,
		pack   => {-side => 'left', -anchor => 'nw',-pady=>'2'},
	);

	$fra_r1->Label(
		-text => '+',
		-font => "TKFN",
		)->pack(-anchor => 'nw',-pady=>'2',-side=>'left');

	gui_widget::url_lab->open(
		label  => $self->gui_jchar('Perl'),
		url    => 'http://www.perl.com/',
		parent => $fra_r1,
		pack   => {-anchor => 'nw',-pady=>'2'},
	);

	$fra_l->Label(
		-text => '  Thanks to:',
		-font => "TKFN",
		)->pack(-anchor => 'w',-pady=>'2',-padx=>'2');

	gui_widget::url_lab->open(
		label  => $self->gui_jchar('��üμ','euc'),
		url    => 'http://www.dma.jim.osaka-u.ac.jp/kg-portal/aspI/RX0011D.asp?UNO=12484',
		parent => $fra_r,
		pack   => {-anchor => 'nw',-pady=>'2'},
	);

	$fra_l->Label(
		-text => '  Copyright:',
		-font => "TKFN",
	)->pack(-anchor => 'w',-pady=>'2',-padx=>'2');

	$fra_r->Label(
		-text => $self->gui_jchar('(C) 2001-2008','euc'),
		-font => "TKFN",
	)->pack(-anchor => 'nw', -pady=>'2', -side => 'left');

	gui_widget::url_lab->open(
		label  => $self->gui_jchar('�����̰�','euc'),
		url    => 'http://koichi.nihon.to/psnl',
		parent => $fra_r,
		pack   => {-anchor => 'w',-side => 'left', -pady=>'2'},
	);

	$wabtkh->Button(
		-text => $self->gui_jchar('�Ĥ���'),
		-font => "TKFN",
		-width => 8,
		-command => sub{ $mw->after
			(
				10,
				sub {
					$self->close();
				}
			);
		}
	)->pack(-anchor => 'c',-pady => '0')->focus;
	return $self;
}

#--------------#
#   Window̾   #

sub win_name{
	return 'w_about';
}

1;