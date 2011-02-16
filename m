Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42564 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab1BPI7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 03:59:33 -0500
Subject: Re: [PATCH 4/5] iwlwifi: auto-tune tx queue size to minimize
 latency
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Nathaniel Smith <njs@pobox.com>, linux-wireless@vger.kernel.org,
	wey-yi.w.guy@intel.com, ilw@linux.intel.com
In-Reply-To: <20110215150317.GA2557@tuxdriver.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
	 <1297619803-2832-5-git-send-email-njs@pobox.com>
	 <1297685871.3785.39.camel@jlt3.sipsolutions.net>
	 <AANLkTinuvxEuuz3-xWkhQ1fA8s7QumJHJQKpd1C48CV1@mail.gmail.com>
	 <1297771986.3935.9.camel@jlt3.sipsolutions.net>
	 <20110215150317.GA2557@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Feb 2011 09:59:25 +0100
Message-ID: <1297846765.4533.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-15 at 10:03 -0500, John W. Linville wrote:
> On Tue, Feb 15, 2011 at 01:13:06PM +0100, Johannes Berg wrote:
> 
> > mac80211 has the advantage that TX status is reported back, so it could
> > pretty accurately know how many frames are queued up -- more generically
> > this cannot be done.
> > 
> > But since it's not perfectly accurate right now, it may not be the best
> > idea to do this at this time.
> 
> Let's not make the perfect the enemy of the good.  An imperfect
> implementation at the mac80211 layer is likely better than a somewhat
> better implementation for one driver and no implementation for
> the rest.

Well, no, I think the fact that it's not perfect probably means that the
bandwidth/packet estimate will drift if any packets are dropped etc.

> Now, someone help me understand how .11n aggregation complicates this... :-)

I'll try ... later :-)

johannes

