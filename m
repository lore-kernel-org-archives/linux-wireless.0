Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54402
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634AbZLNPTQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 10:19:16 -0500
Date: Mon, 14 Dec 2009 07:19:17 -0800 (PST)
Message-Id: <20091214.071917.82036377.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: bzolnier@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: Revised wireless tree management practices
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091214142602.GC18945@tuxdriver.com>
References: <20091209211054.GB32058@tuxdriver.com>
	<200912141516.12224.bzolnier@gmail.com>
	<20091214142602.GC18945@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 14 Dec 2009 09:26:02 -0500

> On Mon, Dec 14, 2009 at 03:16:12PM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
>> Now if only somebody could come up with a way to split 'monstermerges'
>> for Linus tree into something more fine-grained (thousands of commits in
>> a single merge is too much for anyone not directly involved into current
>> networking developments IMHO) I would be completely satisfied. ;)
> 
> You'll have to talk to Dave about that one, although FWIW I'm not
> sure how to prevent that with the current "merge window" policy...

Well, the merge window event does not exist in a vacuum.

Development is happening all during this time and checking the
subsystem trees of interest to you every week or so will do wonders to
your sanity. :-)

And you should be looking often anyways so that nothing comes as a
surprise once the merge window actually happens.  Things need to be
discovered and sorted long before then.
