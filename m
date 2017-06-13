Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45632 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752512AbdFMHDR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 03:03:17 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/9] rtlwifi: btcoex: add macros to check chip type
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170605152959.27439-2-Larry.Finger@lwfinger.net>
References: <20170605152959.27439-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170613070317.10B13607E8@smtp.codeaurora.org> (sfid-20170613_090336_167515_9F3B9F06)
Date: Tue, 13 Jun 2017 07:03:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> For some external functions that have hardware dependency, we need to
> know the type of the hardware before invoking them.
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

9 patches applied to wireless-drivers-next.git, thanks.

d178b1321e49 rtlwifi: btcoex: add macros to check chip type
753c953bae5d rtlwifi: btcoex: rename ex_halbtc*ant to ex_btc*ant
6fbbc82adfb2 rtlwifi: btcoex: settings before firmware is downloaded
86f9ab2ef4bd rtlwifi: btcoex: hook external PnP notify by chip for wifi driver
60f44100eee7 rtlwifi: btcoex: add settings before the hardware is ready
7937f02d1953 rtlwifi: btcoex: hook external functions for newer chips
0199103ea7ec rtlwifi: btcoex: bind BT coex information with wifi driver
6aafa2307414 rtlwifi: btcoex: remove unused display functions
c42ea613353c rtlwifi: btcoex: let btcoex get wifi rssi and link status

-- 
https://patchwork.kernel.org/patch/9766361/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
