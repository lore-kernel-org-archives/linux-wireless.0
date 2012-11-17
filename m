Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56491 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2KQJ3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 04:29:36 -0500
Message-ID: <1353144610.9543.32.camel@jlt4.sipsolutions.net> (sfid-20121117_102940_323485_63788E0D)
Subject: Re: [RFC 12/14] mac80211: add awake window IE to mesh beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>
Date: Sat, 17 Nov 2012 10:30:10 +0100
In-Reply-To: <1353134886-13256-13-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353134886-13256-13-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-16 at 22:48 -0800, Marco Porsch wrote:
> The awake window value is announced in an IE in beacons if the local STA
> is in light or deep sleep mode towards any peer or non-peer.

> +++ b/net/mac80211/ieee80211_i.h
> @@ -1204,6 +1204,7 @@ struct ieee802_11_elems {
>  	struct ieee80211_meshconf_ie *mesh_config;
>  	u8 *mesh_id;
>  	u8 *peering;
> +	u8 *awake_window;

You don't need to be able to parse it to add it?

johannes

