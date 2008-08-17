Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Viola.Opus1.COM ([192.245.12.8]:3592 "EHLO Viola.Opus1.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbYHQUh7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Aug 2008 16:37:59 -0400
Received: from [10.1.1.5] ([204.17.34.178]) by Opus1.COM (PMDF V6.2-X27 #9830)
 with ESMTPSA id <01MYGR7OTYU28Y6HPO@Opus1.COM> for
 linux-wireless@vger.kernel.org; Sun, 17 Aug 2008 12:26:22 -0700 (MST)
Date: Sun, 17 Aug 2008 12:26:21 -0700
From: Ehud Gavron <gavron@wetwork.net>
Subject: Re: [PATCH RFT] b43: Rewrite PHY API for N-PHY/LP-PHY  -- good on 4311
In-reply-to: <200808160029.56876.mb@bu3sch.de>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Message-id: <48A87B5D.7010402@wetwork.net> (sfid-20080817_223803_317166_0498341B)
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
References: <200808160029.56876.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Works fine here.  iperf same results as prior to patch. 

b43-phy0: Broadcom 4311 WLAN found
b43-phy0 debug: Found PHY: Analog 4, Type 2, Revision 8
b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2

2.6.27-rc2-wl on Ubuntu 8.04 (don't even ask how long it takes to build 
a new kernel and create a debian package and install it...)

Ehud

Michael Buesch wrote:
> This is the first part for the rewrite of the b43 PHY API.
> This is needed in order to make development of N and LP code possible.
>
> PLEASE TEST TEST TEST TEST TEST
>
> Lots of testing on lots of different devices is needed to ensure this
> doesn't introduce regressions due to typos.
> 95% of the patch just moves large parts of the PHY code from one file
> to another. More move-patches will follow.
> 5% of the patch introduces an "ops" based PHY API.
>
> Please test on all of your devices.
>
> http://bu3sch.de/patches/wireless-testing/20080816-0023/patches/002-b43-phy-ops.patch
> Apply against wireless-testing.git
>
> (Not attached to the mail, as it is really big)
> _______________________________________________
> Bcm43xx-dev mailing list
> Bcm43xx-dev@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
>   
