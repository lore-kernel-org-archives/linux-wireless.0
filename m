Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36113
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752300AbXIOSZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Sep 2007 14:25:54 -0400
Date: Sat, 15 Sep 2007 11:25:49 -0700 (PDT)
Message-Id: <20070915.112549.79067357.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: Please pull 'adm8211' branch of wireless-2.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070915170018.GC18930@tuxdriver.com>
References: <20070915132220.GE6060@tuxdriver.com>
	<20070915170018.GC18930@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Sat, 15 Sep 2007 13:00:18 -0400

> Come to think of it, this driver will depend on some of the mac80211
> patches Dave M. has queued for net-2.6.24.  Perhaps it would be better
> if Dave were to merge it with his tree?
> 
> Jeff, if you have no objection then please sign-off/ack/whatever so
> davem can see it.  Dave, in that case please pull this to net-2.6.24.

There are a lot of things to sort out :-)

What I'm going to try and accomplish right now is:

1) Rebase my tree, I just finished that.
2) Integrate linville's upstream-davem stuff into net-2.6.24
3) Integrate Jeff's upstream branch into net-2.6.24
4) Integrate linville's adm8211 driver into net-2.6.24

We'll see how well that goes.
