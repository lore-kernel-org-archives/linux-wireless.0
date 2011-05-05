Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52262 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab1EEQK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 12:10:57 -0400
Subject: Re: [PATCH 3/3] cfg80211/nl80211: add interval attribute for
 scheduled scans
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1304610694.12586.404.camel@cumari>
References: <1304600420-24227-1-git-send-email-coelho@ti.com>
	 <1304600420-24227-4-git-send-email-coelho@ti.com>
	 <4DC2B78E.3000205@candelatech.com>
	 <1304607108.3594.6.camel@jlt3.sipsolutions.net>
	 <4DC2B941.6@candelatech.com>
	 <1304607500.3594.7.camel@jlt3.sipsolutions.net>
	 (sfid-20110505_165557_965402_0D829BAA)  <1304607552.3594.8.camel@jlt3.sipsolutions.net>
	 <1304610524.12586.403.camel@cumari>  <1304610694.12586.404.camel@cumari>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 May 2011 18:13:21 +0200
Message-ID: <1304612001.3594.10.camel@jlt3.sipsolutions.net> (sfid-20110505_181100_061965_C66524F5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-05-05 at 18:51 +0300, Luciano Coelho wrote:

> > > > But this is a new feature, and a new command, so I don't quite
> > > > understand why an application would think it can send it without the
> > > > interval?
> > > 
> > > Oh wait, I guess you're right, or this should just be part of patch 1
> > > instead so we never have the feature without the requirement to have the
> > > interval given.
> > 
> > Yeah, I could squish this with the previous patch (1/3), but I just
> > reckoned that patch was getting too big, so I decided to make a separate
> > one.
> > 
> > If this whole patch series is taken at the same time, I guess there
> > won't be backwards compatibility problems (except for bisecting,
> > maybe?).
> > 
> > Anyways, I'll leave it as your choice.  Squishing the patch is easy
> > enough. ;)
> 
> Ah, and one more thought... There's no driver implementing this at this
> point, so is there anything to really worry about?

Yeah, good point, no big deal. We can keep it -- I just didn't even
understand why Ben thought it would not be compatible but it makes sense
if you just look at the patch by itself.

johannes

