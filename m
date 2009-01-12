Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60842 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbZALM6r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 07:58:47 -0500
Subject: Re: [PATCH] nl80211: Fix documentation errors
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090112122440.GA9153@jm.kir.nu>
References: <20090112122440.GA9153@jm.kir.nu>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 13:58:18 +0100
Message-Id: <1231765098.2998.0.camel@home.berg> (sfid-20090112_135851_901292_7FE0F11D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-01-12 at 14:24 +0200, Jouni Malinen wrote:
> Couple of '_ATTR's were missing and SEC_CHAN_OFFSET to CHANNEL_TYPE
> rename was missed in couple of places.

Good find, thanks.

> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> 
> ---
>  include/linux/nl80211.h |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- wireless-testing.orig/include/linux/nl80211.h	2009-01-12 13:12:49.000000000 +0200
> +++ wireless-testing/include/linux/nl80211.h	2009-01-12 13:14:19.000000000 +0200
> @@ -47,7 +47,7 @@
>   * @NL80211_CMD_SET_WIPHY: set wiphy parameters, needs %NL80211_ATTR_WIPHY or
>   *	%NL80211_ATTR_IFINDEX; can be used to set %NL80211_ATTR_WIPHY_NAME,
>   *	%NL80211_ATTR_WIPHY_TXQ_PARAMS, %NL80211_ATTR_WIPHY_FREQ, and/or
> - *	%NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET.
> + *	%NL80211_ATTR_WIPHY_CHANNEL_TYPE.
>   * @NL80211_CMD_NEW_WIPHY: Newly created wiphy, response to get request
>   *	or rename notification. Has attributes %NL80211_ATTR_WIPHY and
>   *	%NL80211_ATTR_WIPHY_NAME.
> @@ -84,7 +84,7 @@
>   *	%NL80222_CMD_NEW_BEACON message)
>   * @NL80211_CMD_SET_BEACON: set the beacon on an access point interface
>   *	using the %NL80211_ATTR_BEACON_INTERVAL, %NL80211_ATTR_DTIM_PERIOD,
> - *	%NL80211_BEACON_HEAD and %NL80211_BEACON_TAIL attributes.
> + *	%NL80211_ATTR_BEACON_HEAD and %NL80211_ATTR_BEACON_TAIL attributes.
>   * @NL80211_CMD_NEW_BEACON: add a new beacon to an access point interface,
>   *	parameters are like for %NL80211_CMD_SET_BEACON.
>   * @NL80211_CMD_DEL_BEACON: remove the beacon, stop sending it
> @@ -362,7 +362,7 @@ enum nl80211_attrs {
>  #define NL80211_ATTR_BSS_BASIC_RATES NL80211_ATTR_BSS_BASIC_RATES
>  #define NL80211_ATTR_WIPHY_TXQ_PARAMS NL80211_ATTR_WIPHY_TXQ_PARAMS
>  #define NL80211_ATTR_WIPHY_FREQ NL80211_ATTR_WIPHY_FREQ
> -#define NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET
> +#define NL80211_ATTR_WIPHY_CHANNEL_TYPE NL80211_ATTR_WIPHY_CHANNEL_TYPE
>  
>  #define NL80211_MAX_SUPP_RATES			32
>  #define NL80211_MAX_SUPP_REG_RULES		32
> 

