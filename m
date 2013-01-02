Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:38243 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3ABOwI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:52:08 -0500
Received: by mail-pb0-f49.google.com with SMTP id un15so7871537pbc.22
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jan 2013 06:52:08 -0800 (PST)
Message-ID: <50E447CC.8060509@lwfinger.net> (sfid-20130102_155213_834664_D4EA9464)
Date: Wed, 02 Jan 2013 08:44:28 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Julian Wollrath <jwollrath@web.de>
CC: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] Fix typo in debug output of rtl8192c and rtl8723ae
References: <1357136516-8841-1-git-send-email-jwollrath@web.de>
In-Reply-To: <1357136516-8841-1-git-send-email-jwollrath@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/02/2013 08:21 AM, Julian Wollrath wrote:
> Signed-off-by: Julian Wollrath <jwollrath@web.de>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c |    2 +-
>   drivers/net/wireless/rtlwifi/rtl8723ae/phy.c       |    2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)

Acked-by: Larry Finger <Larry.finger@lwfinger.net>

Julian - Just a heads-up for future reference. All patches for drivers in the 
drivers/net/wireless tree should be sent to John Linville (Cc'd here), with Cc 
to the module maintainer, and the linux-wireless list. Obviously, I read 
linux-wireless so that I saw this, but John might have a filter that only 
extracts the stuff sent directly to him.

Larry

>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
> index 1d5d360..246e535 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
> @@ -692,7 +692,7 @@ u8 rtl92c_phy_sw_chnl(struct ieee80211_hw *hw)
>   	if (!(is_hal_stop(rtlhal)) && !(RT_CANNOT_IO(hw))) {
>   		rtl92c_phy_sw_chnl_callback(hw);
>   		RT_TRACE(rtlpriv, COMP_CHAN, DBG_LOUD,
> -			 "sw_chnl_inprogress false schdule workitem\n");
> +			 "sw_chnl_inprogress false schedule workitem\n");
>   		rtlphy->sw_chnl_inprogress = false;
>   	} else {
>   		RT_TRACE(rtlpriv, COMP_CHAN, DBG_LOUD,
> diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/phy.c b/drivers/net/wireless/rtlwifi/rtl8723ae/phy.c
> index 39cc793..3d8536b 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8723ae/phy.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8723ae/phy.c
> @@ -1106,7 +1106,7 @@ u8 rtl8723ae_phy_sw_chnl(struct ieee80211_hw *hw)
>   	if (!(is_hal_stop(rtlhal)) && !(RT_CANNOT_IO(hw))) {
>   		rtl8723ae_phy_sw_chnl_callback(hw);
>   		RT_TRACE(rtlpriv, COMP_CHAN, DBG_LOUD,
> -			 "sw_chnl_inprogress false schdule workitem\n");
> +			 "sw_chnl_inprogress false schedule workitem\n");
>   		rtlphy->sw_chnl_inprogress = false;
>   	} else {
>   		RT_TRACE(rtlpriv, COMP_CHAN, DBG_LOUD,
>

