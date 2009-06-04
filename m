Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:57958 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbZFDEZJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 00:25:09 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Marcel Holtmann <marcel@holtmann.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Dan Williams <dcbw@redhat.com>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090603214040.GD22809@khazad-dum.debian.net>
References: <1243867620.3015.17.camel@localhost.localdomain>
	 <4A23FD91.8020200@tuffmail.co.uk>
	 <1243885494.3015.29.camel@localhost.localdomain>
	 <4A24559D.7010201@tuffmail.co.uk>
	 <1243928308.3192.38.camel@localhost.localdomain>
	 <1243929706.20064.7.camel@johannes.local> <4A24E3E4.1050505@tuffmail.co.uk>
	 <1243932109.3192.73.camel@localhost.localdomain>
	 <20090603041030.GB10464@khazad-dum.debian.net>
	 <1244034216.22679.22.camel@localhost.localdomain>
	 <20090603214040.GD22809@khazad-dum.debian.net>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 06:24:46 +0200
Message-Id: <1244089486.4145.33.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Henrique,

> > > > Forget about this EPO crap. That is just a stupid concept anyway.
> > > 
> > > Is it?  So, if I use the _hardware switch_ on my laptop to kill all
> > > internal radios, it shouldn't be enforced by the OS on extra radios I
> > > plugged?  Or on shitty internal WLAN cards that doesn't tie properly to
> > > the mini-pci and mini-pcie hardware kill lines?
> > > 
> > > And any userspace PoS program can decide to bring up such radios that
> > > are not hardware-killed even if I am clearly trying to disable them all?
> > 
> > You hardkilled.  Of course it should bring down everything.  If you
> > don't want to hardkill, then disable specific radios via /sys or some
> > UI.  The hardswitch is the "eject" button.
> 
> That's exactly my point.  I want EPO to mean "no, you cannot turn this crap
> on, GO AWAY" for anyone but root (or whomever SELinux allowed to do it,
> etc).

let me repeat, this is what you want and that is policy. Feel free to
implement that in userspace. Leave such policy out of the kernel.

Regards

Marcel


