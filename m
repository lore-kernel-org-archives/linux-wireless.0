Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36657
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681AbZFGKhu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 06:37:50 -0400
Date: Sun, 07 Jun 2009 03:37:51 -0700 (PDT)
Message-Id: <20090607.033751.191866033.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2009-06-04
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090604152011.GC2839@tuxdriver.com>
References: <20090604152011.GC2839@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 4 Jun 2009 11:20:11 -0400

> Hopefully this is (almost?) the last wireless pull request for
> non-bugfix patches intended for 2.6.31...
> 
> Included are the usual round of driver updates, mac80211 updates, etc.
> Also included is the long-awaited and slightly controversial rfkill
> rewrite.  The userland guys (i.e. Dan and Marcel) are happy with it,
> and it can clean-up a lot of driver code for wireless.  Henrique has
> some lingering concerns about some corner cases for platform drivers,
> but I think they are relatively minor and will be resolved amicably
> soon.
> 
> Please let me know if there are problems!

Pulled into net-next-2.6 and I'll push it back out to kernel.org
after some build testing.

Thanks!
