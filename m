Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58272 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751116AbdFUQok (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 12:44:40 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/11] rtlwifi: btcoex: call bind to setup btcoex
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170618161249.6146-2-Larry.Finger@lwfinger.net>
References: <20170618161249.6146-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170621152855.E42106084E@smtp.codeaurora.org> (sfid-20170621_184454_726369_D904CE1F)
Date: Wed, 21 Jun 2017 15:28:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> New btcoex add a function 'bind' to connect adapter, so we should call
> it during initializing.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

11 patches applied to wireless-drivers-next.git, thanks.

87d8a9f35202 rtlwifi: btcoex: call bind to setup btcoex
43f5644a90a0 rtlwifi: btcoex: set correct interface type and parameter.
f95d95a7cd55 rtlwifi: btcoex: rtl8723be: fix ant_sel not work
e332e2a29448 rtlwifi: Correct power save capability while init mac80211
79b64ed7a6b2 rtlwifi: extend debug_comp to u64
8479580b5267 rtlwifi: Add TX report and disable key to force wait until report acked.
5b757ba757d4 rtlwifi: Revise special packet notification to be readable format.
54685f9c7af1 rtlwifi: Add btcoex record_pwr_mode
2635664e6e4a rtlwifi: Add rx ampdu cfg for btcoexist.
c692205da18b rtlwifi: add btc_is_bt_lps_on() for btcoexist
42213f2f3590 rtlwifi: btcoexist control to enter/leave LPS

-- 
https://patchwork.kernel.org/patch/9794911/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
