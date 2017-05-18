Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43496 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755875AbdEROIx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 10:08:53 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/10] rtlwifi: btcoex: 21a 1ant: set tdma and coex table when
 wifi is idle
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170511232438.23159-2-Larry.Finger@lwfinger.net>
References: <20170511232438.23159-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170518140852.79F0760F67@smtp.codeaurora.org> (sfid-20170518_160927_937075_8FE6E648)
Date: Thu, 18 May 2017 14:08:52 +0000 (UTC)
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

10 patches applied to wireless-drivers-next.git, thanks.

8113b9c4000c rtlwifi: btcoex: 21a 1ant: set tdma and coex table when wifi is idle
2fb9ca230fc1 rtlwifi: btcoex: 21a 1ant: more bt profiling when wifi receives special packet
bcd6f89c013c rtlwifi: btcoex: 21a 1ant: shorten wifi slot when connected scan
a4da86768a27 rtlwifi: btcoex: 21a 1ant: react to special packet when wifi is not scanning
24697534ffc0 rtlwifi: btcoex: 21a 1ant: coex table and tdma settings for softap mode
7f1045d0cf87 rtlwifi: btcoex: 21a 1ant: wifi slot time adjustment
93cfe89765ad rtlwifi: btcoex: 21a 1ant: normal mode for retry limit when connected
af4295ad866e rtlwifi: btcoex: 21a 1ant: mark packet high priority when scanning
7ad6ff8897a8 rtlwifi: btcoex: 21a 1ant: use default value when initiating coex
ee406cec8789 rtlwifi: btcoex: 21a 1ant: re-init coex after wifi leaves IPS

-- 
https://patchwork.kernel.org/patch/9723237/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
