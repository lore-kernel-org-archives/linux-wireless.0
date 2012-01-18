Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:40560 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758007Ab2ARVCS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 16:02:18 -0500
Date: Wed, 18 Jan 2012 16:01:08 -0500 (EST)
Message-Id: <20120118.160108.339801707448275765.davem@davemloft.net> (sfid-20120118_220238_289834_62B0E8D0)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-01-18
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120118201212.GN12733@tuxdriver.com>
References: <20120118201212.GN12733@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 18 Jan 2012 15:12:12 -0500

> Here is another small group of fixes intended for 3.3.  Included is
> a fix from Javier Cardona to make the mesh code always use the right
> headroom size for mesh management frames, a fix from Johannes Berg to
> point a debugfs link to the right place, another fix from Johannes that
> properly cleans-up some state in mac80211 after a deauth request,
> and a fix from Stanislaw Gruszka to avoid a potential infinite
> loop in brcmsmac.  Also included is a small Kconfig fix from me to
> discourage configurations with overlapping hardware support between
> b43 and brcmsmac.
> 
> Please let me know if there are problems!

Pulled, thanks John.
