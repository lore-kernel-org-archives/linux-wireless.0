Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57296 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754615AbcILJh3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 05:37:29 -0400
Message-ID: <1473673046.27358.0.camel@sipsolutions.net> (sfid-20160912_113732_871651_CB48F9D1)
Subject: Re: [PATCH 1/3 v3] mac80211: RX BA support for sta
 max_rx_aggregation_subframes
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Altshul <maxim.altshul@ti.com>,
        linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Date: Mon, 12 Sep 2016 11:37:26 +0200
In-Reply-To: <20160822141404.12814-1-maxim.altshul@ti.com>
References: <20160822141404.12814-1-maxim.altshul@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-08-22 at 17:14 +0300, Maxim Altshul wrote:
> The ability to change the max_rx_aggregation frames is useful
> in cases of IOP.
> 
> There exist some devices (latest mobile phones and some AP's)
> that tend to not respect a BA sessions maximum size (in Kbps).
> These devices won't respect the AMPDU size that was negotiated during
> associasion (even though they do respect the maximal number of
> packets).
> 
> This violation is characterized by a valid number of packets in
> a single AMPDU. Even so, the total size will exceed the size
> negotiated
> during association.
> 
> Eventually, this will cause some undefined behavior, which in turn
> causes the hw to drop packets, causing the throughput to plummet.
> 
> This patch will make the subframe limitation to be held by each
> station,
> instead of being held only by hw.
> 
> Signed-off-by: Maxim Altshul <maxim.altshul@ti.com>
> 
Applied.

I fixed the indentation of the commit message, please note for the
future.

johannes
