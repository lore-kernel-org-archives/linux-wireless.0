Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38134 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932334AbcCHQw1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 11:52:27 -0500
Message-ID: <1457455943.24270.8.camel@sipsolutions.net> (sfid-20160308_175316_904652_C11D376F)
Subject: Re: [PATCH v1] cfg80211/nl80211: Add support for
 NL80211_STA_INFO_RX_DURATION
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, kvalo@codeaurora.org,
	mohammed@codeaurora.org
Date: Tue, 08 Mar 2016 17:52:23 +0100
In-Reply-To: <1457348614-10584-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1457348614-10584-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-03-07 at 16:33 +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Add support for new netlink attribute 'NL80211_STA_INFO_RX_DURATION'
> This flag will be set when drivers can fill rx_duration (vendor
> specific total air time(usecs) for data/management frames from the
> connected client) via 'drv_sta_statistics' callback
> 
> Also make sta_info flags 'filled' as 64 bit to accommodate for new
> per station stats. Extend 'PUT_SINFO' for supporting rx_duration
> field and any new per sta information in future
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> ---
> [v1] 
> 1. Fixed typo for accommodate
> 2. changed the doc for rx_duration as 'vendor specific
> implementation'

No, I want it defined for all cases, not left undefined.

johannes
