Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44350 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755990AbdEROL1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 10:11:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/10] rtlwifi: btcoex: 21a 1ant: treat ARP as special packet
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170516131957.9513-2-Larry.Finger@lwfinger.net>
References: <20170516131957.9513-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170518141127.3AA2460F68@smtp.codeaurora.org> (sfid-20170518_161206_301012_1BFC0CF2)
Date: Thu, 18 May 2017 14:11:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> We need to pay attention to ARP packets to correctly establish
> connection, and reset the ARP counter when disconnected.
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Pkshih <pkshih@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

10 patches applied to wireless-drivers-next.git, thanks.

de202ba39f0e rtlwifi: btcoex: 21a 1ant: treat ARP as special packet
0ad7bd2d1b64 rtlwifi: btcoex: 21a 1ant: fix some coding style issues
63ad6ea938bf rtlwifi: btcoex: 21a 1ant: add bt_tx_rx_mask into bt info
158707f9584c rtlwifi: btcoex: Restore 23b 1ant routine for tdma adjustment
2d446a5653bd rtlwifi: btcoex: 23b 1ant: rename and coding style modification.
2622d7d86a57 rtlwifi: btcoex: 23b 1ant: TDMA duration for ACL busy
37a5be0cfca6 rtlwifi: btcoex: 23b 1ant: monitor wifi and BT counter
75717802c91b rtlwifi: btcoex: 23b 1ant: check if BT high priority packet exist
12e87c09cfad rtlwifi: btcoex: 23b 1ant: monitor bt is enabled or disabled
12515a08e7b1 rtlwifi: btcoex: 23b 1ant: check PS state before setting tdma duration

-- 
https://patchwork.kernel.org/patch/9729179/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
