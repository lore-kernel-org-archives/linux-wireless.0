Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:17727 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYHRHll (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2008 03:41:41 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH RFT] b43: Rewrite PHY API for N-PHY/LP-PHY  -- good on 4311
Date: Mon, 18 Aug 2008 09:41:10 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Ehud Gavron <gavron@wetwork.net>,
	Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de
References: <200808160029.56876.mb@bu3sch.de> <48A87B5D.7010402@wetwork.net> <48A88D4D.9050001@lwfinger.net>
In-Reply-To: <48A88D4D.9050001@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808180941.10485.hs4233@mail.mn-solutions.de> (sfid-20080818_094145_829315_FA3DBB5F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I know, which is one of the reasons I don't use a Debian-based
> distro. I want nothing to do with one whose stated goal is to
> make it so difficult to change the kernel that the users won't
> do it.

Huh?  I use "make install modules_install" from my kernel source 
dir (which I usually get via git) and that works fine, as in 
every distro on earth.

Hehe, but I seldom use distro kernels, not even when I used Red 
Hat or Mandrake in old times :-)
