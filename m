Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33947 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbaEMTpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 15:45:09 -0400
Date: Tue, 13 May 2014 15:42:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] rsi: Changed the return value to enable BA set-up
Message-ID: <20140513194235.GH21204@tuxdriver.com> (sfid-20140513_214513_032148_D60943CF)
References: <53709FC4.3070700@redpinesignals.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53709FC4.3070700@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please format you patches so that they can be applied with 'patch -p1'...

I'll fix-up this one and merge it.

On Mon, May 12, 2014 at 03:47:40PM +0530, Jahnavi Meher wrote:
> From: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
> 
> Signed-off-by: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
> ---
> 
> rsi_91x_mac80211.c |    1 +
> 1 file changed, 1 insertion(+)
> 
> diff -uprN a/linux-3.15-rc5/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/linux-3.15-rc5/drivers/net/wireless/rsi/rsi_91x_mac80211.c
> --- a/linux-3.15-rc5/drivers/net/wireless/rsi/rsi_91x_mac80211.c	2014-05-10 01:40:52.000000000 +0530
> +++ b/linux-3.15-rc5/drivers/net/wireless/rsi/rsi_91x_mac80211.c	2014-05-12 15:15:42.272468987 +0530
> @@ -656,6 +656,7 @@ static int rsi_mac80211_ampdu_action(str
>  	case IEEE80211_AMPDU_TX_START:
>  		common->vif_info[ii].seq_start = seq_no;
>  		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
> +		status = 0;
>  		break;
>  
>  	case IEEE80211_AMPDU_TX_STOP_CONT:
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
