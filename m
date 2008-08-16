Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:59206 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750743AbYHPEBF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Aug 2008 00:01:05 -0400
Message-ID: <48A65100.9050407@lwfinger.net> (sfid-20080816_060110_439023_05CDBD65)
Date: Fri, 15 Aug 2008 23:01:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH RFT] b43: Rewrite PHY API for N-PHY/LP-PHY
References: <200808160029.56876.mb@bu3sch.de>
In-Reply-To: <200808160029.56876.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

The patch works fine on the 802.11g portion of my BCM4312/1, which 
seems to be the same as a BCM4311/1. This card has a PCIe format. I 
also tested on my PCMCIA version of a BCM4318. That card works, but 
the maximum transmit rate is only about 1/2 of what I get without it. 
The card has a rev 09 802.11 core, a rev 7 PHY, and a rev 3 analog 
part. I still have to test on a PCI format BCM4306/3 card, but I 
suspect that you have already tested the 4306.

Larry
