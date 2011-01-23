Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33257 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1AWJFc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jan 2011 04:05:32 -0500
Subject: Re: [PATCH 01/14] iwlwifi: use mac80211 throughput trigger
From: Johannes Berg <johannes@sipsolutions.net>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1295654809-5790-2-git-send-email-wey-yi.w.guy@intel.com>
References: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1295654809-5790-2-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Jan 2011 10:05:26 +0100
Message-ID: <1295773526.3639.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That should have

From: Johannes Berg <johannes.berg@intel.com>

:-)

> Instead of keeping track of LED blink speed
> in the driver, use the new mac80211 trigger
> and link it up with an LED classdev that we
> now register. This also allows users more
> flexibility in how they want to have the LED
> blink or not.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

...


