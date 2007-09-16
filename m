Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4431 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583AbXIPDPi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Sep 2007 23:15:38 -0400
Date: Sat, 15 Sep 2007 22:36:00 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net
Subject: Re: Please pull 'adm8211' branch of wireless-2.6
Message-ID: <20070916023600.GA3967@tuxdriver.com>
References: <20070915132220.GE6060@tuxdriver.com> <20070915170018.GC18930@tuxdriver.com> <20070915.112549.79067357.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070915.112549.79067357.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 15, 2007 at 11:25:49AM -0700, David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Sat, 15 Sep 2007 13:00:18 -0400
> 
> > Come to think of it, this driver will depend on some of the mac80211
> > patches Dave M. has queued for net-2.6.24.  Perhaps it would be better
> > if Dave were to merge it with his tree?
> > 
> > Jeff, if you have no objection then please sign-off/ack/whatever so
> > davem can see it.  Dave, in that case please pull this to net-2.6.24.
> 
> There are a lot of things to sort out :-)
> 
> What I'm going to try and accomplish right now is:
> 
> 1) Rebase my tree, I just finished that.
> 2) Integrate linville's upstream-davem stuff into net-2.6.24
> 3) Integrate Jeff's upstream branch into net-2.6.24

Forgot about this part...would you be doing this otherwise?  If not,
I can rearrange this patch (or its successor) so that it is based
off your tree instead.

> 4) Integrate linville's adm8211 driver into net-2.6.24
> 
> We'll see how well that goes.

It sounds like Michael will be respinning in response to Jeff's
comments...?

John
-- 
John W. Linville
linville@tuxdriver.com
