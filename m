Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57792 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbeDXR1q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 13:27:46 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: btcoex: remove identical statements within if-else
 branches
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180409075131.7535-1-pkshih@realtek.com>
References: <20180409075131.7535-1-pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: <gustavo@embeddedor.com>, <linux-wireless@vger.kernel.org>
Message-Id: <20180424172745.EB1E060881@smtp.codeaurora.org> (sfid-20180424_192750_138093_347FE83B)
Date: Tue, 24 Apr 2018 17:27:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Since the statements are identical, we can safely remove the statements.
> The commit 42e74946f016 ("rtlwifi: btcoexist: Fix if == else warnings in
> halbtc8821a1ant.c") had fixed the statements, but the commit c6821613e653
> ("rtlwifi: btcoex: follow linux coding style") that converted coding style
> and upgraded btcoex didn't include the fix.
> 
> Reported-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

8cf304a85378 rtlwifi: btcoex: remove identical statements within if-else branches

-- 
https://patchwork.kernel.org/patch/10330711/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
