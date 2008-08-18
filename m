Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:36681 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbYHRNtI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2008 09:49:08 -0400
Message-ID: <48A97DC7.10808@lwfinger.net> (sfid-20080818_154923_030345_1F52BCC9)
Date: Mon, 18 Aug 2008 08:48:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Holger Schurig <hs4233@mail.mn-solutions.de>
CC: linux-wireless@vger.kernel.org, Ehud Gavron <gavron@wetwork.net>,
	Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH RFT] b43: Rewrite PHY API for N-PHY/LP-PHY  -- good on
 4311
References: <200808160029.56876.mb@bu3sch.de> <48A87B5D.7010402@wetwork.net> <48A88D4D.9050001@lwfinger.net> <200808180941.10485.hs4233@mail.mn-solutions.de>
In-Reply-To: <200808180941.10485.hs4233@mail.mn-solutions.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Holger Schurig wrote:
> Huh?  I use "make install modules_install" from my kernel source 
> dir (which I usually get via git) and that works fine, as in 
> every distro on earth.
> 
> Hehe, but I seldom use distro kernels, not even when I used Red 
> Hat or Mandrake in old times :-)

I tried that with Ubuntu 8.04 and the resulting kernel wouldn't boot. 
Only when I went through the process of making the ".deb" and 
installing that did the new kernel start properly. I didn't 
investigate it thoroughly as I was only testing one patch - I quickly 
fled back to openSUSE.

Larry
