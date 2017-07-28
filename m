Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41396 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752228AbdG1PgE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 11:36:04 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,01/11] rtlwifi: btcoex: Add power_on_setting routine
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170717150954.1441-2-Larry.Finger@lwfinger.net>
References: <20170717150954.1441-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170728153604.31514609FD@smtp.codeaurora.org> (sfid-20170728_173619_297251_85E0EF63)
Date: Fri, 28 Jul 2017 15:36:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> New btcoex uses it to setup antenna before wifi on.
> 
> This patch also restores the content of commit f95d95a7cd55 ("rtlwifi:
> btcoex: rtl8723be: fix ant_sel not work"), which caused a kernel oops
> without this material.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

Failed to apply:

fatal: sha1 information is lacking or useless (drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h).
error: could not build fake ancestor
Applying: rtlwifi: btcoex: Add power_on_setting routine
Patch failed at 0001 rtlwifi: btcoex: Add power_on_setting routine
The copy of the patch that failed is found in: .git/rebase-apply/patch

11 patches set to Changes Requested.

9845421 [v2,01/11] rtlwifi: btcoex: Add power_on_setting routine
9845423 [v2,02/11] rtlwifi: Fix MAX MPDU of VHT capability
9845431 [v2,03/11] rtlwifi: Remove redundant semicolon in wifi.h.
9845435 [v2,04/11] rtlwifi: rtl8192ee: Make driver support 64bits DMA.
9845425 [v2,05/11] rtlwifi: Implement rtl_get_tx_hw_rate to yield correct hw_rate
9845439 [v2,06/11] rtlwifi: Add rtl_get_hal_edca_param() to generate register's format of EDCA.
9845437 [v2,07/11] rtlwifi: Add TX/RX throughput statistics in period
9845427 [v2,08/11] rtlwifi: Add RSSI and RF type to wifi.h for phydm
9845441 [v2,09/11] rtlwifi: Remove BAND_NUM and related fields
9845433 [v2,10/11] rtlwifi: Add bw_update parameter for RA mask update.
9845429 [v2,11/11] rtlwifi: Add module parameter ASPM

-- 
https://patchwork.kernel.org/patch/9845421/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
