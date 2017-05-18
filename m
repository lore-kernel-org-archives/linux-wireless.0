Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43108 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756127AbdEROIG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 10:08:06 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3,01/10] rtlwifi: btcoex: 21a 2ant: set tdma with rssi states
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170511190119.23426-2-Larry.Finger@lwfinger.net>
References: <20170511190119.23426-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170518140801.4BF8860F6B@smtp.codeaurora.org> (sfid-20170518_160838_846673_B5E9B802)
Date: Thu, 18 May 2017 14:08:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> if bt rssi is high, adjust the duration of wifi to a longer period to
> let the wifi transmit under this bt profiling.
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Pkshih <pkshih@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

10 patches applied to wireless-drivers-next.git, thanks.

7b5ca74959c3 rtlwifi: btcoex: 21a 2ant: set tdma with rssi states
d86aa50608e1 rtlwifi: btcoex: 21a 2ant: refine btc8821a2ant_action_hid_a2dp
be04040108ae rtlwifi: btcoex: 21a 2ant: set wifi standby when halting of entering ips
4a279c2b73fd rtlwifi: btcoex: 21a 2ant: settings before wifi firmware is ready
eee87f26203f rtlwifi: btcoex: 21a 2ant: add pnp notidy to avoid LPS/IPS mismatch
1f88d59e350e rtlwifi: btcoex: 21a 2ant: run mechanism if status changes or auto adjust is set
728b61067701 rtlwifi: btcoex: 21a 2ant: init wlan when leave ips
a3b2ba8666b7 rtlwifi: btcoex: 21a 2ant: refine bt info notify to have more profilings
e7dc32033378 rtlwifi: btcoex: 21a 2ant: fix PTA unstable problem when hw init
3acd1685d71e rtlwifi: btcoex: 21a 2ant: remove unused antenna detection variables

-- 
https://patchwork.kernel.org/patch/9722763/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
