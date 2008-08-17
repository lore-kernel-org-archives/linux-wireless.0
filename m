Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:56936 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780AbYHQUnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Aug 2008 16:43:00 -0400
Message-ID: <48A88D4D.9050001@lwfinger.net> (sfid-20080817_224307_998565_CF985CD3)
Date: Sun, 17 Aug 2008 15:42:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ehud Gavron <gavron@wetwork.net>
CC: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH RFT] b43: Rewrite PHY API for N-PHY/LP-PHY  -- good on
 4311
References: <200808160029.56876.mb@bu3sch.de> <48A87B5D.7010402@wetwork.net>
In-Reply-To: <48A87B5D.7010402@wetwork.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ehud Gavron wrote:
> Works fine here.  iperf same results as prior to patch.
> b43-phy0: Broadcom 4311 WLAN found
> b43-phy0 debug: Found PHY: Analog 4, Type 2, Revision 8
> b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
> 
> 2.6.27-rc2-wl on Ubuntu 8.04 (don't even ask how long it takes to build 
> a new kernel and create a debian package and install it...)

I know, which is one of the reasons I don't use a Debian-based distro. 
I want nothing to do with one whose stated goal is to make it so 
difficult to change the kernel that the users won't do it.

Larry

