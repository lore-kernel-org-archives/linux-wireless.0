Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48056 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757764AbdJMJol (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 05:44:41 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/10] rtlwifi: Fix MAX MPDU of VHT capability
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170929194800.15617-2-Larry.Finger@lwfinger.net>
References: <20170929194800.15617-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20171013094441.2FC4360847@smtp.codeaurora.org> (sfid-20171013_114450_340949_072C1BD2)
Date: Fri, 13 Oct 2017 09:44:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> We must choose only one of VHT_CAP among
> IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895,
> IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991 and
> IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

10 patches applied to wireless-drivers-next.git, thanks.

f06eb3f9c03e rtlwifi: Fix MAX MPDU of VHT capability
ecf4000e0d92 rtlwifi: Remove redundant semicolon in wifi.h.
0c07bd745760 rtlwifi: rtl8192ee: Make driver support 64bits DMA.
cdc9c7a032aa rtlwifi: Implement rtl_get_tx_hw_rate to yield correct hw_rate
c1816f1709e8 rtlwifi: Add rtl_get_hal_edca_param() to generate register's format of EDCA.
74451b935c42 rtlwifi: Add TX/RX throughput statistics in period
08ab7465f36c rtlwifi: Add RSSI and RF type to wifi.h for phydm
aa59a1e7c6e8 rtlwifi: Remove BAND_NUM and related fields
1d22b17744a3 rtlwifi: Add bw_update parameter for RA mask update.
84efbad4f867 rtlwifi: Add module parameter ASPM

-- 
https://patchwork.kernel.org/patch/9978583/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
