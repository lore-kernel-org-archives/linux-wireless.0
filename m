Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47954
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634AbZLNSlW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 13:41:22 -0500
Date: Mon, 14 Dec 2009 10:41:24 -0800 (PST)
Message-Id: <20091214.104124.98693961.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: Revised wireless tree management practices
From: David Miller <davem@davemloft.net>
In-Reply-To: <200912141924.47370.bzolnier@gmail.com>
References: <200912141720.11465.bzolnier@gmail.com>
	<20091214.100345.57458443.davem@davemloft.net>
	<200912141924.47370.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Mon, 14 Dec 2009 19:24:47 +0100

> On Monday 14 December 2009 07:03:45 pm David Miller wrote:
>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> Date: Mon, 14 Dec 2009 17:20:11 +0100
>> 
>> > Well, in theory all maintainers should be testing -next kernels
>> > so nothing should change also in this regard.
>> 
>> You conveniently did not quote and respond to my comments showing that
>> you can ask git tools to seperate out the changesets for you, regardless
>> of what subsystem maintainers decide to do.
>> 
>> Power is in your hands, really. :-)
> 
> That is simply untrue from Linus' kernel point of view.
> 
> Each networking merge contains multiple sub-merges from wireless tree
> (at random points in networking tree history) which in turn may contain
> multiple sub-merges from Johannes (at random points in wireless tree
> history) and wireless driver sub-projects so unless you are a hardcore
> networking/wireless developer it is practically impossible to make
> a sense out of it in a reasonable time.

That's not true.  I use "gitk -- net/mac80211" all the time and it's
helped me find bugs.  Or try "gitk -- include/tcp* net/ipv4/tcp*" to
hunt down TCP regressions, etc.

You can ignore the merge changesets, they are largely John and
myself sorting out conflicts between two bodies of work, and
concentrate only on the real commits in there that touch those
directories.
