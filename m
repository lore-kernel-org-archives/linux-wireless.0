Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47788 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750987AbdEXNuG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 09:50:06 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/10] rtlwifi: btcoex: 23b 1ant: Switch antenna to wifi or BT.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170519155937.17526-2-Larry.Finger@lwfinger.net>
References: <20170519155937.17526-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170524135005.E86F0611B4@smtp.codeaurora.org> (sfid-20170524_155014_119933_BE01BAFB)
Date: Wed, 24 May 2017 13:50:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Since wifi and BT share the same physical antenna, we should switch antenna
> to fit every situation.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

10 patches applied to wireless-drivers-next.git, thanks.

96e3baadd01a rtlwifi: btcoex: 23b 1ant: Switch antenna to wifi or BT.
c01fd117e581 rtlwifi: btcoex: 23b 1ant: need these information when scan
0d4ae1422622 rtlwifi: btcoex: 23b 1ant: adjust wifi duration for bt a2dp
8ffb5b692687 rtlwifi: btcoex: 23b 1ant: add wifi_only argument to init_hwconfig
f9c6ede79af3 rtlwifi: btcoex: 23b 1ant: Add power_on_setting
7d0d2c14cc03 rtlwifi: btcoex: 23b 1ant: parse more BT information from C2H
53e18bcf3c7a rtlwifi: btcoex: 23b 1ant: Setup register for BT WHCK test
3ceac0a772b0 rtlwifi: btcoex: 23b 1ant: Add rf status notification
f9af7af4a10c rtlwifi: btcoex: 23b 1ant: fine tune connect notify
29c1de91937a rtlwifi: btcoex: 23b 1ant: Revise media status notify to fix no scan result issue

-- 
https://patchwork.kernel.org/patch/9737583/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
