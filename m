Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34929 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376Ab2KZJKZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 04:10:25 -0500
Message-ID: <1353921049.9488.0.camel@jlt4.sipsolutions.net> (sfid-20121126_101029_595292_0897FA3A)
Subject: Re: RFC[4/4] mac80211: add statistic to debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Saravana <saravanad@posedge.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 26 Nov 2012 10:10:49 +0100
In-Reply-To: <50B2FC03.4050101@posedge.com>
References: <50B2FC03.4050101@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-26 at 10:50 +0530, Saravana wrote:
> Provide additional statistic support to the debugfs.

Please don't send four patches with the same subject. ALso, your
description here (debugfs) is obviously wrong:


> +++ b/net/mac80211/cfg.c
> @@ -396,6 +396,18 @@ void sta_set_rate_info_tx(struct sta_info *sta,
>   	rate_idx_to_bitrate(rinfo, sta, rate->idx);
>   }
> 
> +void sta_set_rate_info_rx(struct sta_info *sta,struct rate_info *rinfo)

johannes

