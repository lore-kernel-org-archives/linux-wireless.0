Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:34188 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407AbbFEPdX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2015 11:33:23 -0400
Received: by oies66 with SMTP id s66so5159771oie.1
        for <linux-wireless@vger.kernel.org>; Fri, 05 Jun 2015 08:33:23 -0700 (PDT)
Message-ID: <5571C140.6000504@lwfinger.net> (sfid-20150605_173327_263638_68F425C9)
Date: Fri, 05 Jun 2015 10:33:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Taehee Yoo <ap420073@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] rtlwifi: rtl8192cu: debug message change "RTL8192CE"
 to "RTL8192CU"
References: <1433512898-30137-1-git-send-email-ap420073@gmail.com> <1433512898-30137-2-git-send-email-ap420073@gmail.com>
In-Reply-To: <1433512898-30137-2-git-send-email-ap420073@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2015 09:01 AM, Taehee Yoo wrote:
> In the rtlwifi/rtl8192cu, I change debug message "RTL8192CE" to
> "RTL8192CU".
>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192cu/phy.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)

I am not sure that anyone ever uses this level of debug, but the changes are OK.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
> index 12f6d47..5534dad 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
> @@ -162,7 +162,7 @@ bool _rtl92cu_phy_config_mac_with_headerfile(struct ieee80211_hw *hw)
>   	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, "Read Rtl819XMACPHY_Array\n");
>   	arraylength =  rtlphy->hwparam_tables[MAC_REG].length ;
>   	ptrarray = rtlphy->hwparam_tables[MAC_REG].pdata;
> -	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, "Img:RTL8192CEMAC_2T_ARRAY\n");
> +	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, "Img:RTL8192CUMAC_2T_ARRAY\n");
>   	for (i = 0; i < arraylength; i = i + 2)
>   		rtl_write_byte(rtlpriv, ptrarray[i], (u8) ptrarray[i + 1]);
>   	return true;
> @@ -259,18 +259,18 @@ bool rtl92cu_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
>   		radiob_arraylen = rtlphy->hwparam_tables[RADIOB_2T].length;
>   		radiob_array_table = rtlphy->hwparam_tables[RADIOB_2T].pdata;
>   		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
> -			 "Radio_A:RTL8192CERADIOA_2TARRAY\n");
> +			 "Radio_A:RTL8192CURADIOA_2TARRAY\n");
>   		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
> -			 "Radio_B:RTL8192CE_RADIOB_2TARRAY\n");
> +			 "Radio_B:RTL8192CU_RADIOB_2TARRAY\n");
>   	} else {
>   		radioa_arraylen = rtlphy->hwparam_tables[RADIOA_1T].length;
>   		radioa_array_table = rtlphy->hwparam_tables[RADIOA_1T].pdata;
>   		radiob_arraylen = rtlphy->hwparam_tables[RADIOB_1T].length;
>   		radiob_array_table = rtlphy->hwparam_tables[RADIOB_1T].pdata;
>   		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
> -			 "Radio_A:RTL8192CE_RADIOA_1TARRAY\n");
> +			 "Radio_A:RTL8192CU_RADIOA_1TARRAY\n");
>   		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
> -			 "Radio_B:RTL8192CE_RADIOB_1TARRAY\n");
> +			 "Radio_B:RTL8192CU_RADIOB_1TARRAY\n");
>   	}
>   	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, "Radio No %x\n", rfpath);
>   	switch (rfpath) {
>

