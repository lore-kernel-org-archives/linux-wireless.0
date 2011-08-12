Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:58610 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab1HLGLL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 02:11:11 -0400
Date: Thu, 11 Aug 2011 23:10:06 -0700 (PDT)
Message-Id: <20110811.231006.537740938354501949.davem@davemloft.net> (sfid-20110812_081126_904869_F8D96A5B)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2011-08-11
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110811182018.GF2566@tuxdriver.com>
References: <20110811182018.GF2566@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 11 Aug 2011 14:20:19 -0400

> This is a little batch of patches intended for 3.1.
> 
> Included is a fix for a typo that incorrectly calibrated an ath9k phy,
> a fix for an skb leak in ath5k, a fix for a bus error on some Broadcom
> SoC using b43, a fix for a memory leak in wl1251, and another pair
> of calibration fixes for ath9k. A handful of device ID updates are
> included as well.
> 
> Please let me know if there are problems!

Pulled, thanks John.
