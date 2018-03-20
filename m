Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:47086 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751069AbeCTED4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 00:03:56 -0400
Received: by mail-ot0-f196.google.com with SMTP id g97-v6so281482otg.13
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2018 21:03:55 -0700 (PDT)
Subject: Re: [PATCH v2 13/15] rtlwifi: btcoex: Add 8822b header files to
 precomp.h
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180306012554.3108-1-pkshih@realtek.com>
 <20180306012554.3108-14-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <7f6711cf-5779-cd30-8da2-d92be666aead@lwfinger.net> (sfid-20180320_050400_040474_BC6F44CF)
Date: Mon, 19 Mar 2018 23:03:54 -0500
MIME-Version: 1.0
In-Reply-To: <20180306012554.3108-14-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/05/2018 07:25 PM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Add 8822b header files to precomp.h for routing functions.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

> ---
>   drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
> index 02dff4c3f664..858318fd3d63 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
> @@ -48,6 +48,9 @@
>   #include "halbtc8723b2ant.h"
>   #include "halbtc8821a2ant.h"
>   #include "halbtc8821a1ant.h"
> +#include "halbtc8822b1ant.h"
> +#include "halbtc8822b2ant.h"
> +#include "halbtc8822bwifionly.h"
>   
>   #define GetDefaultAdapter(padapter)	padapter
>   
> 
