Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46060 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdDMOJG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 10:09:06 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/13] rtlwifi: btcoex: 23b 2ant: check PS state before setting
 tdma duration
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170404165006.14329-2-Larry.Finger@lwfinger.net>
References: <20170404165006.14329-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170413140905.D0A6B60D70@smtp.codeaurora.org> (sfid-20170413_160910_945689_EF4E29D8)
Date: Thu, 13 Apr 2017 14:09:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> For time division multiple access, the wifi and bt take turns to
> transmit, but we need to let AP know that wifi is under standby mode by
> sending null data to "pretend" entering power saving state using lps
> rpwm.
> 
> But, the fw does not know if it is the actual power saving mode or just a
> fake one to cheat to the AP. Hence, before fw setting the tdma duration,
> the fw needs the driver to check the power saving state first.
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Pkshih <pkshih@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

13 patches applied to wireless-drivers-next.git, thanks.

b01127b26833 rtlwifi: btcoex: 23b 2ant: check PS state before setting tdma duration
b91ed731393b rtlwifi: btcoex: 23b 2ant: rename tdma_adj_type to ps_tdma_du_adj_type
5a347a48467b rtlwifi: btcoex: 23b 2ant: detect ap num and set GNT_BT properly
1712952beabb rtlwifi: btcoex: 23b 2ant: more cases for adjusting tdma duration
b59f02fb7f44 rtlwifi: btcoex: 23b 2ant: fix PTA unstable problem when hw init
609d59acb68a rtlwifi: btcoex: 23b 2ant: add pnp notidy to avoid LPS/IPS mismatch
684df42cd597 rtlwifi: btcoex: 23b 2ant: check more cases when bt is queuing
a0f430b3eaef rtlwifi: btcoex: 23b 2ant: workaround for bt a2dp and hid
3b4fa04d8efd rtlwifi: btcoex: 23b 2ant: tell fw if external or internal switch is used
bcd37f4a0831 rtlwifi: btcoex: 23b 2ant: let bt transmit when hw initialisation done
a8570896b962 rtlwifi: btcoex: 23b 2ant: turn off ps and tdma mechanism when in concurrent mode
c5e2113613bc rtlwifi: btcoex: 23b 2ant: turn off antenna when rssi is too high/low
83cded7a1ef0 rtlwifi: btcoex: 23b 2ant: set coex table when wifi is linking

-- 
https://patchwork.kernel.org/patch/9662061/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
