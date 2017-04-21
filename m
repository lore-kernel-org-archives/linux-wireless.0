Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33804 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1035829AbdDUGih (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Apr 2017 02:38:37 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/13] rtlwifi: btcoex: 21a 1ant: set tdma and coex table when
 wifi is idle
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170417000700.29057-2-Larry.Finger@lwfinger.net>
References: <20170417000700.29057-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170421063835.F323F611C3@smtp.codeaurora.org> (sfid-20170421_083840_681013_1C0888A8)
Date: Fri, 21 Apr 2017 06:38:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> When wifi is idle, bt could have more resources to transmit, so set the
> tdma and coex table to achieve this.
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Pkshih <pkshih@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

Requested by Larry

13 patches set to Changes Requested.

9683295 [01/13] rtlwifi: btcoex: 21a 1ant: set tdma and coex table when wifi is idle
9683307 [02/13] rtlwifi: btcoex: 21a 1ant: more bt profiling when wifi receives special packet
9683297 [03/13] rtlwifi: btcoex: 21a 1ant: shorten wifi slot when connected scan
9683299 [04/13] rtlwifi: btcoex: 21a 1ant: react to special packet when wifi is not scanning
9683301 [05/13] rtlwifi: btcoex: 21a 1ant: coex table and tdma settings for softap mode
9683319 [06/13] rtlwifi: btcoex: 21a 1ant: wifi slot time adjustment
9683303 [07/13] rtlwifi: btcoex: 21a 1ant: normal mode for retry limit when connected
9683305 [08/13] rtlwifi: btcoex: 21a 1ant: mark packet high priority when scanning
9683315 [09/13] rtlwifi: btcoex: 21a 1ant: use default value when initiating coex
9683317 [10/13] rtlwifi: btcoex: 21a 1ant: re-init coex after wifi leaves IPS
9683311 [11/13] rtlwifi: btcoex: 21a 1ant: treat ARP as special packet
9683309 [12/13] rtlwifi: btcoex: 21a 1ant: fix some coding style issues
9683313 [13/13] rtlwifi: btcoex: 21a 1ant: add bt_tx_rx_mask into bt info

-- 
https://patchwork.kernel.org/patch/9683295/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
