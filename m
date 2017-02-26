Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:34034 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750962AbdBZRGN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 26 Feb 2017 12:06:13 -0500
Subject: Re: [PATCH] rtlwifi: rtl8192de: ix spelling mistake: "althougth" ->
 "although"
To: Colin King <colin.king@canonical.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Oleg Drokin <green@linuxhacker.ru>,
        Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <20170226151923.24669-1-colin.king@canonical.com>
Cc: linux-kernel@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <8f5d0d3b-b4ef-d9f4-50fa-e461760912fa@lwfinger.net> (sfid-20170226_180646_148306_4969F1EA)
Date: Sun, 26 Feb 2017 10:57:56 -0600
MIME-Version: 1.0
In-Reply-To: <20170226151923.24669-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/26/2017 09:19 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> trivial fix to spelling mistake in RT_TRACE message
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Bad fix. It should be althougth => through. Please read the context.

NACK.

Larry

> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
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
> +			 " ===> although Path A, we load radiob.txt\n");
>  		radioa_arraylen = radiob_arraylen;
>  		radioa_array_table = radiob_array_table;
>  	}
>
