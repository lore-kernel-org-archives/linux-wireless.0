Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51300 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752698AbeB0QQS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 11:16:18 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,01/10] rtlwifi: enable mac80211 fast-tx support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180129032641.17841-2-pkshih@realtek.com>
References: <20180129032641.17841-2-pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Message-Id: <20180227161618.1E7DB6084A@smtp.codeaurora.org> (sfid-20180227_171632_328643_B9C67E48)
Date: Tue, 27 Feb 2018 16:16:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Enable the mac80211 fast-tx feature, since our driver already support
> hw_flags required by fast-tx and is able to let mac80211 stack to transmit
> packet through fast-xmit path.
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

10 patches applied to wireless-drivers-next.git, thanks.

6942bdc4bf57 rtlwifi: enable mac80211 fast-tx support
1ca72c3047aa rtlwifi: Add Support VHT to spec_ver
5f380ceff5f5 rtlwifi: Use 6 bits as sequence number of TX report
4a7093b914aa rtlwifi: Extend tx_power_by_rate_offset size for newer IC
81b813ed2fde rtlwifi: Add rate section and its related definition and comment
50da5da1562b rtlwifi: Fix VHT NSS in RC
ed979a1ed46b rtlwifi: add definition radio_mask for RF and maximum bandwidth
2cdd634e7e36 rtlwifi: add efuse ops for other components
d7297a86fc86 rtlwifi: btcoex: add routine to set default port id
94907e8d135b rtlwifi: btcoex: Add 8822be btcoex supported files for wifi only

-- 
https://patchwork.kernel.org/patch/10188949/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
