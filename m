Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40860 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933953AbeAXPlM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 10:41:12 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/10] rtlwifi: btcoex: extend get_wifi_bw to support bandwidth
 80M
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180119064551.10084-2-pkshih@realtek.com>
References: <20180119064551.10084-2-pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Message-Id: <20180124154112.4E1E36090E@smtp.codeaurora.org> (sfid-20180124_164117_241482_6D922EBC)
Date: Wed, 24 Jan 2018 15:41:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> The rtlwifi newer ICs support 80M bandwidth in 5G band, so extend
> get_wifi_bw() to know bandwidth 80M that helps btcoex to make correct
> decisions.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

9 patches applied to wireless-drivers-next.git, thanks.

66d0f9deba36 rtlwifi: btcoex: extend get_wifi_bw to support bandwidth 80M
17bf85101181 rtlwifi: btcoex: Add switch band notify for btc
f243bca13893 rtlwifi: btcoex: Add variable ant_div_cfg to support antenna diversity
ee373844849c rtlwifi: btcoex: add scan_notify within ips_notify if RFON
9177c3363994 rtlwifi: btcoex: Add wifi_only series ops to control solo card
8d73e53e8a87 rtlwifi: btcoex: add boolean variables dbg_mode
ba3cca4d0c3e rtlwifi: 8822be has to report vht capability to mac80211
be98db155646 rtlwifi: Add ratr_table for newer IC
a75f3eebfa3d rtlwifi: Add spec_ver to check whether use new rate-id or not

-- 
https://patchwork.kernel.org/patch/10174643/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
