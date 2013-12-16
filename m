Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42690 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3LPUdW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 15:33:22 -0500
Message-ID: <1387225998.2057.36.camel@jlt4.sipsolutions.net> (sfid-20131216_213324_765538_CA60464E)
Subject: Re: [PATCH v2] mac80211: add helper functions for tracking P2P NoA
 state
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 16 Dec 2013 21:33:18 +0100
In-Reply-To: <1386626388-45880-1-git-send-email-nbd@openwrt.org>
References: <1386626388-45880-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-12-09 at 22:59 +0100, Felix Fietkau wrote:

> +/**
> + * ieee80211_parse_p2p_noa - initialize NoA tracking data from P2P IE
> + *
> + * @attr: P2P NoA IE
> + * @data: NoA tracking data
> + * @tsf: current TSF timestamp
> + */
> +int ieee80211_parse_p2p_noa(const struct ieee80211_p2p_noa_attr *attr,
> +			    struct ieee80211_noa_data *data, u32 tsf);

Since the return value isn't some sort of negative error, I think it'd
be worthwhile to document it.

johannes

