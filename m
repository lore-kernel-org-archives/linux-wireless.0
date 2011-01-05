Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:48529 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab1AEQXZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 11:23:25 -0500
Received: by pxi15 with SMTP id 15so2776921pxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jan 2011 08:23:24 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19748.39650.518747.315217@gargle.gargle.HOWL>
Date: Wed, 5 Jan 2011 21:52:58 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sujith <m.sujith@gmail.com>, Jouni.Malinen@atheros.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] cfg80211: Add HT BSS attributes
In-Reply-To: <1294243398.3590.12.camel@jlt3.sipsolutions.net>
References: <19748.37551.23627.698571@gargle.gargle.HOWL>
	<1294243398.3590.12.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2011-01-05 at 21:17 +0530, Sujith wrote:
> 
> > @@ -227,6 +227,8 @@ enum ieee80211_bss_change {
> >   *	example.
> >   * @ht_operation_mode: HT operation mode (like in &struct ieee80211_ht_info).
> >   *	This field is only valid when the channel type is one of the HT types.
> > + * @ht_capab: HT capabilities (as in &struct ieee80211_ht_cap).
> > + * @ht_param: Operational HT parameters (as in &struct ieee80211_ht_info).
> >   * @cqm_rssi_thold: Connection quality monitor RSSI threshold, a zero value
> >   *	implies disabled
> >   * @cqm_rssi_hyst: Connection quality monitor RSSI hysteresis
> 
> Err, also, how are these expected to have any effect?

Will send a v2 ...

Sujith
