Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:57396 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932446AbeARUgx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 15:36:53 -0500
Date: Thu, 18 Jan 2018 15:36:51 -0500 (EST)
Message-Id: <20180118.153651.1709714615193043829.davem@davemloft.net> (sfid-20180118_213701_039536_CC246AAF)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        johannes.berg@intel.com
Subject: Re: [PATCH] cfg80211: fix station info handling bugs
From: David Miller <davem@davemloft.net>
In-Reply-To: <20180116222022.13161-1-johannes@sipsolutions.net>
References: <20180116222022.13161-1-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 16 Jan 2018 23:20:22 +0100

> From: Johannes Berg <johannes.berg@intel.com>
> 
> Fix two places where the structure isn't initialized to zero,
> and thus can't be filled properly by the driver.
> 
> Fixes: 4a4b8169501b ("cfg80211: Accept multiple RSSI thresholds for CQM")
> Fixes: 9930380f0bd8 ("cfg80211: implement IWRATE")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> Dave, can you apply this as an exception? I'm not really expecting
> any other patches to show up now, and seems easier to have a single
> patch than a whole pull request (especially now that patchwork seems
> to be swallowing mine ...)

Sure, applied, thanks Johannes.
