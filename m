Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mi0.bluebottle.com ([206.188.25.15]:44195 "EHLO
	mi0.bluebottle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbYHURsO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 13:48:14 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by mi0.bluebottle.com (8.13.1/8.13.1) with ESMTP id m7LGhuap002925
	for <linux-wireless@vger.kernel.org>; Thu, 21 Aug 2008 16:43:56 GMT
Message-Id: <200808211643.m7LGhuap002925@mi0.bluebottle.com> (sfid-20080821_194818_985899_69B39A22)
Subject: Re: [PATCH RFT] b43: Rewrite PHY API for N-PHY/LP-PHY
From: Sean Hodges <seanhodges@bluebottle.com>
Reply-To: seanhodges@bluebottle.com
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
In-Reply-To: <200808160029.56876.mb@bu3sch.de>
References: <200808160029.56876.mb@bu3sch.de>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 17:16:23 +0100
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-08-16 at 00:29 +0200, Michael Buesch wrote:
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

As a novice to driver development, is there some way I can help with
testing this?

I have no experience of driver development/testing, but have an N-PHY
BCM4328 wireless NIC that is just itching to be eventually freed from
ndiswrapper :) I'd be happy to lend some help testing new patches and
feeding back results, if I could get a few pointers on where to get
started...

I'm running 2.6.24-19 kernel release, and my card is listed by lspci as:

06:00.0 Network controller: Broadcom Corporation BCM4328 802.11a/b/g/n
(rev 03)


Sean






