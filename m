Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:35161 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752121AbdHBMKz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 08:10:55 -0400
Received: by mail-wm0-f49.google.com with SMTP id m85so39757793wma.0
        for <linux-wireless@vger.kernel.org>; Wed, 02 Aug 2017 05:10:55 -0700 (PDT)
Message-ID: <5981C14D.8030400@broadcom.com> (sfid-20170802_141059_646432_A39BA1AA)
Date: Wed, 02 Aug 2017 14:10:53 +0200
From: Arend van Spriel <arend.vanspriel@broadcom.com>
MIME-Version: 1.0
To: Souptick Joarder <jrdr.linux@gmail.com>
CC: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4] rtlwifi: Replace hardcode value with macro
References: <20170802115921.GA4381@symbol-HP-ZBook-15>
In-Reply-To: <20170802115921.GA4381@symbol-HP-ZBook-15>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/2/2017 1:59 PM, Souptick Joarder wrote:
> In _rtl_init_mac80211(), hardcoded value for hw->max_listen_interval
> and hw->max_rate_tries are replaced by macro and removed the comment.
>
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/base.c | 5 ++---
>   drivers/net/wireless/realtek/rtlwifi/base.h | 2 ++
>   2 files changed, 4 insertions(+), 3 deletions(-)

[...]

> diff --git a/drivers/net/wireless/realtek/rtlwifi/base.h b/drivers/net/wireless/realtek/rtlwifi/base.h
> index ab7d819..c591d75 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/base.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/base.h
> @@ -65,6 +65,8 @@ enum ap_peer {
>   #define FRAME_OFFSET_ADDRESS3		16
>   #define FRAME_OFFSET_SEQUENCE		22
>   #define FRAME_OFFSET_ADDRESS4		24
> +#define MAX_LISTEN_INTERVAL             10
> +#define MAX_RATE_TRIES                  4

It is not so nice to mix tabs and spaces like that. Better adhere to the 
existing convention.

Regards,
Arend
