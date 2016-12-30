Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45538 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751493AbcL3NK1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 08:10:27 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/14] rtlwifi: Correct power save capability while init mac80211
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161202014833.6856-2-Larry.Finger@lwfinger.net>
References: <20161202014833.6856-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Vincent Fann <vincent_fann@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        shaofu <shaofu@realtek.com>, Ping-Ke Shih <pkshih@realtek.com>
Message-Id: <20161230131026.C825561389@smtp.codeaurora.org> (sfid-20161230_141030_846260_D34DCF97)
Date: Fri, 30 Dec 2016 13:10:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Set IEEE80211_HW_SUPPORTS_PS when driver is fwlps
> Because mac80211 control SW-LPS only, we add constraints to avoid errors.
> 
> Signed-off-by: Vincent Fann <vincent_fann@realtek.com>
> Signed-off-by: shaofu <shaofu@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Dropped per Larry's request.

14 patches set to Changes Requested.

9457587 [01/14] rtlwifi: Correct power save capability while init mac80211
9457609 [02/14] rtlwifi: Fix programing CAM content sequence.
9457607 [03/14] rtlwifi: Set retry limit depends on vif type.
9457601 [03/14] rtlwifi: extend debug_comp to u64
9457613 [05/14] rtlwifi: Add TX report and disable key will wait until report acked.
9457611 [06/14] rtlwifi: rtl8723be: btcoexist: Add single_ant_path
9457589 [07/14] rtlwifi: move btcoex's ant_num declaration
9457603 [08/14] rtlwifi: rtl8723be: btcoex: add package_type function to btcoex
9457593 [09/14] rtlwifi: ibtcoex: move bt_type declaration
9457591 [10/14] rtlwifi: Add BTC_TRACE_STRING to new btcoex
9457605 [11/14] rtlwifi: Add a new enumeration value to btc_set_type
9457595 [12/14] rtlwifi: btcoexist: Add vendor definition for new btcoexist
9457597 [13/14] rtlwifi: rtl8723be: fix ant_sel code
9457599 [14/14] rtlwifi: Add work queue for c2h cmd.

-- 
https://patchwork.kernel.org/patch/9457587/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
