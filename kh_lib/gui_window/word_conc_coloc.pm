package gui_window::word_conc_coloc;
use base qw(gui_window);
use vars qw($filter);

use strict;
use Statistics::Lite qw(max);
use gui_hlist;

#------------------#
#   Windowを作成   #
#------------------#

sub _new{
	my $self = shift;
	my $mw = $::main_gui->mw;
	my $wmw= $self->{win_obj};
	#$self->{win_obj} = $wmw;
	$wmw->title($self->gui_jt( kh_msg->get('win_title') )); #'コロケーション統計'
	
	# Nord Wordの情報表示部分
	
	my $fra4 = $wmw->LabFrame(
		-label => 'Nord Word',
		-labelside => 'acrosstop',
		-borderwidth => 2,
	)->pack(-fill=>'x');
	
	$fra4->Label(
		-text => kh_msg->get('word'),#$self->gui_jchar('　抽出語：'),
		-font => "TKFN"
	)->pack(-side => 'left');
	
	my $e1 = $fra4->Entry(
		-font => "TKFN",
		-background => 'gray',
		-width => 14,
		-state => 'disable',
	)->pack(-side => 'left');
	
	$fra4->Label(
		-text => kh_msg->get('pos'),#$self->gui_jchar('　品詞：'),
		-font => "TKFN"
	)->pack(-side => 'left');
	
	my $e4 = $fra4->Entry(
		-font => "TKFN",
		-background => 'gray',
		-width => 8,
		-state => 'disable',
	)->pack(-side => 'left');

	$fra4->Label(
		-text => kh_msg->get('conj'),#$self->gui_jchar('　活用形：'),
		-font => "TKFN"
	)->pack(-side => 'left');

	my $e2 = $fra4->Entry(
		-font => "TKFN",
		-width => 8,
		-background => 'gray',
		-state => 'disable',
	)->pack(-side => 'left');

	$self->{label} = $fra4->Label(
		-text => kh_msg->get('hits'),#$self->gui_jchar('  ヒット数：'),
		-font => "TKFN"
	)->pack(-side => 'left');


	# 集計結果を表示する部分

	my $fra5 = $wmw->LabFrame(
		-label => 'Result',
		-labelside => 'acrosstop',
		-borderwidth => 2
	)->pack(-expand=>'yes',-fill=>'both');

	my $hlist_fra = $fra5->Frame()->pack(-expand => 'y', -fill => 'both');

	my $lis = $hlist_fra->Scrolled(
		'HList',
		-scrollbars       => 'osoe',
		-header           => 1,
		-itemtype         => 'text',
		-font             => 'TKFN',
		-columns          => 16,
		-padx             => 2,
		-background       => 'white',
		#-selectforeground => 'black',
		#-selectbackground => 'cyan',
		-selectmode       => 'extended',
		#-height           => 20,
		#-command          => sub{$self->view_doc;}
	)->pack(-fill =>'both',-expand => 'yes');

	my $style_blue = $lis->ItemStyle(
		'text',
		-font => "TKFN",
		-foreground => 'blue',
		#-background => 'white'
	);
	my $style_green = $lis->ItemStyle(
		'text',
		-font => "TKFN",
		-foreground => '#008000',
		#-background => 'white'
	);

	$lis->header('create',0,-text  => 'N');
	$lis->header('create',1,-text  => kh_msg->get('h_word')); #$self->gui_jchar('抽出語')
	$lis->header('create',2,-text  => kh_msg->get('h_pos')); #$self->gui_jchar('品詞')
	$lis->header('create',3,-text  => kh_msg->get('h_score')); #$self->gui_jchar('スコア')
	$lis->header('create',4,-text  => kh_msg->get('h_l_total')); #$self->gui_jchar('左合計')
	$lis->header('create',5,-text  => kh_msg->get('h_r_total')); #$self->gui_jchar('右合計')
	$lis->header(
		'create', 6,
		-text  => kh_msg->get('l5'),#$self->gui_jchar('左5'),
		-style => $style_blue
	);
	$lis->header(
		'create',7,
		-text  => kh_msg->get('l4'),#$self->gui_jchar('左4'),
		-style => $style_blue
	);
	$lis->header(
		'create',8,
		-text  => kh_msg->get('l3'),#$self->gui_jchar('左3'),
		-style => $style_blue
	);
	$lis->header(
		'create',9,
		-text  => kh_msg->get('l2'),#$self->gui_jchar('左2'),
		-style => $style_blue
	);
	$lis->header(
		'create',10,
		-text  => kh_msg->get('l1'),#$self->gui_jchar('左1'),
		-style => $style_blue
	);
	#$lis->header('create',11,-text => $self->gui_jchar('*'));
	$lis->header(
		'create',11,
		-text => kh_msg->get('r1'),#$self->gui_jchar('右1'),
		-style => $style_green
	);
	$lis->header(
		'create',12,
		-text => kh_msg->get('r2'),#$self->gui_jchar('右2'),
		-style => $style_green
	);
	$lis->header(
		'create',13,
		-text => kh_msg->get('r3'),#$self->gui_jchar('右3'),
		-style => $style_green
	);
	$lis->header(
		'create',14,
		-text => kh_msg->get('r4'),#$self->gui_jchar('右4'),
		-style => $style_green
	);
	$lis->header(
		'create',15,
		-text => kh_msg->get('r5'),#$self->gui_jchar('右5'),
		-style => $style_green
	);

	# 結果操作用のボタン類

	$self->{copy_btn} = $fra5->Button(
		-text => kh_msg->gget('copy'),#$self->gui_jchar('コピー'),
		-font => "TKFN",
		-width => 8,
		-borderwidth => '1',
		-command => sub {gui_hlist->copy($self->list);}
	)->pack(-side => 'left',-anchor => 'w', -pady => 1, -padx => 2);

	$self->win_obj->bind(
		'<Control-Key-c>',
		sub{ $self->{copy_btn}->invoke; }
	);
	$self->win_obj->Balloon()->attach(
		$self->{copy_btn},
		-balloonmsg => 'Ctrl + C',
		-font => "TKFN"
	);

	$fra5->Label(
		-text => kh_msg->get('sort'),#$self->gui_jchar('　ソート：'),
		-font => "TKFN"
	)->pack(-side => 'left');

	my @options = (
		[ kh_msg->get('h_score'), 'score'],
		[ kh_msg->get('total'),   'sum'], # 合計
		[ kh_msg->get('l_total'), 'suml'],
		[ kh_msg->get('r_total'), 'sumr'],
		[ kh_msg->get('l5'),  'l5'],
		[ kh_msg->get('l4'),  'l4'],
		[ kh_msg->get('l3'),  'l3'],
		[ kh_msg->get('l2'),  'l2'],
		[ kh_msg->get('l1'),  'l1'],
		[ kh_msg->get('r1'),  'r1'],
		[ kh_msg->get('r2'),  'r2'],
		[ kh_msg->get('r3'),  'r3'],
		[ kh_msg->get('r4'),  'r4'],
		[ kh_msg->get('r5'),  'r5']
	);

	$self->{menu1} = gui_widget::optmenu->open(
		parent   => $fra5,
		pack     => {-anchor=>'e', -side => 'left'},
		options  => \@options,
		variable => \$self->{sort},
		width    => 6,
		command  => sub{$self->view;}
	);

	$fra5->Label(
		-text => $self->gui_jchar('　'),
		-font => "TKFN"
	)->pack(-side => 'left');

	$fra5->Button(
		-text => kh_msg->get('filter'),#self->gui_jchar('フィルタ設定'),
		-font => "TKFN",
		-borderwidth => '1',
		-command => sub {gui_window::word_conc_coloc_opt->open;}
	)->pack(-side => 'left',-anchor => 'w', -pady => 1, -padx => 2);

	# フィルタ設定の初期化
	
	$filter = undef;
	$filter->{limit}   = 200;                  # LIMIT数
	my $h = mysql_exec->select("               # 品詞によるフィルタ
		SELECT name, khhinshi_id
		FROM   hselection
		WHERE  ifuse = 1
	",1)->hundle;
	while (my $i = $h->fetch){
		if (
			   $i->[0] =~ /B$/
			|| $i->[0] eq '否定助動詞'
			|| $i->[0] eq '形容詞（非自立）'
		){
			$filter->{hinshi}{$i->[1]} = 0;
		} else {
			$filter->{hinshi}{$i->[1]} = 1;
		}
	}

	# その他・最終処理
	
	$self->disabled_entry_configure($e1);
	$self->disabled_entry_configure($e4);
	$self->disabled_entry_configure($e2);

	$self->{entry}{nw_w} = $e1;
	$self->{entry}{nw_h} = $e4;
	$self->{entry}{nw_k} = $e2;
	$self->{hlist}       = $lis;

	return $self;
}

#--------------#
#   結果表示   #
#--------------#

sub view{
	my $self = shift;
	$self->{result_obj} = shift if defined($_[0]);
	
	if ($self->{sort} eq 'sum'){
		$self->list->header('create',3,-text  => kh_msg->get('total'));
	} else {
		$self->list->header('create',3,-text  => kh_msg->get('h_score'));
	}
	
	# nord word 情報の表示
	$self->{entry}{nw_w}->configure(-state => 'normal');
	$self->{entry}{nw_h}->configure(-state => 'normal');
	$self->{entry}{nw_k}->configure(-state => 'normal');
	$self->{entry}{nw_w}->delete(0,'end');
	$self->{entry}{nw_h}->delete(0,'end');
	$self->{entry}{nw_k}->delete(0,'end');
	if ($self->{result_obj}){
		$self->{entry}{nw_w}->insert(
			'end',
			$self->gui_jchar($self->{result_obj}{query})
		);
		$self->{entry}{nw_h}->insert(
			'end',
			$self->gui_jchar($self->{result_obj}{hinshi})
		);
		$self->{entry}{nw_k}->insert(
			'end',
			$self->gui_jchar($self->{result_obj}{katuyo})
		);
	}
	$self->{entry}{nw_w}->configure(-state => 'disable');
	$self->{entry}{nw_h}->configure(-state => 'disable');
	$self->{entry}{nw_k}->configure(-state => 'disable');
	my $hit_numb;
	$hit_numb = $self->{result_obj}->_count if $self->{result_obj};
	my $if_tuika = '';
	if (
		   $gui_window::word_conc::additional->{1}{pos}
		&& length($gui_window::word_conc::additional->{1}{query})
	){
		$if_tuika = kh_msg->get('additional'); #'  ＋追加条件';
	}
	$self->{label}->configure(
		-text => 
			"$if_tuika  "
			.kh_msg->get('hits')
			.$hit_numb
	);
	
	$self->list->delete('all');
	$self->win_obj->update;
	
	# 集計結果の取得
	return unless $self->{result_obj};
	my $res = $self->{result_obj}->format_coloc(
		sort   => $self->{sort},
		filter => $filter,
	);
	return unless $res;
	
	# 集計結果の表示
	my $right_style = $self->list->ItemStyle(
		'text',
		-font             => "TKFN",
		-anchor           => 'e',
		-background       => 'white'
	);
	my $right_style_blue = $self->list->ItemStyle(
		'text',
		-font             => "TKFN",
		-anchor           => 'e',
		-foreground       => 'blue',
		-selectforeground => 'blue',
		-background       => 'white'
	);
	my $right_style_green = $self->list->ItemStyle(
		'text',
		-font             => "TKFN",
		-anchor           => 'e',
		-foreground       => '#008000',
		-selectforeground => '#008000',
		-background       => 'white'
	);
	my $right_style_red = $self->list->ItemStyle(
		'text',
		-font             => "TKFN",
		-anchor           => 'e',
		-foreground       => 'red',
		-selectforeground => 'red',
		-background       => 'white'
	);
	
	my $row = 0;
	foreach my $i (@{$res}){
		$self->list->add($row,-at => "$row");
		$self->list->itemCreate(
			$row,
			0,
			-text => $row + 1,
			-style => $right_style
		);
		
		my $col = 1;
		my $max = max @{$i}[5...14];
		foreach my $h (@{$i}){
			if ($col > 2){              # 数字
				my $style;
				if ( ($col == 3) and not ($self->{sort} eq 'sum') ){
					$style = $right_style;
					$h = sprintf("%.2f",$h);
				}
				if ($col < 6){
					$style = $right_style;
				}
				elsif ($h == $max) {
					$style = $right_style_red;
				}
				elsif ($col < 11){
					$style = $right_style_blue;
				}
				else {
					$style = $right_style_green;
				}
				$self->list->itemCreate(
					$row,
					$col,
					-text  => $h,
					-style => $style
				);
			} else {                    # 日本語文字
				$self->list->itemCreate(
					$row,
					$col,
					-text  => $self->gui_jchar($h,'euc')
				);
			}
			++$col;
		}
		++$row;
	}
	gui_hlist->update4scroll($self->list);
}


#--------------#
#   アクセサ   #

sub list{
	my $self = shift;
	return $self->{hlist};
}

sub win_name{
	return 'w_word_conc_coloc';
}

1;