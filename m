Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45032 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1035858AbdDUGs7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Apr 2017 02:48:59 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/27] rtlwifi: btcoex: Restore 23b 1ant routine for tdma
 adjustment
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170417001111.29384-2-Larry.Finger@lwfinger.net>
References: <20170417001111.29384-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170421064858.0FD87611C0@smtp.codeaurora.org> (sfid-20170421_084903_055676_09585E31)
Date: Fri, 21 Apr 2017 06:48:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Routine btc8723b1ant_tdma_dur_adj_for_acl() was removed in a set of
> Sparse fixes; however, this routine will be needed later.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Pkshih <pkshih@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

Requested by Larry

27 patches set to Changes Requested.

9683321 [01/27] rtlwifi: btcoex: Restore 23b 1ant routine for tdma adjustment
9683323 [02/27] rtlwifi: btcoex: 23b 1ant: rename and coding style modification.
9683325 [03/27] rtlwifi: btcoex: 23b 1ant: TDMA duration for ACL busy
9683333 [04/27] rtlwifi: btcoex: 23b 1ant: monitor wifi and BT counter
9683329 [05/27] rtlwifi: btcoex: 23b 1ant: check if BT high priority packet exist
9683327 [06/27] rtlwifi: btcoex: 23b 1ant: monitor bt is enabled or disabled
9683331 [07/27] rtlwifi: btcoex: 23b 1ant: check PS state before setting tdma duration
9683373 [08/27] rtlwifi: btcoex: 23b 1ant: Switch antenna to wifi or BT.
9683371 [09/27] rtlwifi: btcoex: 23b 1ant: need these information when scan
9683345 [10/27] rtlwifi: btcoex: 23b 1ant: adjust wifi duration for bt a2dp
9683361 [11/27] rtlwifi: btcoex: 23b 1ant: add wifi_only argument to init_hwconfig
9683343 [12/27] rtlwifi: btcoex: 23b 1ant: Add power_on_setting
9683335 [13/27] rtlwifi: btcoex: 23b 1ant: parse more BT information from C2H
9683337 [14/27] rtlwifi: btcoex: 23b 1ant: Setup register for BT WHCK test
9683341 [15/27] rtlwifi: btcoex: 23b 1ant: Add rf status notification
9683339 [16/27] rtlwifi: btcoex: 23b 1ant: fine tune connect notify
9683369 [17/27] rtlwifi: btcoex: 23b 1ant: Revise media status notify to fix no scan result issue
9683347 [18/27] rtlwifi: btcoex: 23b 1ant: Special packets statistic in notification
9683349 [19/27] rtlwifi: btcoex: 23b 1ant: define wifi in high priority task.
9683351 [20/27] rtlwifi: btcoex: 23b 1ant: check more cases when bt is queing
9683367 [21/27] rtlwifi: btcoex: 23b 1ant: remove verbose log from periodic function
9683353 [22/27] rtlwifi: btcoex: 23b 1ant: Add coex_table_type to log
9683365 [23/27] rtlwifi: btcoex: 23b 1ant: coex table fine tune
9683355 [24/27] rtlwifi: btcoex: 23b 1ant: fine tune for wifi connected
9683357 [25/27] rtlwifi: btcoex: 23b 1ant: fine tune for wifi not connected
9683359 [26/27] rtlwifi: btcoex: 23b 1ant: fine tune for bt_sco_hid busy
9683363 [27/27] rtlwifi: btcoex: 23b 1ant: turn off ps and tdma mechanism when concurrent mode

-- 
https://patchwork.kernel.org/patch/9683321/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
