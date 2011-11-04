Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42330 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517Ab1KDOis (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 10:38:48 -0400
Subject: Re: [PATCH v3 1/3] mac80211: Support forcing station to disable HT
 (802.11n).
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EB2CCD7.3010907@candelatech.com>
References: <1320299722-30113-1-git-send-email-greearb@candelatech.com>
	 (sfid-20111103_065534_192366_EF6ABFB6) <1320309465.3950.14.camel@jlt3.sipsolutions.net>
	 <4EB2CCD7.3010907@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Nov 2011 15:38:42 +0100
Message-ID: <1320417522.3969.85.camel@jlt3.sipsolutions.net> (sfid-20111104_153851_283067_2DCF3E2D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-03 at 10:18 -0700, Ben Greear wrote:

> >> --- a/net/mac80211/mlme.c
> >> +++ b/net/mac80211/mlme.c
> >
> > I'd rather split this up into cfg80211/mac80211. In fact, maybe
> > splitting it into one cfg80211 and one mac80211 patch, instead of three
> > different patches that span both might be worthwhile?
> 
> I really don't care either way.  Just let me know how you want it
> and I'll split it up thus.  Just please do not change your mind later,
> splitting patches is nothing but work :P

:-)
Shouldn't be a lot of work to split along subsystems, though of course
API updates would have to be done right away.

johannes

