Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:46918 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081AbYBUTUE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 14:20:04 -0500
Message-ID: <47BDCC24.1050604@warmcat.com> (sfid-20080221_192017_613173_2CC20F44)
Date: Fri, 22 Feb 2008 03:08:20 +0800
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: allow specifying RTS/self-CTS protection when
 injecting packets
References: <1203553034.17534.119.camel@johannes.berg>
In-Reply-To: <1203553034.17534.119.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:
> I made this patch to test RTS/CTS operation in drivers, do you think
> it's useful apart that and should be merged?

> + * IEEE80211_RADIOTAP_TX_FLAGS
> +
> +   IEEE80211_RADIOTAP_F_TX_RTS:	use RTS/CTS handshake
> +   IEEE80211_RADIOTAP_F_TX_CTS:	use CTS-to-self protection
> +
> +
>  The injection code can also skip all other currently defined radiotap fields
>  facilitating replay of captured radiotap headers directly.

Hi Johannes -

Sure the footprint is nothing to speak of and it just exposes flags
there already supported using radiotap flags already existing.

I didn't think of a use for it but if the original flag has any use then
no doubt it can be used by the injection path by some enterprising soul.

(Sorry for late reply, travelling)

-Andy
