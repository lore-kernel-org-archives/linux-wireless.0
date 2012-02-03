Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47341 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab2BCG0u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 01:26:50 -0500
Subject: Re: [PATCH 00/11] station management & auth/assoc redesign
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20120202205227.GC2568@tuxdriver.com>
References: <20120120125516.000124996@sipsolutions.net>
	 <CAB3XZEdjn3nk8_pnb6ZaW7CbFXgJg44bkVykx8m5iHY=t+vnqA@mail.gmail.com>
	 <4F2AA822.2040303@sipsolutions.net>  <20120202205227.GC2568@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Feb 2012 22:26:26 -0800
Message-ID: <1328250386.4023.2.camel@jlt3.sipsolutions.net> (sfid-20120203_072653_811426_E4DDF3A7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-02 at 15:52 -0500, John W. Linville wrote:

> > I haven't kept track, and I have no idea why it wouldn't be?
> 
> The patches didn't apply.  I haven't taken the time yet to work it out.
> 
> If you would like to repost a patchset that applies cleanly on top
> of the current base, that would probably speed it up. :-)

Ok, so ... you're going to run into issues either way. The reason they
don't apply to wireless-next is that I created them on top of
wireless-testing, and that has 

commit bc4934bc61d0a11fd62c5187ff83645628f8be8b
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Wed Jan 18 14:10:25 2012 +0100

    mac80211: fix work removal on deauth request

which my patches are diffed against. I could rediff them against
wireless-next, but then you're going to run into merge issues when you
try to merge that back -- it may be easier to put the commit above into
wireless-next as well to avoid this?

In any case, let me know what you want me to do -- it may have to wait a
bit as I'm travelling back home tomorrow, only to leave again on Sunday
for more travel.

johannes

