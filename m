Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56390 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751659AbdF1Rvn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 13:51:43 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,
 1/8] rtlwifi: Fix a2dp choppy while BT RSSI stays on threshold.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170621171538.4462-2-Larry.Finger@lwfinger.net>
References: <20170621171538.4462-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170628175143.4B0D260AD5@smtp.codeaurora.org> (sfid-20170628_195159_311050_3FB7AEEE)
Date: Wed, 28 Jun 2017 17:51:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> In this case, BTC asks to enter/leave PS mode frequently to cause A2DP
> choppy.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

8 patches applied to wireless-drivers-next.git, thanks.

135f4fbd75d7 rtlwifi: Fix a2dp choppy while BT RSSI stays on threshold.
a70883920ea1 rtlwifi: Do IQK only once to reduce wifi occupy antenna
1024b31629bd rtlwifi: Modify power mode parameters of 8723be and 8821ae.
838dd0d3ffe6 rtlwifi: Update some cases in btc_get function -- roam, 5G, AP mode, and return value.
8488e211d665 rtlwifi: Add return value to btc_set.
f1cb27eda3a6 rtlwifi: Add ap_num field for btcoexist
c76ab8e75442 rtlwifi: Fill ap_num field by driver
76f146b6645b rtlwifi: Add in_4way field for btcoexist

-- 
https://patchwork.kernel.org/patch/9802331/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
