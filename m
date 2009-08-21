Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:40634 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528AbZHUVYm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 17:24:42 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Joerg Albert <jal2@gmx.de>
Subject: Re: [PATCH 2/2 v2] ar9170: remove unnecessary call to ar9170_set_beacon_timers
Date: Fri, 21 Aug 2009 23:24:03 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <4A8F0951.50108@gmx.de>
In-Reply-To: <4A8F0951.50108@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200908212324.03694.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 21 August 2009 22:53:37 Joerg Albert wrote:
> 
> Signed-off-by: Joerg Albert <jal2@gmx.de>
Acked-by: Christian Lamparter <chunkeey@web.de>

> ---
>  drivers/net/wireless/ath/ar9170/main.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
> index 911e502..5b73194 100644
> --- a/drivers/net/wireless/ath/ar9170/main.c
> +++ b/drivers/net/wireless/ath/ar9170/main.c
> @@ -2031,12 +2031,6 @@ static int ar9170_op_config(struct ieee80211_hw *hw, u32 changed)
>  			goto out;
>  	}
>  
> -	if (changed & BSS_CHANGED_BEACON_INT) {
> -		err = ar9170_set_beacon_timers(ar);
> -		if (err)
> -			goto out;
> -	}
> -
>  	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
>  
>  		/* adjust slot time for 5 GHz */
> 
