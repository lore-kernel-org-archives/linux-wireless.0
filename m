Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52861 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbZFCNEN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 09:04:13 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Dan Williams <dcbw@redhat.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090603041030.GB10464@khazad-dum.debian.net>
References: <4A238EA2.4040106@tuffmail.co.uk>
	 <1243858256.5299.14.camel@johannes.local>
	 <1243867620.3015.17.camel@localhost.localdomain>
	 <4A23FD91.8020200@tuffmail.co.uk>
	 <1243885494.3015.29.camel@localhost.localdomain>
	 <4A24559D.7010201@tuffmail.co.uk>
	 <1243928308.3192.38.camel@localhost.localdomain>
	 <1243929706.20064.7.camel@johannes.local> <4A24E3E4.1050505@tuffmail.co.uk>
	 <1243932109.3192.73.camel@localhost.localdomain>
	 <20090603041030.GB10464@khazad-dum.debian.net>
Content-Type: text/plain
Date: Wed, 03 Jun 2009 09:03:36 -0400
Message-Id: <1244034216.22679.22.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-06-03 at 01:10 -0300, Henrique de Moraes Holschuh wrote:
> On Tue, 02 Jun 2009, Marcel Holtmann wrote:
> > Forget about this EPO crap. That is just a stupid concept anyway.
> 
> Is it?  So, if I use the _hardware switch_ on my laptop to kill all
> internal radios, it shouldn't be enforced by the OS on extra radios I
> plugged?  Or on shitty internal WLAN cards that doesn't tie properly to
> the mini-pci and mini-pcie hardware kill lines?
> 
> And any userspace PoS program can decide to bring up such radios that
> are not hardware-killed even if I am clearly trying to disable them all?

You hardkilled.  Of course it should bring down everything.  If you
don't want to hardkill, then disable specific radios via /sys or some
UI.  The hardswitch is the "eject" button.

Other types like pushbutton switches (Fn+F5, HP laptop touchbuttons,
etc) that *aren't* hardswitches connected to a GPIO on the wifi device
should probably just bring up some window letting you pick what gets
rfkilled.

Dan


