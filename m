Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:41445 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbYHGOdR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 10:33:17 -0400
Date: Thu, 7 Aug 2008 17:32:32 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211/cfg80211: Add BSS configuration options for AP
	mode
Message-ID: <20080807143232.GD5138@jm.kir.nu> (sfid-20080807_163320_023894_2E6C3D96)
References: <20080807134043.GA5138@jm.kir.nu> <1218119110.23048.185.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1218119110.23048.185.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 07, 2008 at 04:25:10PM +0200, Johannes Berg wrote:

> > +	NL80211_ATTR_BSS_SHORT_SLOT_TIME,

> Oh another idea I just had, I suspect we should use these to indicate
> support for the features too, on the wiphy info query result or
> something. Only tangentially related to this patch though.

Sounds reasonable. So far, I've mainly worked with hardware that
supports these, so I have just assumed that everything is fine and
haven't bothered dynamically trying to decide what to do in hostapd. Or
well, it was possible to configure this in hostapd.conf (though, it
looks like that was never actually merged into the open source version
completely, so the variable is there, but not a way to enable it; have
to fix that at some point, I guess..).

-- 
Jouni Malinen                                            PGP id EFC895FA
