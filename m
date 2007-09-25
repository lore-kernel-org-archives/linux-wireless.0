Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yue.linux-ipv6.org ([203.178.140.15]:45522 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbXIYCtR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 22:49:17 -0400
Date: Tue, 25 Sep 2007 11:50:54 +0900 (JST)
Message-Id: <20070925.115054.25066958.yoshfuji@linux-ipv6.org>
To: jt@hpl.hp.com, larry.finger@lwfinger.net
Cc: linville@tuxdriver.com, mb@bu3sch.de,
	linux-wireless@vger.kernel.org, davem@davemloft.net,
	torvalds@linux-foundation.org, yoshfuji@linux-ipv6.org
Subject: Re: 2.6.23-rc regression: bcm43xx does not work after commit  4cf92a3c
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?=
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <20070919163237.GA7914@bougret.hpl.hp.com>
References: <20070918174202.GB1466@bougret.hpl.hp.com>
	<46F09167.5020606@lwfinger.net>
	<20070919163237.GA7914@bougret.hpl.hp.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

What is the status of this issue?
2.6.23-rc8 does not help me.

Regression is not right even if the change does
"fix" some aspects.   Please apply the "right" fix
or revert it before 2.6.23.

Thank you.

In article <20070919163237.GA7914@bougret.hpl.hp.com> (at Wed, 19 Sep 2007 09:32:37 -0700), Jean Tourrilhes <jt@hpl.hp.com> says:

> On Tue, Sep 18, 2007 at 10:03:03PM -0500, Larry Finger wrote:
> > Jean Tourrilhes wrote:
> > > 
> > > 	Could you be more explicit ? Reverting the patch will just
> > > bring back the old bug, and the old code was obviously wrong. I don't
> > > like the idea of trading one bug for another bug. It looks to me like
> > > nobody knows what's exactly happening in the driver and we are just
> > > trying random fixes and see what breaks.
> > > 	Could you figure out what's exactly happening and make a
> > > proper fix ?
> > > 	Regards,
> > 
> > It took me nearly two days, but I finally found the correct fix for the bug that made it impossible
> > to set the essid. The resulting patch has been sent to John.
> > 
> > Larry
> 
> 	Yes, the fix looked more extensive than I though, and I guess
> you also fixed other corner cases in the process. Thanks for your
> work, I think you did the right thing...
> 	Regards,
> 
> 	Jean
> 
