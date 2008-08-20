Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:53269 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752062AbYHTWkk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2008 18:40:40 -0400
Message-ID: <48AC9D60.9000902@lwfinger.net> (sfid-20080821_004044_340060_954B5478)
Date: Wed, 20 Aug 2008 17:40:32 -0500
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

I have now tested on a BCM4311/2 with positive results. The transmit 
throughput is roughly the same at 20.7 Mbs with a 54 Mbs bulk rate.

Larry

