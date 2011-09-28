Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:36781 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab1I1Con (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 22:44:43 -0400
Date: Tue, 27 Sep 2011 22:43:33 -0400 (EDT)
Message-Id: <20110927.224333.1502961724066678494.davem@davemloft.net> (sfid-20110928_044511_497391_2F6C6D00)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2011-09-27
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110927210031.GA2471@tuxdriver.com>
References: <20110927210031.GA2471@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 27 Sep 2011 17:00:31 -0400

> Here is another last (?) batch of fixes intended for 3.1.  Included is a
> scanning-related regression fix that avoids a potential crash, a buffer
> overflow fix in cfg80211, an fix for an uninitialized variable in
> rtlwifi, a fix for a DMA-related WARNING in ath9k, a fix for a DMA hang
> in ath9k, and two iwlegacy fixes backported from prior iwlagn fixes, one
> for avoiding interruptible waits and another for avoiding a command
> queue timeout.
> 
> Please let me know if there are problems!

Pulled, thanks John.
