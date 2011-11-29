Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:32904 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab1K2A4Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 19:56:24 -0500
Date: Mon, 28 Nov 2011 19:55:16 -0500 (EST)
Message-Id: <20111128.195516.37800643865997337.davem@davemloft.net> (sfid-20111129_015634_625463_FD3D332C)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next 2011-11-28
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111128200221.GD2681@tuxdriver.com>
References: <20111128200221.GD2681@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 28 Nov 2011 15:02:22 -0500

> Another big pull request -- my apologies!  I have a couple of
> sub-maintainers that had let their patch queues back-up a bit too
> long...
> 
> This pull request contains a lot of refactoring in the iwlegacy and
> ath6kl drivers.  mac80211 and rndis_wlan get some love as well.  Beyond
> that, there is a handful of small updates and minor fixes to some
> drivers and around the wireless stack.
> 
> Let me know if there are problems!

Pulled, but please push back on the ath6kl guys, they seem to have this
disease where they add tons of debugfs files for controlling things like
QoS from userspace instead of creating and using generic configuration
machanisms via netlink or similar that any other driver could support too.

Thanks.
