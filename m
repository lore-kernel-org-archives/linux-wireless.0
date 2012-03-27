Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:46338 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab2C0W3u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 18:29:50 -0400
Date: Tue, 27 Mar 2012 18:28:41 -0400 (EDT)
Message-Id: <20120327.182841.1664052401394959748.davem@davemloft.net> (sfid-20120328_003007_818212_2220219A)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-03-27
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120327183242.GB20938@tuxdriver.com>
References: <20120327183242.GB20938@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 27 Mar 2012 14:32:42 -0400

> First, we have a MAINTAINERS update -- not truly a "fix", but it might
> help to keep unwanted traffic out of Bob's inbox.  We also have a
> removal of an outdated comment that was overlooked when the related
> code was removed.

MAINTAINERS updates can always go in, so no problems with this.

> Beyond those, we have a fix for a memory leak in ath9k, a cfg80211
> fix to prevent passing bad info over nl80211 to userspace, a tuning
> fix for some rtlwifi family drivers, a couple of minor ath9k tuning
> fixes, a mac80211 use-after-free fix, a couple of rt2x00 thinko fixes,
> an iwlegacy fix to properly set BSSID after an association, and an
> iwlegacy fix to avoid an oops by properly reinitializing a variable
> after reset.

Ok.

I'll pull this in as soon as Linus processes my most recent networking
pull request.

Thanks!
