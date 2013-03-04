Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:60389 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756660Ab3CDUz6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 15:55:58 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "mcgrof@do-not-panic.com" <mcgrof@do-not-panic.com>,
	Johannes Berg <johannes.berg@intel.com>
Date: Mon, 4 Mar 2013 12:49:07 -0800
Subject: RE: [PATCH v3] regulatory: enable channels 52-64 and 100-144 for
 world roaming
Message-ID: <477F20668A386D41ADCC57781B1F70430D9D8DA3E5@SC-VEXCH1.marvell.com> (sfid-20130304_215601_610110_4CB78C31)
References: <1362429852-9712-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1362429852-9712-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


[...]

> +		/* IEEE 802.11a, channel 100..144 - DFS required */
> +		REG_RULE(5500-10, 5320+10, 160, 6, 20,

5720+10

> +			NL80211_RRF_PASSIVE_SCAN |
> +			NL80211_RRF_NO_IBSS |
> +			NL80211_RRF_DFS),
> 
>  		/* IEEE 802.11a, channel 149..165 */
>  		REG_RULE(5745-10, 5825+10, 80, 6, 20,
> --

Regards,
Bing

