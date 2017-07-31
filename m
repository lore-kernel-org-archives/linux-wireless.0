Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34520 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751705AbdGaOSx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Jul 2017 10:18:53 -0400
Received: by mail-oi0-f66.google.com with SMTP id v11so24745154oif.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jul 2017 07:18:53 -0700 (PDT)
Subject: Re: [PATCH v4] rtlwifi: Replace hardcode value with macro
To: Souptick Joarder <jrdr.linux@gmail.com>, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20170731111445.GA4844@symbol-HP-ZBook-15>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <8af42486-dd0b-bda6-6125-148dc0011115@lwfinger.net> (sfid-20170731_161857_243143_EBB3B456)
Date: Mon, 31 Jul 2017 09:18:51 -0500
MIME-Version: 1.0
In-Reply-To: <20170731111445.GA4844@symbol-HP-ZBook-15>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/31/2017 06:14 AM, Souptick Joarder wrote:
> In _rtl_init_mac80211(), hardcoded value for hw->max_listen_interval
> and hw->max_rate_tries are replaced by macro.

That is NOT what your patch does. It only removes a comment! Granted, that 
comment is useless and should come out, but your commit message must be a little 
more accurate.

NACK.

Larry

> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/base.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
> index f45d093..52f2d0b 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/base.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/base.c
> @@ -422,7 +422,6 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
>   	hw->extra_tx_headroom = RTL_TX_HEADER_SIZE;
> 
>   	/* TODO: Correct this value for our hw */
> -	/* defined these hard code values */
>   	hw->max_listen_interval = MAX_LISTEN_INTERVAL;
>   	hw->max_rate_tries = MAX_RATE_TRIES;
>   	/* hw->max_rates = 1; */
> --
> 1.9.1
> 
> 
