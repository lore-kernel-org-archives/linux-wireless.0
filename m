Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34532 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751134AbeAVTHX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 14:07:23 -0500
Received: by mail-oi0-f65.google.com with SMTP id k15so4057466oib.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jan 2018 11:07:22 -0800 (PST)
Subject: Re: [PATCH 09/10] rtlwifi: Add ratr_table for newer IC
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180119064551.10084-1-pkshih@realtek.com>
 <20180119064551.10084-10-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <05cc9912-5de4-df7f-f587-693df2722a9e@lwfinger.net> (sfid-20180122_200726_722107_19126A1C)
Date: Mon, 22 Jan 2018 13:07:21 -0600
MIME-Version: 1.0
In-Reply-To: <20180119064551.10084-10-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/19/2018 12:45 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> New generation ICs will support 11ac, 5G, n-NSS, etc, so we define a set of
> rate ID.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/wifi.h | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> index 111f81b44c1b..2d8e96896f49 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> @@ -873,6 +873,24 @@ enum ratr_table_mode {
>   	RATR_INX_WIRELESS_AC_24N = 9,
>   };
>   
> +enum ratr_table_mode_new {
> +	RATEID_IDX_BGN_40M_2SS = 0,
> +	RATEID_IDX_BGN_40M_1SS = 1,
> +	RATEID_IDX_BGN_20M_2SS_BN = 2,
> +	RATEID_IDX_BGN_20M_1SS_BN = 3,
> +	RATEID_IDX_GN_N2SS = 4,
> +	RATEID_IDX_GN_N1SS = 5,
> +	RATEID_IDX_BG = 6,
> +	RATEID_IDX_G = 7,
> +	RATEID_IDX_B = 8,
> +	RATEID_IDX_VHT_2SS = 9,
> +	RATEID_IDX_VHT_1SS = 10,
> +	RATEID_IDX_MIX1 = 11,
> +	RATEID_IDX_MIX2 = 12,
> +	RATEID_IDX_VHT_3SS = 13,
> +	RATEID_IDX_BGN_3SS = 14,
> +};
> +
>   enum rtl_link_state {
>   	MAC80211_NOLINK = 0,
>   	MAC80211_LINKING = 1,
> 
