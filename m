Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:39342 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756922AbYHUNIZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 09:08:25 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH RFT] b43: Rewrite PHY API for N-PHY/LP-PHY
Date: Thu, 21 Aug 2008 15:07:57 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <200808160029.56876.mb@bu3sch.de> <48AC9D60.9000902@lwfinger.net>
In-Reply-To: <48AC9D60.9000902@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808211507.58659.mb@bu3sch.de> (sfid-20080821_150854_643322_F25EE3E7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 21 August 2008 00:40:32 Larry Finger wrote:
> Michael Buesch wrote:
> > This is the first part for the rewrite of the b43 PHY API.
> > This is needed in order to make development of N and LP code possible.
> > 
> > PLEASE TEST TEST TEST TEST TEST
> > 
> > Lots of testing on lots of different devices is needed to ensure this
> > doesn't introduce regressions due to typos.
> > 95% of the patch just moves large parts of the PHY code from one file
> > to another. More move-patches will follow.
> > 5% of the patch introduces an "ops" based PHY API.
> > 
> > Please test on all of your devices.
> 
> I have now tested on a BCM4311/2 with positive results. The transmit 
> throughput is roughly the same at 20.7 Mbs with a 54 Mbs bulk rate.

Thanks :)

I'll also do more testing and submit the patch soon.

Anybody who didn't test his device, yet, please do so. If you discover
a breakage after the merge, that will be _very_ unfortunate and we will have
to live with the breakage until it is fixed (which can be very hard to do).

-- 
Greetings Michael.
