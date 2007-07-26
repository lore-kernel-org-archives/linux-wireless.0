Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:40976
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669AbXGZSNb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 14:13:31 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx-mac80211: Fix specs typo for baseband attenuation
Date: Thu, 26 Jul 2007 20:11:48 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <46a8ccbd.wNQamvQ9e0RJ0XZK%Larry.Finger@lwfinger.net> <200707261931.41448.mb@bu3sch.de> <46A8E1D8.5040301@lwfinger.net>
In-Reply-To: <46A8E1D8.5040301@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707262011.48527.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 26 July 2007 20:03:04 Larry Finger wrote:
> Michael Buesch wrote:
> > 
> > Last time I checked this code it matched the specs. And that's not too
> > long ago.
> > Did the specs change?
> 
> We had a complaint that a change in the V3 specs broke a BCM4306/rev 2 card using bcm43xx - it 
> received but did not transmit. I verified the breakage and found that reverting a patch fixed the 
> problem. I contacted Joseph, who found that he had mixed the branches when doing the specs.
> 
> This morning, I found that bcm43xx-mac80211 has the same problem. I have not yet asked Joseph to 
> recheck the specs; however, the patch I submitted allows my phy->rev == 1 card to work. Without it, 
> it does not. I think there is an error in the specs in that place.

Ok, nice.
I always like some nice explanation like this for this kind of patches.
Because changing code based on "Specs changed, dunno why, so let's change this too"
are always hairy and broke stuff in the past. :)

I'll test and merge this as soon as you resubmitted it.

-- 
Greetings Michael.
