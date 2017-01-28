Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52188 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750718AbdA1Gqz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Jan 2017 01:46:55 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>
Subject: Re: [PATCH 05/11] rtlwifi: btcoexist: Change logging in halbtc8192e2ant.c
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
        <20170120212716.29887-6-Larry.Finger@lwfinger.net>
Date: Sat, 28 Jan 2017 08:46:50 +0200
In-Reply-To: <20170120212716.29887-6-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Fri, 20 Jan 2017 15:27:10 -0600")
Message-ID: <874m0jheat.fsf@purkki.adurom.net> (sfid-20170128_074658_145069_64D40BEE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> This routine uses its own debugging macros These are changed to use the
> the recently rewritten RT_TRACE macro. There are also some renamed
> variables that were missed in the previous step.
>
> The only functional change is that some debugging statements have been
> dropped based on the final code supplied by Realtek.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Ping-Ke Shih <pkshih@realtek.com>
> ---
>  .../wireless/realtek/rtlwifi/btcoexist/Makefile    |   1 +
>  .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    | 825 +++++++++++----------
>  2 files changed, 417 insertions(+), 409 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile b/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile
> index d1454d4..0ef0d31 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile
> @@ -1,4 +1,5 @@
>  btcoexist-objs :=	halbtc8723b2ant.o	\
> +			halbtc8192e2ant.o	\
>  			halbtcoutsrc.o		\
>  			rtl_btc.o

This is what I don't get, why is it needed?

-- 
Kalle Valo
