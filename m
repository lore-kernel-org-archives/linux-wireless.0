Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48385 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571AbZJKKgS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 06:36:18 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] b43: fix ieee80211_rx() context
Date: Sun, 11 Oct 2009 12:35:35 +0200
Cc: John Linville <linville@tuxdriver.com>,
	David Miller <davem@davemloft.net>,
	Kalle Valo <kalle.valo@iki.fi>,
	Dave Young <hidave.darkstar@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1255256361.4095.56.camel@johannes.local> <200910111226.44778.mb@bu3sch.de> <1255257066.4095.66.camel@johannes.local>
In-Reply-To: <1255257066.4095.66.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200910111235.36986.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 11 October 2009 12:31:06 Johannes Berg wrote:
> On Sun, 2009-10-11 at 12:26 +0200, Michael Buesch wrote:
> > On Sunday 11 October 2009 12:19:21 Johannes Berg wrote:
> > > Due to the way it interacts with the networking
> > > stack and other parts of mac80211, ieee80211_rx()
> > > must be called with disabled softirqs.
> > 
> > Is this stated in the documentation somewhere?
> 
> No. However, there are many things that aren't in the documentation, I'm
> working on a patch to add a note.

Ok, thanks a lot.

> I just wanted to provide a
> rationale for me fixing this bug instead of you.

Since when do we require that in commit messages?

> If you disagree that 
> this is an accurate representation, I invite you to summarise the thread
> that caused this miserable situation of a known bug not being fixed for
> a very long time despite appropriate fixes being known in your own words
> for the commit message.

If you'd care _that_ much, you could have just reverted my commit.
Yes, I introduced the regression and I was unable to cook up a fix for it. So the logical
reaction to that would be to revert my commit.

-- 
Greetings, Michael.
