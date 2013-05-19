Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59212 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806Ab3ESWyi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 May 2013 18:54:38 -0400
Message-ID: <5199581F.4090506@hauke-m.de> (sfid-20130520_005451_918486_2179E27F)
Date: Mon, 20 May 2013 00:54:23 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: mcgrof@kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] backports: defconfig for rtlwifi family
References: <1368981836-6247-1-git-send-email-Larry.Finger@lwfinger.net> <1368981836-6247-2-git-send-email-Larry.Finger@lwfinger.net>
In-Reply-To: <1368981836-6247-2-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/19/2013 06:43 PM, Larry Finger wrote:
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> V2 in proper format for git repo
> 
> Larry
> 
>  backport/defconfigs/rtlwifi | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>  create mode 100644 backport/defconfigs/rtlwifi
> 
> diff --git a/backport/defconfigs/rtlwifi b/backport/defconfigs/rtlwifi
> new file mode 100644
> index 0000000..c86d000
> --- /dev/null
> +++ b/backport/defconfigs/rtlwifi
> @@ -0,0 +1,19 @@
> +CPTCFG_CFG80211=m
> +CPTCFG_CFG80211_DEFAULT_PS=y
> +CPTCFG_CFG80211_DEBUGFS=y
> +CPTCFG_MAC80211=m
> +# CPTCFG_MAC80211_RC_PID is not set
> +# CPTCFG_MAC80211_RC_MINSTREL is not set
> +# CPTCFG_MAC80211_RC_DEFAULT_MINSTREL is not set

This results in no rate control mechanism being selected is that intended?

MAC80211_MESH and MAC80211_LEDS are also not selected.

> +CPTCFG_MAC80211_DEBUGFS=y
> +CPTCFG_MAC80211_MESSAGE_TRACING=y
> +CPTCFG_WLAN=y
> +CPTCFG_RTLWIFI=m
> +CPTCFG_RTLWIFI_DEBUG=y
> +CPTCFG_RTL8192CE=m
> +CPTCFG_RTL8192SE=m
> +CPTCFG_RTL8192DE=m
> +CPTCFG_RTL8723AE=m
> +CPTCFG_RTL8188EE=m
> +CPTCFG_RTL8192CU=m
> +CPTCFG_RTL8192C_COMMON=m
> 

