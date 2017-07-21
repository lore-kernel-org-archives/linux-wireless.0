Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54430 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752411AbdGUHnK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2017 03:43:10 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: Revert "rtlwifi: btcoex: rtl8723be: fix ant_sel not work"
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170717143419.12865-1-Larry.Finger@lwfinger.net>
References: <20170717143419.12865-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170721074310.007A8602BE@smtp.codeaurora.org> (sfid-20170721_094315_239439_D862E366)
Date: Fri, 21 Jul 2017 07:43:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> This reverts commit f95d95a7cd5514549dcf6ba754f0ee834cce3e1f.
> 
> With commit f95d95a7cd55 ("rtlwifi: btcoex: rtl8723be: fix ant_sel not
> work"), the kernel has a NULL pointer dereference oops. This content and
> the proper fix will be included in a later patch.
> 
> Fixes: f95d95a7cd55 ("rtlwifi: btcoex: rtl8723be: fix ant_sel not work")
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

Patch applied to wireless-drivers.git, thanks.

271612d72da5 Revert "rtlwifi: btcoex: rtl8723be: fix ant_sel not work"

-- 
https://patchwork.kernel.org/patch/9845333/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
