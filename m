Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56702 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751735AbeB0Q0Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 11:26:25 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: btcoex: fix argument typo of if-statement found by
 Coccinelle
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180227015724.4782-1-pkshih@realtek.com>
References: <20180227015724.4782-1-pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: <colin.king@canonical.com>, <Larry.Finger@lwfinger.net>,
        <yhchuang@realtek.com>, <linux-wireless@vger.kernel.org>
Message-Id: <20180227162624.AE4D5607EF@smtp.codeaurora.org> (sfid-20180227_172628_181132_3DC427DF)
Date: Tue, 27 Feb 2018 16:26:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> This was detected with static analysis using Coccinelle:
> 
> ./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c:1107:5-18:
> duplicated argument to && or ||
> 
> Reported-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

e28adf9ae63c rtlwifi: btcoex: fix argument typo of if-statement found by Coccinelle

-- 
https://patchwork.kernel.org/patch/10244103/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
