Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38418 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab0KLQn3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 11:43:29 -0500
Subject: Re: [2.6.37 PATCH] cfg80211: fix WIPHY_FLAG_IBSS_RSN bit
From: Johannes Berg <johannes@sipsolutions.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20101112065356.3307.26298.stgit@fate.lan>
References: <20101112065356.3307.26298.stgit@fate.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 08:44:40 -0800
Message-ID: <1289580280.3736.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-11-12 at 08:53 +0200, Jussi Kivilinna wrote:
> WIPHY_FLAG_IBSS_RSN is BIT(7) as is WIPHY_FLAG_CONTROL_PORT_PROTOCOL. Change
> to BIT(8).

Thanks Jussi!

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> ---
>  include/net/cfg80211.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 2a7936d..97b8b7c 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1355,7 +1355,7 @@ enum wiphy_flags {
>  	WIPHY_FLAG_4ADDR_AP			= BIT(5),
>  	WIPHY_FLAG_4ADDR_STATION		= BIT(6),
>  	WIPHY_FLAG_CONTROL_PORT_PROTOCOL	= BIT(7),
> -	WIPHY_FLAG_IBSS_RSN			= BIT(7),
> +	WIPHY_FLAG_IBSS_RSN			= BIT(8),
>  };
>  
>  struct mac_address {
> 
> 


