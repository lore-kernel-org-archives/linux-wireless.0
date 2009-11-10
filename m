Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbZKJGdr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 01:33:47 -0500
Subject: Re: [PATCH 1/2] Libertas: coding style cleanup in ethtool.c
From: Dan Williams <dcbw@redhat.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>
In-Reply-To: <1257818653-13460-1-git-send-email-bzhao@marvell.com>
References: <1257818653-13460-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain
Date: Mon, 09 Nov 2009 22:33:24 -0800
Message-Id: <1257834804.15493.35.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-11-09 at 18:04 -0800, Bing Zhao wrote:
> Signed-off-by: Bing Zhao <bzhao@marvell.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/ethtool.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
> index 039b555..6efa388 100644
> --- a/drivers/net/wireless/libertas/ethtool.c
> +++ b/drivers/net/wireless/libertas/ethtool.c
> @@ -175,10 +175,14 @@ static int lbs_ethtool_set_wol(struct net_device *dev,
>  	if (wol->wolopts & ~(WAKE_UCAST|WAKE_MCAST|WAKE_BCAST|WAKE_PHY))
>  		return -EOPNOTSUPP;
>  
> -	if (wol->wolopts & WAKE_UCAST) criteria |= EHS_WAKE_ON_UNICAST_DATA;
> -	if (wol->wolopts & WAKE_MCAST) criteria |= EHS_WAKE_ON_MULTICAST_DATA;
> -	if (wol->wolopts & WAKE_BCAST) criteria |= EHS_WAKE_ON_BROADCAST_DATA;
> -	if (wol->wolopts & WAKE_PHY)   criteria |= EHS_WAKE_ON_MAC_EVENT;
> +	if (wol->wolopts & WAKE_UCAST)
> +		criteria |= EHS_WAKE_ON_UNICAST_DATA;
> +	if (wol->wolopts & WAKE_MCAST)
> +		criteria |= EHS_WAKE_ON_MULTICAST_DATA;
> +	if (wol->wolopts & WAKE_BCAST)
> +		criteria |= EHS_WAKE_ON_BROADCAST_DATA;
> +	if (wol->wolopts & WAKE_PHY)
> +		criteria |= EHS_WAKE_ON_MAC_EVENT;
>  
>  	return lbs_host_sleep_cfg(priv, criteria, (struct wol_config *)NULL);
>  }

