Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46338 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751670AbdBOJPK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 04:15:10 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] rtlwifi: btcoexist: Fix if == else warnings in
 halbtc8821a2ant.c
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170212004605.1308-2-Larry.Finger@lwfinger.net>
References: <20170212004605.1308-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Julia Lawall <julia.lawall@lip6.fr>
Message-Id: <20170215091510.2BE30608EA@smtp.codeaurora.org> (sfid-20170215_101534_217357_F6272652)
Date: Wed, 15 Feb 2017 09:15:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> The 0-DAY kernel test infrastructure reports the following:
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3023:1-3: WARNING: possible condition with no effect (if == else)
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3035:2-4: WARNING: possible condition with no effect (if == else)
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3037:3-5: WARNING: possible condition with no effect (if == else)
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3047:3-5: WARNING: possible condition with no effect (if == else)
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3075:3-5: WARNING: possible condition with no effect (if == else)
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3085:3-5: WARNING: possible condition with no effect (if == else)
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3129:1-3: WARNING: possible condition with no effect (if == else)
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3141:2-4: WARNING: possible condition with no effect (if == else)
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3143:3-5: WARNING: possible condition with no effect (if == else)
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3153:3-5: WARNING: possible condition with no effect (if == else)
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3179:2-4: WARNING: possible condition with no effect (if == else)
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3181:3-5: WARNING: possible condition with no effect (if == else)
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3192:3-5: WARNING: possible condition with no effect (if == else)
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:2677:1-3: WARNING: possible condition with no effect (if == else)
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:2833:1-3: WARNING: possible condition with no effect (if == else)
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:2847:3-5: WARNING: possible condition with no effect (if == else)
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:2857:3-5: WARNING: possible condition with no effect (if == else)
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:2885:3-5: WARNING: possible condition with no effect (if == else)
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:2895:3-5: WARNING: possible condition with no effect (if == else)
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:2940:1-3: WARNING: possible condition with no effect (if == else)
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:2788:2-4: WARNING: possible condition with no effect (if == else)
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:2391:2-4: WARNING: possible condition with no effect (if == else)
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:2417:2-4: WARNING: possible condition with no effect (if == else)
> 
> Reported-by: kbuild-all@01.org
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Julia Lawall <julia.lawall@lip6.fr>

3 patches applied to wireless-drivers-next.git, thanks.

ac0ca72c6f53 rtlwifi: btcoexist: Fix if == else warnings in halbtc8821a2ant.c
42e74946f016 rtlwifi: btcoexist: Fix if == else warnings in halbtc8821a1ant.c
b686784d03e6 rtlwifi: btcoexist: Fix if == else warnings in halbtc8723b1ant.c

-- 
https://patchwork.kernel.org/patch/9568225/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
