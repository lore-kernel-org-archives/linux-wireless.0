Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3302 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbXJZVXg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 17:23:36 -0400
Date: Fri, 26 Oct 2007 17:23:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: stable@kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: reorder association debug output
Message-ID: <20071026212303.GF23415@tuxdriver.com> (sfid-20071026_222346_791066_531A7428)
References: <11934326793639-git-send-email-linville@tuxdriver.com> <11934326801557-git-send-email-linville@tuxdriver.com> <11934326803769-git-send-email-linville@tuxdriver.com> <11934326803330-git-send-email-linville@tuxdriver.com> <11934326811535-git-send-email-linville@tuxdriver.com> <11934326813508-git-send-email-linville@tuxdriver.com> <1193432681145-git-send-email-linville@tuxdriver.com> <1193433039.15686.12.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1193433039.15686.12.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 26, 2007 at 11:10:39PM +0200, Johannes Berg wrote:
> 
> On Fri, 2007-10-26 at 17:04 -0400, John W. Linville wrote:
> > From: Johannes Berg <johannes@sipsolutions.net>
> > 
> > There's no reason to warn about an invalid AID field when the
> > association was denied.
> 
> I don't really see a reason to have this in stable, do we really want

Perhaps not.  I'm still not totally clear on the "stable" criteria
(probably my own fault).

Anyway, this probably got caught-up in a "what recent fixes still
apply to 2.6.23" sweep.  Still, I don't see why this wouldn't be
desirable for someone running 2.6.23?

> that? And if so, we should roll in the fix for the warning :)

I was trying to "clear the baffles" before rolling-out the more
recent fixes.  If this patch isn't rejected for stable then it might
be worth waiting for the warning fix patch pushed yesterday.

John
-- 
John W. Linville
linville@tuxdriver.com
