Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48955 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758203Ab0EUScm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 May 2010 14:32:42 -0400
Subject: Re: [PATCH] wireless: fix sta_info.h kernel-doc warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20100521112841.86d6757c.randy.dunlap@oracle.com>
References: <20100521112841.86d6757c.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 20:32:39 +0200
Message-ID: <1274466759.4446.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-05-21 at 11:28 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix sta_info.h kernel-doc warnings:
> 
> Warning(net/mac80211/sta_info.h:164): No description found for parameter 'tid_active_rx[STA_TID_NUM]'
> Warning(net/mac80211/sta_info.h:164): Excess struct/union/enum/typedef member 'tid_state_rx' description in 'sta_ampdu_mlme'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks, and apologies for breaking this again.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Cc: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/mac80211/sta_info.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.34-git6.orig/net/mac80211/sta_info.h
> +++ linux-2.6.34-git6/net/mac80211/sta_info.h
> @@ -145,7 +145,7 @@ enum plink_state {
>  /**
>   * struct sta_ampdu_mlme - STA aggregation information.
>   *
> - * @tid_state_rx: TID's state in Rx session state machine.
> + * @tid_active_rx: TID's state in Rx session state machine.
>   * @tid_rx: aggregation info for Rx per TID
>   * @tid_state_tx: TID's state in Tx session state machine.
>   * @tid_tx: aggregation info for Tx per TID
> 


