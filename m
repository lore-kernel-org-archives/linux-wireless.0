Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:34201 "EHLO
	mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbcERJDA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2016 05:03:00 -0400
Received: by mail-pf0-f178.google.com with SMTP id y69so16485041pfb.1
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2016 02:03:00 -0700 (PDT)
Subject: Re: [PATCH 1/1] brcm80211: simplify assignment
To: Heinrich Schuchardt <xypron.glpk@gmx.de>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>
References: <1463533033-13336-1-git-send-email-xypron.glpk@gmx.de>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <573C2FBB.2010809@broadcom.com> (sfid-20160518_110331_102482_8ED9E138)
Date: Wed, 18 May 2016 11:02:51 +0200
MIME-Version: 1.0
In-Reply-To: <1463533033-13336-1-git-send-email-xypron.glpk@gmx.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18-5-2016 2:57, Heinrich Schuchardt wrote:
> Simplify assignment in wlc_phy_rxcal_gainctrl_nphy_rev5.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
> index 99dac9b..b3aab2f 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
> @@ -27017,7 +27017,7 @@ wlc_phy_rxcal_gainctrl_nphy_rev5(struct brcms_phy *pi, u8 rx_core,
>  		tx_core = 1 - rx_core;
>  
>  	num_samps = 1024;
> -	desired_log2_pwr = (cal_type == 0) ? 13 : 13;
> +	desired_log2_pwr = 13;
>  
>  	wlc_phy_rx_iq_coeffs_nphy(pi, 0, &save_comp);
>  	zero_comp.a0 = zero_comp.b0 = zero_comp.a1 = zero_comp.b1 = 0x0;
> 
