Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44203 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab3ABMuq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 07:50:46 -0500
Message-ID: <1357131065.9839.14.camel@jlt4.sipsolutions.net> (sfid-20130102_135054_171357_BC2A7083)
Subject: Re: [PATCH 2/4] mac80211_hwsim: hrtimer beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linville@tuxdriver.org, j@w1.fi, linux-wireless@vger.kernel.org
Date: Wed, 02 Jan 2013 13:51:05 +0100
In-Reply-To: <1356644636-5309-2-git-send-email-thomas@cozybit.com> (sfid-20121227_224433_986529_CA28BCC4)
References: <1356644636-5309-1-git-send-email-thomas@cozybit.com>
	 <1356644636-5309-2-git-send-email-thomas@cozybit.com>
	 (sfid-20121227_224433_986529_CA28BCC4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-27 at 13:43 -0800, Thomas Pedersen wrote:

>  	ieee80211_iterate_active_interfaces_atomic(
>  		hw, IEEE80211_IFACE_ITER_NORMAL,
> -		mac80211_hwsim_beacon_tx, hw);
> +		mac80211_hwsim_beacon_tx, data);

This change belongs to another patch, please respin cleanly.

johannes

