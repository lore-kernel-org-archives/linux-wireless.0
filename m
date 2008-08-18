Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:45419 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbYHRM6I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2008 08:58:08 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Subject: Re: [PATCH RFT] b43: Rewrite PHY API for N-PHY/LP-PHY  -- good on 4311
Date: Mon, 18 Aug 2008 14:57:36 +0200
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Ehud Gavron <gavron@wetwork.net>, bcm43xx-dev@lists.berlios.de
References: <200808160029.56876.mb@bu3sch.de> <48A88D4D.9050001@lwfinger.net> <200808180941.10485.hs4233@mail.mn-solutions.de>
In-Reply-To: <200808180941.10485.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808181457.36858.mb@bu3sch.de> (sfid-20080818_145813_631111_48E37DC4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 18 August 2008 09:41:10 Holger Schurig wrote:
> > I know, which is one of the reasons I don't use a Debian-based
> > distro. I want nothing to do with one whose stated goal is to
> > make it so difficult to change the kernel that the users won't
> > do it.
> 
> Huh?  I use "make install modules_install" from my kernel source 
> dir (which I usually get via git) and that works fine, as in 
> every distro on earth.

I can only second that.
I simply ignore any distro specific kernel handling and override
the grub/yaboot entries as I desire. I also ignore any rpm or deb
for installing a kernel. I do it this way since the very beginning
and it works fine on debian and non-debian distros.

In general, I do always ignore the packet manager, but install
custom compiled software in a specific directory so it does not
interfere in any way with the distro packets.


-- 
Greetings Michael.
