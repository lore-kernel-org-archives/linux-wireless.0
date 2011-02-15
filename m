Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38431 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab1BOPPg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 10:15:36 -0500
Date: Tue, 15 Feb 2011 10:03:18 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Nathaniel Smith <njs@pobox.com>, linux-wireless@vger.kernel.org,
	wey-yi.w.guy@intel.com, ilw@linux.intel.com
Subject: Re: [PATCH 4/5] iwlwifi: auto-tune tx queue size to minimize latency
Message-ID: <20110215150317.GA2557@tuxdriver.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
 <1297619803-2832-5-git-send-email-njs@pobox.com>
 <1297685871.3785.39.camel@jlt3.sipsolutions.net>
 <AANLkTinuvxEuuz3-xWkhQ1fA8s7QumJHJQKpd1C48CV1@mail.gmail.com>
 <1297771986.3935.9.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297771986.3935.9.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 15, 2011 at 01:13:06PM +0100, Johannes Berg wrote:

> mac80211 has the advantage that TX status is reported back, so it could
> pretty accurately know how many frames are queued up -- more generically
> this cannot be done.
> 
> But since it's not perfectly accurate right now, it may not be the best
> idea to do this at this time.

Let's not make the perfect the enemy of the good.  An imperfect
implementation at the mac80211 layer is likely better than a somewhat
better implementation for one driver and no implementation for
the rest.

Now, someone help me understand how .11n aggregation complicates this... :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
