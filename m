Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:45351 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab2ECRGW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 13:06:22 -0400
Date: Thu, 03 May 2012 13:05:16 -0400 (EDT)
Message-Id: <20120503.130516.1008806127286088740.davem@davemloft.net> (sfid-20120503_190631_627087_72DED537)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next 2012-05-03
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120503152206.GL9285@tuxdriver.com>
References: <20120503152206.GL9285@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 3 May 2012 11:22:06 -0400

> This is a batch of updates intended for 3.5.  It also includes a pull
> from the wireless tree which resolved some build dependencies.
> 
> Highlights of this pull request include some refactoring in the
> bluetooth directories, some HT enhancements for mac80211, an expansion
> of the ethtool support for cfg80211- and mac80211-based drivers,
> and some more iwlwifi refactoring.
> 
> It looks like some of the bluetooth device ID patches got committed
> on both the bluetooth and the bluetooth-next trees.  I'll ask them to
> be more careful about that, but I didn't think it was worth asking
> for rebases since that would be disruptive to the downstream trees
> and since git handles the situation reasonably well already.

Pulled, thanks John.
