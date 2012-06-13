Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52664 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab2FMFkJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 01:40:09 -0400
Message-ID: <1339566003.4519.1.camel@jlt3.sipsolutions.net> (sfid-20120613_074029_987711_35CE642D)
Subject: Re: [PATCH] nl80211: specify RSSI threshold when scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Cc: kvalo@qca.qualcomm.com, ath6kl-devel@qualcomm.com,
	linux-wireless@vger.kernel.org
Date: Wed, 13 Jun 2012 07:40:03 +0200
In-Reply-To: <1339533801-32016-1-git-send-email-c_tpeder@qca.qualcomm.com>
References: <1339533801-32016-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-12 at 13:43 -0700, Thomas Pedersen wrote:
> Support configuring an RSSI threshold in dBm (s32) when requesting
> scheduled scan, below which a BSS won't be reported by the cfg80211
> driver.

I'm confused -- were you going to do scheduled scan only? Makes sense,
but if you could maybe change the subject a bit to "specify ... in
scheduled scan"?

> + * @NL80211_ATTR_SCHED_SCAN_MATCH_RSSI: RSSI threshold (in dBm) for reporting a
> + *	BSS in scan results. 0 to turn off filtering.

No ... leave out to turn off filtering.

> + * @rssi_thold: don't report scan results below this threshold

would be good to repeat the units


> +			rssi = tb[NL80211_ATTR_SCHED_SCAN_MATCH_SSID];

rssi = ... SSID :-)

johannes


