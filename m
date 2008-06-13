Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:45876 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281AbYFMO7t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 10:59:49 -0400
Date: Fri, 13 Jun 2008 17:59:04 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211_hwsim: 802.11 radio simulator for mac80211
Message-ID: <20080613145904.GL4919@jm.kir.nu> (sfid-20080613_165951_939288_D010FBF0)
References: <20080611074230.GA4919@jm.kir.nu> <1213356074.3860.26.camel@johannes.berg> <20080613142658.GI4919@jm.kir.nu> <1213368198.3860.36.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1213368198.3860.36.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 13, 2008 at 04:43:18PM +0200, Johannes Berg wrote:

> Well mostly the channel stuff, basic rate sets, rts/cts, short slot and
> stuff like that. See
> http://wireless.kernel.org/en/developers/todo-list#APsupport

OK, thanks.

> Heh. Well I didn't look too closely so if this isn't easy to do I guess
> you shouldn't bother, it just seemed to be very similar to me on first
> sight.

It turned out to be trivial in the current version. I think there was
something else in an earlier version when I last looked at cleaning this
up, but anyway, I now have a patch to use a shared function.

-- 
Jouni Malinen                                            PGP id EFC895FA
