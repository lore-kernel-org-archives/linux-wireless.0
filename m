Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41840 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbdG1PiD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 11:38:03 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/10] rtlwifi: Add COMP_HALMAC to debug
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170721042440.15839-2-Larry.Finger@lwfinger.net>
References: <20170721042440.15839-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170728153802.AE063609FD@smtp.codeaurora.org> (sfid-20170728_173806_862018_31525ACA)
Date: Fri, 28 Jul 2017 15:38:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Add a debug component ID for halmac
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

Failed to apply:

fatal: sha1 information is lacking or useless (drivers/net/wireless/realtek/rtlwifi/core.c).
error: could not build fake ancestor
Applying: rtlwifi: Issue connection notification to phydm.
Patch failed at 0001 rtlwifi: Issue connection notification to phydm.
The copy of the patch that failed is found in: .git/rebase-apply/patch

10 patches set to Changes Requested.

9856029 [01/10] rtlwifi: Add COMP_HALMAC to debug
9856047 [02/10] rtlwifi: define radio_mask for RF, and extend bw
9856039 [03/10] rtlwifi: Add phydm structure to main header file
9856031 [04/10] rtlwifi: Issue connection notification to phydm.
9856041 [05/10] rtlwifi: Add COMP_PHYDM to debug
9856035 [06/10] rtlwifi: btcoex: Add send_bt_mp common function, and modify related functions.
9856045 [07/10] rtlwifi: btcoex: btcoexist needs rfe_type to make decision
9856043 [08/10] rtlwifi: Use mutex to replace spin_lock in cases of IPS and LPS
9856033 [09/10] rtlwifi: Add halmac structure to wifi.h
9856037 [10/10] rtlwifi: Add phydm debug cmd to debugfs

-- 
https://patchwork.kernel.org/patch/9856029/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
