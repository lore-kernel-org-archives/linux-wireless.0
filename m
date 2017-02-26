Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:34267 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbdBZTDc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 26 Feb 2017 14:03:32 -0500
Subject: Re: [PATCH][V2] rtlwifi: rtl8192de: ix spelling mistake: "althougth"
 -> "though"
To: Colin King <colin.king@canonical.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Oleg Drokin <green@linuxhacker.ru>,
        Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <20170226185246.28808-1-colin.king@canonical.com>
Cc: linux-kernel@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <9ddfcfdc-42c6-e302-e12b-1f9660f20ad4@lwfinger.net> (sfid-20170226_200344_141614_775822C2)
Date: Sun, 26 Feb 2017 13:01:31 -0600
MIME-Version: 1.0
In-Reply-To: <20170226185246.28808-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/26/2017 12:52 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> trivial fix to spelling mistake in RT_TRACE message
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> index de98d88..dcb5d83 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> @@ -812,7 +812,7 @@ bool rtl92d_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
>  	 * pathA or mac1 has to set phy0&phy1 pathA */
>  	if ((content == radiob_txt) && (rfpath == RF90_PATH_A)) {
>  		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
> -			 " ===> althougth Path A, we load radiob.txt\n");
> +			 " ===> though Path A, we load radiob.txt\n");
>  		radioa_arraylen = radiob_arraylen;
>  		radioa_array_table = radiob_array_table;
>  	}
>
