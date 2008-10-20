Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:60645 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbYJTIEa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 04:04:30 -0400
Subject: Re: [PATCH v3] mac80211/drivers: rewrite the rate control API
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <1224486587.18024.25.camel@johannes.berg>
References: <1223996147.10113.33.camel@johannes.berg>
	 (sfid-20081014_165703_092655_BE6BA58D) <1224052607.3027.20.camel@johannes.berg>
	 <1224484940.24677.169.camel@debian.sh.intel.com>
	 <1224485319.18024.9.camel@johannes.berg>
	 <1224486368.24677.184.camel@debian.sh.intel.com>
	 <1224486587.18024.25.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 16:04:04 +0800
Message-Id: <1224489844.24677.225.camel@debian.sh.intel.com> (sfid-20081020_100447_024798_FDD59D4F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-10-20 at 01:09 -0600, Johannes Berg wrote:
> Yes, I know that much, but can you tell us how exactly?

I don't know the details either. Will follow up on this.

> It would be good to actually report as accurate as possible (up to
> MAX_RATES) the retries the firmware will have done. We're going to
> export that information to userland in radiotap too.

Sounds like a good idea. The actual number of retried rates should
depend on hardware/firmware. But '5' doesn't look like the possible MAX.

Thanks,
-yi

