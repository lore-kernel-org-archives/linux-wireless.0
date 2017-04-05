Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48636 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754668AbdDEMyP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 08:54:15 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3,01/12] rtlwifi: btcoex: remove unused functions
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170403184147.18409-1-Larry.Finger@lwfinger.net>
References: <20170403184147.18409-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170405125415.031A160DDB@smtp.codeaurora.org> (sfid-20170405_145612_978813_819E8887)
Date: Wed,  5 Apr 2017 12:54:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> A number of functions in the Bluetooth Coexistence routines are not used,
> and can be removed.
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Pkshih <pkshih@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

12 patches applied to wireless-drivers-next.git, thanks.

27a31a60a4de rtlwifi: btcoex: remove unused functions
c6821613e653 rtlwifi: btcoex: follow linux coding style
155305f5b0eb rtlwifi: btcoex: 23b 2ant: add btc8723b2ant_limited_rx to reduce agg size
61d802619bc6 rtlwifi: btcoex: 23b 2ant: detect if bt is slave, and modify tdma
55e9e37da2ce rtlwifi: btcoex: 23b 2ant: monitor wifi counter for allocate tdma time
e4782bc6ce9a rtlwifi: btcoex: 23b 2ant: less sensitive to tx rate penalty
3f957062c96c rtlwifi: btcoex: 23b 2ant: adjust wifi duration for bt a2dp
f36714fbfa6d rtlwifi: btcoex: 23b 2ant: coex table fine tune
7ff98093220b rtlwifi: btcoex: 23b 2ant: remove redundant bt stack report
44e9a5340e68 rtlwifi: btcoex: 23b 2ant: finer bt power adjustment
a66a4176b74c rtlwifi: btcoex: 23b 2ant: add comments to describe how duration adjusted
495d36e66814 rtlwifi: btcoex: 23b 2ant: new fw use h2c to control GNT_BT

-- 
https://patchwork.kernel.org/patch/9660143/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
