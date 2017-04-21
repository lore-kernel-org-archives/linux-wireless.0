Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59354 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1035700AbdDUGhN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Apr 2017 02:37:13 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/10] rtlwifi: btcoex: 21a 2ant: set tdma with rssi states
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170416190428.23857-2-Larry.Finger@lwfinger.net>
References: <20170416190428.23857-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170421063712.A6708611C5@smtp.codeaurora.org> (sfid-20170421_083717_722119_1BAA02FA)
Date: Fri, 21 Apr 2017 06:37:12 +0000 (UTC)
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

Requested by Larry

10 patches set to Changes Requested.

9683075 [01/10] rtlwifi: btcoex: 21a 2ant: set tdma with rssi states
9683077 [02/10] rtlwifi: btcoex: 21a 2ant: refine btc8821a2ant_action_hid_a2dp
9683079 [03/10] rtlwifi: btcoex: 21a 2ant: set wifi standby when halting of entering ips
9683081 [04/10] rtlwifi: btcoex: 21a 2ant: settings before wifi firmware is ready
9683083 [05/10] rtlwifi: btcoex: 21a 2ant: add pnp notidy to avoid LPS/IPS mismatch
9683087 [06/10] rtlwifi: btcoex: 21a 2ant: run mechanism if status changes or auto adjust is set
9683085 [07/10] rtlwifi: btcoex: 21a 2ant: init wlan when leave ips
9683089 [08/10] rtlwifi: btcoex: 21a 2ant: refine bt info notify to have more profilings
9683093 [09/10] rtlwifi: btcoex: 21a 2ant: fix PTA unstable problem when hw init
9683091 [10/10] rtlwifi: btcoex: 21a 2ant: remove unused antenna detection variables

-- 
https://patchwork.kernel.org/patch/9683075/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
