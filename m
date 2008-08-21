Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp5.freeserve.com ([193.252.22.159]:53527 "EHLO
	smtp5.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484AbYHUWca (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 18:32:30 -0400
Received: from smtp5.freeserve.com (mwinf3423 [10.232.11.123])
	by mwinf3405.me.freeserve.com (SMTP Server) with ESMTP id 5DBE31C00AEC
	for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2008 00:16:08 +0200 (CEST)
Subject: Re: [PATCH RFT] b43: Rewrite PHY API for N-PHY/LP-PHY
From: Sean Hodges <seanhodges@bluebottle.com>
Reply-To: seanhodges@bluebottle.com
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
In-Reply-To: <200808211858.51899.mb@bu3sch.de>
References: <200808160029.56876.mb@bu3sch.de>
	 <200808211643.m7LGhuaq002925@mi0.bluebottle.com>
	 <200808211858.51899.mb@bu3sch.de>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 21:27:45 +0100
Message-Id: <1219350465.8914.2.camel@SEAN-PC> (sfid-20080822_005044_801674_FD4D2489)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the repeated explanation, the offer remains when it might be
needed.

Sean


On Thu, 2008-08-21 at 18:58 +0200, Michael Buesch wrote:
> On Thursday 21 August 2008 18:16:23 Sean Hodges wrote:
> > On Sat, 2008-08-16 at 00:29 +0200, Michael Buesch wrote:
> > > This is the first part for the rewrite of the b43 PHY API.
> > > This is needed in order to make development of N and LP code possible.
> > > 
> > > PLEASE TEST TEST TEST TEST TEST
> > > 
> > > Lots of testing on lots of different devices is needed to ensure this
> > > doesn't introduce regressions due to typos.
> > > 95% of the patch just moves large parts of the PHY code from one file
> > > to another. More move-patches will follow.
> > > 5% of the patch introduces an "ops" based PHY API.
> > > 
> > > Please test on all of your devices.
> > > 
> > > http://bu3sch.de/patches/wireless-testing/20080816-0023/patches/002-b43-phy-ops.patch
> > > Apply against wireless-testing.git
> > 
> > As a novice to driver development, is there some way I can help with
> > testing this?
> > 
> > I have no experience of driver development/testing, but have an N-PHY
> 
> To say it once again:
> Despite the fact that the subject of this email mentiones N and LP PHYs, it
> implements _nothing_ N and LP related. It just _prepares_ the code for the
> future when we will add N and LP stuff (and other PHY stuff. Also A/B/G related).
> 


