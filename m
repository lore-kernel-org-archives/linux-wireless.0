Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42469 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbaJ3Hh3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 03:37:29 -0400
Message-ID: <1414654645.1823.0.camel@jlt4.sipsolutions.net> (sfid-20141030_083732_274928_6C06326E)
Subject: Re: [PATCH net-next] mac80211: fix spelling errors
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 30 Oct 2014 08:37:25 +0100
In-Reply-To: <20141029225558.1422bc2f@urahara> (sfid-20141030_065609_890618_2EAB83A5)
References: <20141029225558.1422bc2f@urahara>
	 (sfid-20141030_065609_890618_2EAB83A5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-10-29 at 22:55 -0700, Stephen Hemminger wrote:
> Use codespell to find spelling errors.

Thanks Stephen.

> --- a/net/mac802154/ieee802154_dev.c	2014-07-25 11:02:43.895028221 -0700
> +++ b/net/mac802154/ieee802154_dev.c	2014-10-27 20:40:26.471487715 -0700
> @@ -267,7 +267,7 @@ ieee802154_alloc_device(size_t priv_data
>  	 * +-----------------------+
>  	 *
>  	 * Due to ieee802154 layer isn't aware of driver and MAC structures,
> -	 * so lets allign them here.
> +	 * so lets align them here.
>  	 */
>  
>  	priv_size = ALIGN(sizeof(*priv), NETDEV_ALIGN) + priv_data_len;

I'll take the rest, but can you resend this bit to the right 802.15.4
folks?

Thanks,
johannes

