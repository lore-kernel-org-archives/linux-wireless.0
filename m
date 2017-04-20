Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39686 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751322AbdDTH0i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 03:26:38 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/14] rtlwifi: btcoex: 21a 2ant: turn on sw dac swing and check
 if is sco_only
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170415203200.22979-2-Larry.Finger@lwfinger.net>
References: <20170415203200.22979-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>
Message-Id: <20170420072637.575CB6114D@smtp.codeaurora.org> (sfid-20170420_092641_695530_658A3BC4)
Date: Thu, 20 Apr 2017 07:26:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> Use software dac swing and double check if it is sco_only to set the
> tdma for voice quality.
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Pkshih <pkshih@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>

14 patches applied to wireless-drivers-next.git, thanks.

1a2534930e9e rtlwifi: btcoex: 21a 2ant: turn on sw dac swing and check if is sco_only
124e50ff6582 rtlwifi: btcoex: 21a 2ant: add threshold to examine bt rssi
10c2e1cc15e4 rtlwifi: btcoex: 21a 2ant: force wifi to use RF path A
70a8adef7108 rtlwifi: btcoex: 21a 2ant: more combinations of wifi/bt rssi state
f0557cf062c7 rtlwifi: btcoex: 21a 2ant: fix some coding style issues
137cc90f094a rtlwifi: btcoex: 21a 2ant: set tdma based on rssi state amd limit rx agg size
0fcad45bdbf7 rtlwifi: btcoex: 21a 2ant: add multiport action for p2p/miracast
a4162ea71b39 rtlwifi: btcoex: 21a 2ant: monitor extra wifi rssi to examine network status
f76184d02457 rtlwifi: btcoex: 21a 2ant: notify fw the number of APs
c129bc843b62 rtlwifi: btcoex: 21a 2ant: dec bt power according to bt rssi and set tdma
97632f8c0a93 rtlwifi: btcoex: 21a 2ant: macro for bt rssi threshold
63a7e8109b2c rtlwifi: btcoex: 21a 2ant: do not limit rx agg size
67cbe62a27dc rtlwifi: btcoex: 21a 2ant: just return when wifi is under ips
f9558f5fc86b rtlwifi: btcoex: 21a 2ant: wifi is linking action

-- 
https://patchwork.kernel.org/patch/9682441/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
