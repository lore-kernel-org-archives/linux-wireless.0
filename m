Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49868 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750989AbdALPLF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 10:11:05 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [next] rtlwifi: rtl8192de: fix missing curly braces
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170110095521.4410-1-vincent.stehle@laposte.net>
References: <20170110095521.4410-1-vincent.stehle@laposte.net>
To: Vincent <vincent.stehle@laposte.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Joe Perches <joe@perches.com>,
        Ping-Ke Shih <pkshih@realtek.com>
Message-Id: <20170112151105.0D38F613D3@smtp.codeaurora.org> (sfid-20170112_161110_213612_20F91B49)
Date: Thu, 12 Jan 2017 15:11:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vincent <vincent.stehle@laposte.net> wrote:
> Restore some curly braces that have been removed in commit c93ac39da006457f
> ("rtlwifi: Remove some redundant code") while removing redundant messages
> and extraneous braces.
> 
> This fixes the following smatch warning:
> 
>   drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c:326 rtl92d_download_fw() warn: curly braces intended?
> 
> ...and the following coccinelle warning:
> 
>   drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c:325:2-38: code aligned with following code on line 326
> 
> Fixes: c93ac39da006457f ("rtlwifi: Remove some redundant code")
> Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Joe Perches <joe@perches.com>
> Cc: Ping-Ke Shih <pkshih@realtek.com>

Larry also sent a fix:

rtlwifi: rtl8192de: Remove a pointless goto
https://patchwork.kernel.org/patch/9508121/

Patch set to Superseded.

-- 
https://patchwork.kernel.org/patch/9506837/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
