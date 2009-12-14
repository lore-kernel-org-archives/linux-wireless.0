Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38527
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932496AbZLNTXC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 14:23:02 -0500
Date: Mon, 14 Dec 2009 11:23:04 -0800 (PST)
Message-Id: <20091214.112304.26981627.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: Revised wireless tree management practices
From: David Miller <davem@davemloft.net>
In-Reply-To: <200912142016.00169.bzolnier@gmail.com>
References: <200912141924.47370.bzolnier@gmail.com>
	<20091214.104124.98693961.davem@davemloft.net>
	<200912142016.00169.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Mon, 14 Dec 2009 20:16:00 +0100

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Mon, 14 Dec 2009 20:16:00 +0100

> On Monday 14 December 2009 07:41:24 pm David Miller wrote:
>> That's not true.  I use "gitk -- net/mac80211" all the time and it's
>> helped me find bugs.  Or try "gitk -- include/tcp* net/ipv4/tcp*" to
>> hunt down TCP regressions, etc.
> 
> It helps but with more complex ones you're back to guesswork and applying
> by hand fixes for already fixed ages ago in-the-middle regressions.

Examples?

> commit d7fc02c7bae7b1cf69269992cf880a43a350cdaa
> Merge: ee1262d 28b4d5c
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Tue Dec 8 07:55:01 2009 -0800
> 
>     Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6
> 
>     * git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6: (1815 commits)
> 
> with completely insane amount of changes:
> 
>  1396 files changed, 113877 insertions(+), 71108 deletions(-)
> 
> You may say that I should be following the development as it happens but such
> strict requirement is not present in any other kernel subsystem tree.

About 1400 is drivers/net and about 500 is net

It's going to be a lot of changes no matter how I or John split it
up.

And guess what's just-as if not even more important?  A unified tree
makes things easier for me.  So unless you plan on applying 100
patches a day for me and doing all the cross merges, that's how I plan
to keep doing things :-)
