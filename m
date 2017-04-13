Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46740 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbdDMOKO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 10:10:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/11] rtlwifi: btcoex: 23b 2ant: set coex table when wifi is
 idle
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170406201958.25642-2-Larry.Finger@lwfinger.net>
References: <20170406201958.25642-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170413141013.9A53460D70@smtp.codeaurora.org> (sfid-20170413_161017_622231_FE815B85)
Date: Thu, 13 Apr 2017 14:10:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> When wifi is idle, the bt should have more resource to transmit.
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Pkshih <pkshih@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

11 patches applied to wireless-drivers-next.git, thanks.

470eec1a3d0a rtlwifi: btcoex: 23b 2ant: set coex table when wifi is idle
2037b83c12d1 rtlwifi: btcoex: 23b 2ant: treat too many low prio packets as retry
acb9c779ecc5 rtlwifi: btcoex: 23b 2ant: remove debugging code for 0x948
ae889ebc76c9 rtlwifi: btcoex: 23b 2ant: need those information when scan
7558668d0536 rtlwifi: btcoex: 23b 2ant: wifi is not actually off in mp mode
4e6becc0448b rtlwifi: btcoex: 23b 2ant: power on settings for coex
6dcf041eabd1 rtlwifi: btcoex: 23b 2ant: before firmware ready settings
2e6689824a4c rtlwifi: btcoex: 23b 2ant: fine tune for bt pan_edr_a2dp
110944027627 rtlwifi: btcoex: 23b 2ant: fine tune for bt hid_a2dp
588a290b4642 rtlwifi: btcoex: 23b 2ant: notify more bt information
f4a23e194ef3 rtlwifi: btcoex: 23b 2ant: some hi-prio pkt will cause hid_exist

-- 
https://patchwork.kernel.org/patch/9668357/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
