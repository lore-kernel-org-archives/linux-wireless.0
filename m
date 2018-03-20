Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:37420 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750968AbeCTEGY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 00:06:24 -0400
Received: by mail-ot0-f194.google.com with SMTP id t2-v6so303308otj.4
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2018 21:06:24 -0700 (PDT)
Subject: Re: [PATCH v2 14/15] rtlwifi: btcoex: Add 8822b to Makefile
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180306012554.3108-1-pkshih@realtek.com>
 <20180306012554.3108-15-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <5eb83b35-31c2-3298-4c7a-d04caea04222@lwfinger.net> (sfid-20180320_050630_784168_1ECFEE45)
Date: Mon, 19 Mar 2018 23:04:12 -0500
MIME-Version: 1.0
In-Reply-To: <20180306012554.3108-15-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/05/2018 07:25 PM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Add btcoex of 8822b to Makefile.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

> ---
>   drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile b/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile
> index d15c58737388..37108c379bd0 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile
> @@ -4,6 +4,9 @@ btcoexist-objs :=	halbtc8192e2ant.o	\
>   			halbtc8723b2ant.o	\
>   			halbtc8821a1ant.o	\
>   			halbtc8821a2ant.o	\
> +			halbtc8822b1ant.o	\
> +			halbtc8822b2ant.o	\
> +			halbtc8822bwifionly.o	\
>   			halbtcoutsrc.o		\
>   			rtl_btc.o
>   
> 
