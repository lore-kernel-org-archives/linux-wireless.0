Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:45981 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753847AbXGJO3P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2007 10:29:15 -0400
Date: Tue, 10 Jul 2007 16:29:12 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/14] major mac80211 restructuring/cleanups
Message-ID: <20070710162912.17899683@logostar.upir.cz>
In-Reply-To: <1184075439.15565.11.camel@johannes.berg>
References: <20070621221603.778432000@sipsolutions.net>
	<20070710153456.471e395e@logostar.upir.cz>
	<1184075439.15565.11.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 10 Jul 2007 15:50:39 +0200, Johannes Berg wrote:
> On Tue, 2007-07-10 at 15:34 +0200, Jiri Benc wrote:
> 
> > But: It would make putting changes currently in wireless-dev to upstream a
> > nightmare. I wouldn't be able to take patches in the form they were
> > committed anymore and would need to heavily modify them.
> 
> Why? We could just mirror these changes to upstream too.

Unfortunately, content of upstream ieee80211.c is different - it doesn't
contain .11n and wmm pieces, etc.

But even if it can be applied upstream, it doesn't solve anything. Imagine
a patch which was merged into wireless-dev before this restructuring and
which is not upstream. Merging it upstream would mean taking the patch from
wireless-dev git and manually modifying it to fit a new structure. And we
have a bunch of such patches which should go to 2.6.24 (yes, I really
mean .24). Perhaps I'm lazy, but I'd like to avoid that. It's going to be a
lot of unpleasant work even without this...

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
