Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49658 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752339AbdFUQek (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 12:34:40 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [07/10] rtlwifi: Fill ap_num filed by vendor command
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170620003218.17010-8-Larry.Finger@lwfinger.net>
References: <20170620003218.17010-8-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170621151721.0052060A4F@smtp.codeaurora.org> (sfid-20170621_183507_333925_3B2A27C9)
Date: Wed, 21 Jun 2017 15:17:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> The ap_num can be filled by wpa_cli's VENDOR command.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

This is a perfect example why I have been against vendor commands in the past.
I already regret changing my mind...

If you want me to seriously consider taking a patch adding a vendor command I
need GOOD justifications why a normal nl80211 command is not suitable and which
are properly documented in the commit log. One sentence definitely
is not enough.

Larry, please drop all patches related to vendor commands in this patch and
resend. Adding vendor commands should be in a separate patchset so it can be
discussed without blocking anything else.

-- 
https://patchwork.kernel.org/patch/9798295/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
