Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54585 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1AEQDT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 11:03:19 -0500
Subject: Re: [RFC] cfg80211: Add HT BSS attributes
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: Jouni.Malinen@atheros.com,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <19748.37551.23627.698571@gargle.gargle.HOWL>
References: <19748.37551.23627.698571@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Jan 2011 17:03:18 +0100
Message-ID: <1294243398.3590.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-05 at 21:17 +0530, Sujith wrote:

> @@ -227,6 +227,8 @@ enum ieee80211_bss_change {
>   *	example.
>   * @ht_operation_mode: HT operation mode (like in &struct ieee80211_ht_info).
>   *	This field is only valid when the channel type is one of the HT types.
> + * @ht_capab: HT capabilities (as in &struct ieee80211_ht_cap).
> + * @ht_param: Operational HT parameters (as in &struct ieee80211_ht_info).
>   * @cqm_rssi_thold: Connection quality monitor RSSI threshold, a zero value
>   *	implies disabled
>   * @cqm_rssi_hyst: Connection quality monitor RSSI hysteresis

Err, also, how are these expected to have any effect?

johannes

