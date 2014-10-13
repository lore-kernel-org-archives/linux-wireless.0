Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp03.msg.oleane.net ([62.161.4.3]:56642 "EHLO
	smtp03.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbaJMMBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2014 08:01:49 -0400
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Michal Kazior'" <michal.kazior@tieto.com>
Cc: <ath10k@lists.infradead.org>,
	"'linux-wireless'" <linux-wireless@vger.kernel.org>
References: <773DB8A82AB6A046AE0195C68612A319018C2750@sbs2003.acksys.local>	<CA+BoTQ=a8kY0CGGKHwRhk4cg=V0oimipuht6Pkc0K0x4WMMn-A@mail.gmail.com>	<023801cfe6b8$350c1930$9f244b90$@acksys.fr>	<CA+BoTQkXc-VL1ixRK5KWUiE0igCxXRQyyde86TAvuKVxZhEPdg@mail.gmail.com>	<024901cfe6c6$e1905780$a4b10680$@acksys.fr> <CA+BoTQnQkDjkMMu5x-c69s1THf7SQfet2vsOPWs++PtyEHEeTw@mail.gmail.com>
In-Reply-To: <CA+BoTQnQkDjkMMu5x-c69s1THf7SQfet2vsOPWs++PtyEHEeTw@mail.gmail.com>
Subject: RE: ath10k firmware crash
Date: Mon, 13 Oct 2014 14:00:38 +0200
Message-ID: <025701cfe6dd$50460240$f0d206c0$@acksys.fr> (sfid-20141013_140152_374468_CF92D455)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > I'm using the compat wireless from Openwrt.
> >         Compat wireless version 2014-05-22, but we updated the
> > firmware with the latest version provided by openwrt (commit number
> > 38eeda3ae6f90fde5546bdd48ee4ff3090f238c0 from
> > kernel.org/pub/scm/linux/kernel/git/firmare/linux-firmware)
> 
> The fix for 4addr STA bridging is in the driver, not the firmware.
> 
> The compat version you're using doesn't contain the required fix. I'm pretty
> sure openwrt compat 2014-09-26 contains it.
> 
Ok, I will test with this version. Thanks for your help.
> 
> Michał



