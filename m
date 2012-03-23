Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57835 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab2CWIhv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 04:37:51 -0400
Message-ID: <1332491869.3506.2.camel@jlt3.sipsolutions.net> (sfid-20120323_093819_460625_105A7EF9)
Subject: Re: [RFC 04/12] mac80211: prepare ieee80211_get_tx_channel_type to
 per-vif
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Mar 2012 09:37:49 +0100
In-Reply-To: <fee1d9db-75c7-4e26-a463-e5d436a24cc2@FIVLA-EXHUB02.eu.tieto.com> (sfid-20120320_155525_168969_C5FBFFE9)
References: <fee1d9db-75c7-4e26-a463-e5d436a24cc2@FIVLA-EXHUB02.eu.tieto.com>
	 (sfid-20120320_155525_168969_C5FBFFE9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>  enum nl80211_channel_type ieee80211_get_tx_channel_type(
> -				struct ieee80211_local *local,
> +				struct ieee80211_sub_if_data *sdata,
>  				enum nl80211_channel_type channel_type)

I have pending patches to delete this :)

johannes

