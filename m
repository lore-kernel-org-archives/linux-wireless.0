Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60161 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab0LPSv4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 13:51:56 -0500
Subject: Re: [PATCH 1/3 v2] mac80211: Rename mesh_params to mesh_config to
 prepare for mesh_setup
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <1292524200-14791-1-git-send-email-javier@cozybit.com>
References: <1292234643.3539.6.camel@jlt3.sipsolutions.net>
	 <1292524200-14791-1-git-send-email-javier@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 19:51:53 +0100
Message-ID: <1292525513.3612.26.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-16 at 10:29 -0800, Javier Cardona wrote:

> -	NL80211_CMD_GET_MESH_PARAMS,
> -	NL80211_CMD_SET_MESH_PARAMS,
> +	NL80211_CMD_GET_MESH_CONFIG,
> +	NL80211_CMD_SET_MESH_CONFIG,
>  
>  	NL80211_CMD_SET_MGMT_EXTRA_IE /* reserved; not used */,
>  
> @@ -912,7 +912,7 @@ enum nl80211_attrs {
>  	NL80211_ATTR_REG_ALPHA2,
>  	NL80211_ATTR_REG_RULES,
>  
> -	NL80211_ATTR_MESH_PARAMS,
> +	NL80211_ATTR_MESH_CONFIG,

ack, but I think you should add #define's for the old names for backward
compatibility with existing code like iw?
 
johannes

