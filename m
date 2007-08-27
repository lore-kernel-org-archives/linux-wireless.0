Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:60936 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbXH0AxN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Aug 2007 20:53:13 -0400
Subject: Re: [RFC 09/11] mac80211, iwlwifi: remove atheros turbo modes
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1187950192.24933.7.camel@johannes.berg>
References: <20070823164500.998912000@sipsolutions.net>
	 <20070823164524.799041000@sipsolutions.net>
	 <1187942429.13078.104.camel@debian.sh.intel.com>
	 <1187950192.24933.7.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 27 Aug 2007 08:47:58 +0800
Message-Id: <1188175678.13078.124.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-08-24 at 12:09 +0200, Johannes Berg wrote:
> Good. I noticed another problems with this patch that I'll be fixing,
> but I am still curious why you define channels with turbo that are
> named 11N or such? 

We used to "borrow" the TURBO mode to distinguish between normal G mode
and 11N G mode (same for A and 11N A). We are now switching to different
approach (add ht_info to mac80211 for 11N), so it is not needed any
more. I'll submit a new patch to reflesh the change together with some
other changes we made for the driver during this period.

Thanks,
-yi
