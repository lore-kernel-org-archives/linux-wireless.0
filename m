Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:36661 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756471AbeASWrZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 17:47:25 -0500
Received: by mail-ot0-f196.google.com with SMTP id f100so2744213otf.3
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jan 2018 14:47:24 -0800 (PST)
Subject: Re: [PATCH 06/10] rtlwifi: btcoex: add boolean variables dbg_mode
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180119064551.10084-1-pkshih@realtek.com>
 <20180119064551.10084-7-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <00635761-f730-f9e8-10b9-d2437738064d@lwfinger.net> (sfid-20180119_234728_310206_94303F66)
Date: Fri, 19 Jan 2018 16:47:23 -0600
MIME-Version: 1.0
In-Reply-To: <20180119064551.10084-7-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/19/2018 12:45 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> In files halbtc8822b1ant.c and halbtc8822b2ant.c that I will submit later,
> two undesired directives named BT_8822B_1ANT_COEX_DBG and
> BT_8822B_2ANT_COEX_DBG will be replaced by boolean variables.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> index 6c145313c615..1c6019be793a 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> @@ -583,6 +583,8 @@ struct btc_coexist {
>   	 */
>   	bool auto_report_1ant;
>   	bool auto_report_2ant;
> +	bool dbg_mode_1ant;
> +	bool dbg_mode_2ant;
>   	bool initilized;
>   	bool stop_coex_dm;
>   	bool manual_control;

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
