Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:36938 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab2G0V0o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 17:26:44 -0400
Date: Fri, 27 Jul 2012 14:26:41 -0700 (PDT)
Message-Id: <20120727.142641.1758613016734325267.davem@davemloft.net> (sfid-20120727_232702_078550_B00E97E9)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-07-27
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120727155806.GB6110@tuxdriver.com>
References: <20120727155806.GB6110@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 27 Jul 2012 11:58:06 -0400

> These fixes are intended for the 3.6 stream.
> 
> Hauke Mehrtens provides a pair of bcma fixes, one to fix a build
> regression on mips and another to correct a pair of missing iounmap
> calls.
> 
> Thomas Huehn offers a mac80211_hwsim fix to avoid a possible
> use-after-free bug.
> 
> Please let me know if there are problems!

Pulled, thanks John.
