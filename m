Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:33069 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbYKZHwV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 02:52:21 -0500
Date: Wed, 26 Nov 2008 09:52:09 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] nl80211: Add frequency configuration (including HT40)
Message-ID: <20081126075209.GA31499@jm.kir.nu> (sfid-20081126_085225_984279_51E917A0)
References: <20081125190533.GA27879@jm.kir.nu> <1227640384.4613.44.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1227640384.4613.44.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 25, 2008 at 08:13:04PM +0100, Johannes Berg wrote:
 
> Isn't that missing regulatory enforcement? I'd rather see that in
> cfg80211 than re-implemented in all drivers.

Yes, that was supposed to be in ieee80211_get_channel() to match
ieee80211_set_freq() functionality, but I'll see how this could be done
in nl80211.c.

-- 
Jouni Malinen                                            PGP id EFC895FA
