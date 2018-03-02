Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:44469 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932246AbeCBWM6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 17:12:58 -0500
Received: by mail-oi0-f65.google.com with SMTP id b8so8124989oib.11
        for <linux-wireless@vger.kernel.org>; Fri, 02 Mar 2018 14:12:57 -0800 (PST)
Subject: Re: [PATCH 04/15] rtlwifi: btcoex: Add customer_id to do special deal
 to oem vendor
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180228030718.19510-1-pkshih@realtek.com>
 <20180228030718.19510-5-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <8bc3c805-7e12-c8d1-9843-f9505926d8de@lwfinger.net> (sfid-20180302_231311_546695_69CDEE80)
Date: Fri, 2 Mar 2018 16:12:56 -0600
MIME-Version: 1.0
In-Reply-To: <20180228030718.19510-5-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/27/2018 09:07 PM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Add customer_id field in structure, and then this is a clue to implement
> the behavior defined by vendor LENOVO_CHINA.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

> ---
>   drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h | 1 +
>   drivers/net/wireless/realtek/rtlwifi/wifi.h                   | 1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> index f5d8159a88eb..3c6a1e8851ec 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> @@ -154,6 +154,7 @@ struct btc_board_info {
>   
>   	u8 rfe_type;
>   	u8 ant_div_cfg;
> +	u8 customer_id;
>   };
>   
>   enum btc_dbg_opcode {
> diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> index 438678c2d14a..d27e33960e77 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> @@ -556,6 +556,7 @@ enum rt_oem_id {
>   	RT_CID_NETGEAR = 36,
>   	RT_CID_PLANEX = 37,
>   	RT_CID_CC_C = 38,
> +	RT_CID_LENOVO_CHINA = 40,
>   };
>   
>   enum hw_descs {
> 
