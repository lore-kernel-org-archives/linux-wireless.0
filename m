Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37648 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751972AbeDRV1B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 17:27:01 -0400
Message-ID: <1524086817.3024.9.camel@sipsolutions.net> (sfid-20180418_232708_549847_241A3F15)
Subject: Re: [PATCH 1/3] ethtool: Support ETHTOOL_GSTATS2 command.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Wed, 18 Apr 2018 23:26:57 +0200
In-Reply-To: <1524016176-3881-1-git-send-email-greearb@candelatech.com> (sfid-20180418_034951_095176_E2F46A6C)
References: <1524016176-3881-1-git-send-email-greearb@candelatech.com>
         (sfid-20180418_034951_095176_E2F46A6C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-04-17 at 18:49 -0700, greearb@candelatech.com wrote:
> 
> + * @get_ethtool_stats2: Return extended statistics about the device.
> + *	This is only useful if the device maintains statistics not
> + *	included in &struct rtnl_link_stats64.
> + *      Takes a flags argument:  0 means all (same as get_ethtool_stats),
> + *      0x1 (ETHTOOL_GS2_SKIP_FW) means skip firmware stats.
> + *      Other flags are reserved for now.

It'd be pretty hard to know which flags are firmware stats?

Anyway, there's no way I'm going to take this patch, so you need to
float it on netdev first (best CC us here) and get it applied there
before we can do anything on the wifi side.

johannes
