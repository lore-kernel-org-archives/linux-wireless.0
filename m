Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48170 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760948AbdEXNvc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 09:51:32 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/10] rtlwifi: btcoex: 23b 1ant: Special packets statistic in
 notification
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170520154907.15590-2-Larry.Finger@lwfinger.net>
References: <20170520154907.15590-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170524135131.87F8C611B4@smtp.codeaurora.org> (sfid-20170524_155310_999418_AF264508)
Date: Wed, 24 May 2017 13:51:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Count and log special packets of DHCP, EAPOL and ARP, and check whether
> the interface is in 4-way handshake.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

10 patches applied to wireless-drivers-next.git, thanks.

fa73a1ebe720 rtlwifi: btcoex: 23b 1ant: Special packets statistic in notification
c34e42aa3e6e rtlwifi: btcoex: 23b 1ant: define wifi in high priority task.
5ae40d993576 rtlwifi: btcoex: 23b 1ant: check more cases when bt is queing
8be514054d26 rtlwifi: btcoex: 23b 1ant: remove verbose log from periodic function
46b5689c3761 rtlwifi: btcoex: 23b 1ant: Add coex_table_type to log
056faad2e980 rtlwifi: btcoex: 23b 1ant: coex table fine tune
1ecdc4363f99 rtlwifi: btcoex: 23b 1ant: fine tune for wifi connected
40ca18823515 rtlwifi: btcoex: 23b 1ant: fine tune for wifi not connected
f9cbb5b4e90e rtlwifi: btcoex: 23b 1ant: fine tune for bt_sco_hid busy
86aeb82563b7 rtlwifi: btcoex: 23b 1ant: turn off ps and tdma mechanism when concurrent mode

-- 
https://patchwork.kernel.org/patch/9738653/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
