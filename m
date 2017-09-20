Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48862 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbdITMo3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 08:44:29 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: btcoexist: 23b 1ant: fix duplicated code for different
 branches
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170831144859.2291-1-Larry.Finger@lwfinger.net>
References: <20170831144859.2291-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170920124429.0F52660134@smtp.codeaurora.org> (sfid-20170920_144432_454764_BF35D51D)
Date: Wed, 20 Sep 2017 12:44:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> A typo led to this issue, which was detected with the help of Coccinelle.
> 
> In addition to fixing the error, the code is refactored to eliminate an
> if statement.
> 
> Addresses-Coverity-ID: 1226788
> 
> Reported-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

0f61953dd0f5 rtlwifi: btcoexist: 23b 1ant: fix duplicated code for different branches

-- 
https://patchwork.kernel.org/patch/9932349/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
