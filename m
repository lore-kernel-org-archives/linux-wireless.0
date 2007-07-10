Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2774 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756239AbXGJRfr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2007 13:35:47 -0400
Date: Tue, 10 Jul 2007 13:12:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/14] major mac80211 restructuring/cleanups
Message-ID: <20070710171216.GE7927@tuxdriver.com>
References: <20070621221603.778432000@sipsolutions.net> <20070710153456.471e395e@logostar.upir.cz> <1184075439.15565.11.camel@johannes.berg> <20070710162912.17899683@logostar.upir.cz> <1184079079.15565.13.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1184079079.15565.13.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 10, 2007 at 04:51:18PM +0200, Johannes Berg wrote:
> On Tue, 2007-07-10 at 16:29 +0200, Jiri Benc wrote:

> > which is not upstream. Merging it upstream would mean taking the patch from
> > wireless-dev git and manually modifying it to fit a new structure. And we
> > have a bunch of such patches which should go to 2.6.24 (yes, I really
> > mean .24). Perhaps I'm lazy, but I'd like to avoid that. It's going to be a
> > lot of unpleasant work even without this...
> 
> Which all goes to say that pushing mac80211 for .22 was too fast.

Hmmmm...maybe.  But, what would have been the perfect trigger to
merge it?  At least now we have less bits out-of-stream and have to
do less API-chasing with every new kernel.

John
-- 
John W. Linville
linville@tuxdriver.com
