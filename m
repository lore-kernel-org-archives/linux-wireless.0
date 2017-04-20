Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37686 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751230AbdDTHYq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 03:24:46 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/19] rtlwifi: btcoex: 21a 2ant: limit rx aggregation size to
 avoid bt interrupt
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170413180710.19953-2-Larry.Finger@lwfinger.net>
References: <20170413180710.19953-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170420072445.F3AA661151@smtp.codeaurora.org> (sfid-20170420_092457_645069_D057C9B3)
Date: Thu, 20 Apr 2017 07:24:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> Larger packets have higher opportunity to be interrupt by bt signal.
> In order to shorten the transmission time, control the packet
> aggregation size.
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Pkshih <pkshih@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

19 patches applied to wireless-drivers-next.git, thanks.

930d2bf242d6 rtlwifi: btcoex: 21a 2ant: limit rx aggregation size to avoid bt interrupt
4776d349071d rtlwifi: btcoex: 21a 2ant: monitor if bt is slave or not
eebc58782eff rtlwifi: btcoex: 21a 2ant: monitor wifi counter to check network status
4b1f6eaac344 rtlwifi: btcoex: 21a 2ant: update bt profiling information
aed6b11e4fc2 rtlwifi: btcoex: 21a 2ant: finer adjustment of bt power
7cc7f1a18bcc rtlwifi: btcoex: 21a 2ant: move from bt_stack_info to bt_link_info
5a81969c1cc3 rtlwifi: btcoex: 21a 2ant: suffer less tx penalty from retry
d9158ea1d1bd rtlwifi: btcoex: 21a 2ant: check power save state before pstdma
d09199eb2038 rtlwifi: btcoex: 21a 2ant: do not check wifi bandwidth
d4acd81ed268 rtlwifi: btcoex: 21a 2ant: centralized control of coex table
3fd7ba4c764c rtlwifi: btcoex: 21a 2ant: check if wifi status changed
9153c11cefa3 rtlwifi: btcoex: 21a 2ant: ignore wifi if it is at 5G band
aae1e8f5a0f0 rtlwifi: btcoex: 21a 2ant: set coex table and tdma when bt inquiry
8c670a1b1dae rtlwifi: btcoex: 21a 2ant: let PTA circuit control the switch
8189d81890c1 rtlwifi: btcoex: 21a 2ant: slot time fine tune
4b7649192687 rtlwifi: btcoex: 21a 2ant: tdma cases for low wifi/bt rssi
3506bc286abe rtlwifi: btcoex: 21a 2ant: action for wifi is idle/linking/common
20ec48e51d25 rtlwifi: btcoex: 21a 2ant: fix invalid argument passed
3f775d5cee79 rtlwifi: btcoex: 21a 2ant: refine tdma duration adjust function

-- 
https://patchwork.kernel.org/patch/9679781/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
