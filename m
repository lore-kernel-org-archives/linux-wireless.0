Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:55388 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751563AbYHPSJG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Aug 2008 14:09:06 -0400
Message-ID: <48A717C0.6020705@lwfinger.net> (sfid-20080816_200911_911357_C482DECA)
Date: Sat, 16 Aug 2008 13:09:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH RFT] b43: Rewrite PHY API for N-PHY/LP-PHY
References: <200808160029.56876.mb@bu3sch.de> <48A65100.9050407@lwfinger.net>
In-Reply-To: <48A65100.9050407@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> 
> The patch works fine on the 802.11g portion of my BCM4312/1, which seems 
> to be the same as a BCM4311/1. This card has a PCIe format. I also 
> tested on my PCMCIA version of a BCM4318. That card works, but the 
> maximum transmit rate is only about 1/2 of what I get without it. The 
> card has a rev 09 802.11 core, a rev 7 PHY, and a rev 3 analog part. I 
> still have to test on a PCI format BCM4306/3 card, but I suspect that 
> you have already tested the 4306.

Forget what I said about the loss of transmit rate. Once I did a 
proper test, it is the same with or without the patch. For the 
BCM4318, the b43 rate is slightly reduced from using bcm43xx. The 
difference is not really great, but a reproducible reduction from 16.6 
to 14.2 Mbs with the iwconfig rate set at 54 Mbs. By comparison, the 
BCM4312 is over 20 Mbs.

Larry

