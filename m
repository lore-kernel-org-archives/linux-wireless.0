Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lizzard.sbs.de ([194.138.37.39]:29248 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757855Ab3JOJng (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 05:43:36 -0400
Message-ID: <1381830012.3711.50.camel@djensen-laptop> (sfid-20131015_114339_747878_17DE3982)
Subject: Re: [PATCH] cfg80211: fix channel to frequency mapping in 5.9GHz
 range
From: Dennis H Jensen <dennis.h.jensen@siemens.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Tue, 15 Oct 2013 11:40:12 +0200
In-Reply-To: <1381763193.13092.19.camel@jlt4.sipsolutions.net>
References: <1381492780-3068-1-git-send-email-dennis.h.jensen@siemens.com>
	 <1381499778.14293.21.camel@jlt4.sipsolutions.net>
	 <1381506302.3711.10.camel@djensen-laptop>
	 <1381752176.13092.10.camel@jlt4.sipsolutions.net>
	 <1381752976.3711.14.camel@djensen-laptop>
	 <1381759370.13092.11.camel@jlt4.sipsolutions.net>
	 <1381762681.3711.36.camel@djensen-laptop>
	 <1381763193.13092.19.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-10-14 at 17:06 +0200, Johannes Berg wrote:
> On Mon, 2013-10-14 at 16:58 +0200, Dennis H Jensen wrote:
> 
> > > > The commit 59eb21a6504731fc16db4cf9463065dd61093e08 moved those channels
> > > > to 4.9 GHz but left a hole in the 5.9 Ghz range.
> > > 
> > > But there was no +/- 15 before, so what gives?
> > 
> > Well no :) but there also wasn't a special case for that particular
> > channel set (182 - 196).
> 
> Yes, but then before 5910 would have been channel 182. Now you're making
> it channel 197. That doesn't really make sense at all.

OK, fair enough, but the fact is that there is a hole in the frequencies
that were added in 802.11p.

> > In case that doesn't do it. What is needed to get channel 182 to be 5910
> > MHz as Annex E defines for the US and Europe? Channel to frequency
> > mapping based on operating class?
> 
> Annex E is the 802.11 spec, to get something into that ...

You misunderstood me; the European operating class 14, for example,
states that channel 182 is to be 5910.

Best regards,
Dennis


