Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55173 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932741AbcFGNca (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2016 09:32:30 -0400
Subject: Re: [PATCH 5/6] ath9k: Use defined constants consistently.
To: Benjamin Berg <benjamin@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1465305001-26067-1-git-send-email-benjamin@sipsolutions.net>
 <1465305001-26067-5-git-send-email-benjamin@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, ath9k-devel@lists.ath9k.org,
	Benjamin Berg <benjamin.berg@open-mesh.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <78e285a7-19bb-dcfe-9319-0b0ef41aebcc@nbd.name> (sfid-20160607_153235_239689_E7A60EDE)
Date: Tue, 7 Jun 2016 15:32:18 +0200
MIME-Version: 1.0
In-Reply-To: <1465305001-26067-5-git-send-email-benjamin@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-06-07 15:10, Benjamin Berg wrote:
> From: Benjamin Berg <benjamin.berg@open-mesh.com>
> 
> Signed-off-by: Benjamin Berg <benjamin.berg@open-mesh.com>
> ---
>  drivers/net/wireless/ath/ath9k/main.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index f2ebc85..6a81298 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -1785,9 +1785,10 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
>  	if ((avp->chanctx == sc->cur_chan) &&
>  	    (changed & BSS_CHANGED_ERP_SLOT)) {
>  		if (bss_conf->use_short_slot)
> -			slottime = 9;
> +			slottime = ATH9K_SLOT_TIME_9;
>  		else
> -			slottime = 20;
> +			slottime = ATH9K_SLOT_TIME_20;
Wouldn't it be better to just remove those pointless defines?

- Felix

