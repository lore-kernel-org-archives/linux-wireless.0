Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:53119 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbYHUQ7Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 12:59:16 -0400
From: Michael Buesch <mb@bu3sch.de>
To: seanhodges@bluebottle.com
Subject: Re: [PATCH RFT] b43: Rewrite PHY API for N-PHY/LP-PHY
Date: Thu, 21 Aug 2008 18:58:51 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <200808160029.56876.mb@bu3sch.de> <200808211643.m7LGhuaq002925@mi0.bluebottle.com>
In-Reply-To: <200808211643.m7LGhuaq002925@mi0.bluebottle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808211858.51899.mb@bu3sch.de> (sfid-20080821_185921_538957_0D1CA264)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 21 August 2008 18:16:23 Sean Hodges wrote:
> On Sat, 2008-08-16 at 00:29 +0200, Michael Buesch wrote:
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
> > 
> > http://bu3sch.de/patches/wireless-testing/20080816-0023/patches/002-b43-phy-ops.patch
> > Apply against wireless-testing.git
> 
> As a novice to driver development, is there some way I can help with
> testing this?
> 
> I have no experience of driver development/testing, but have an N-PHY

To say it once again:
Despite the fact that the subject of this email mentiones N and LP PHYs, it
implements _nothing_ N and LP related. It just _prepares_ the code for the
future when we will add N and LP stuff (and other PHY stuff. Also A/B/G related).

-- 
Greetings Michael.
