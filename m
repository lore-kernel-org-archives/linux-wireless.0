Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:24262 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756911AbXJRTl2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2007 15:41:28 -0400
Date: Thu, 18 Oct 2007 21:41:23 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: Rate problems with iwl3945
Message-ID: <20071018194122.GL10674@kernel.dk> (sfid-20071018_204132_978715_0B1D1336)
References: <20071018191102.GI10674@kernel.dk> <1192735782.15285.48.camel@johannes.berg> <20071018193624.GK10674@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071018193624.GK10674@kernel.dk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 18 2007, Jens Axboe wrote:
> On Thu, Oct 18 2007, Johannes Berg wrote:
> > Hi,
> > 
> > > Copying some files I noticed it was slow, though.
> > 
> > Can you check that the right mode is selected? There's a bugfix pending
> > for mac80211 that makes it select 802.11b mode rather than 802.11g. I
> > don't remember whether I've asked this already so if I did please accept
> > my apology. FWIW, the fix is by me (in all fairness, the regression was
> > also introduced by me) titled "[PATCH v2] mac80211: fix set_channel
> > regression"
> 
> Indeed, it's running 802.11b. Even so, why is it switching down to 5.5M?
> Link quality is around 96/100, I'm sitting about a meter away from the
> AP right now.
> 
> So where do I find this fix?

Ah found it, in the wireless git repo. Testing...

-- 
Jens Axboe

