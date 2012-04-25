Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:53191 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363Ab2DYTPY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 15:15:24 -0400
Date: Wed, 25 Apr 2012 15:14:13 -0400 (EDT)
Message-Id: <20120425.151413.147876040219098157.davem@davemloft.net> (sfid-20120425_211545_467628_A6E5553A)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-04-25
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120425180639.GA16900@tuxdriver.com>
References: <20120425180639.GA16900@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 25 Apr 2012 14:06:39 -0400

> This is a batch of fixes intended for 3.4.
> 
> The brcmsmac patch from Eldad Zack eliminates some log spam.
> The mac80211 patch from Eliad Peller fixes a WARNING when removing
> an interface.  The two patches from Gabor Juhos combine to address
> a regression with some bad tx power settings for an Atheros chip.
> Johannes Berg gives us a fix for some bad hardware initializtion in
> iwlwifi, which resulted in hardware lockups.  Larry Finger gives us
> a fix for an oops when unloading the rtlwifi modules.  Meenakshi
> Venkataraman fixes some firmware version values in iwlwifi that
> result in attempts to load firmware that does not exist in the wild.
> Stanislav Yakovlev fixes a race condition in the ipw2200 driver.
> Finally,  Stanislaw Gruszka provides an iwlwifi fix to avoid a NULL
> pointer access.

Pulled, thanks John.
