Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41400 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938318AbcKQGjM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 01:39:12 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/3,v2] wlcore: Pass win_size taken from ieee80211_sta to FW
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160821112425.11302-2-maxim.altshul@ti.com>
References: <20160821112425.11302-2-maxim.altshul@ti.com>
To: Maxim Altshul <maxim.altshul@ti.com>
Cc: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
        Maxim Altshul <maxim.altshul@ti.com>
Message-Id: <20161117063911.A1209615C4@smtp.codeaurora.org> (sfid-20161117_073915_858398_4F70D6E0)
Date: Thu, 17 Nov 2016 06:39:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maxim Altshul <maxim.altshul@ti.com> wrote:
> When starting a new BA session, we must pass the win_size to the FW.
> 
> To do this we take max_rx_aggregation_subframes (BA RX win size)
> which is stored in ieee80211_sta structure (e.g per link and not per HW)
> 
> We will use the value stored per link when passing the win_size to
> firmware through the ACX_BA_SESSION_RX_SETUP command.
> 
> Signed-off-by: Maxim Altshul <maxim.altshul@ti.com>

2 patches applied to wireless-drivers-next.git, thanks.

42c7372a1116 wlcore: Pass win_size taken from ieee80211_sta to FW
e7ee74b56f23 wlcore: Add RX_BA_WIN_SIZE_CHANGE_EVENT event

-- 
https://patchwork.kernel.org/patch/9292121/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
