Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54718 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab1JKRig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 13:38:36 -0400
Subject: Re: Re: [PATCH 1/2] mac80211: Build TX radiotap header dynamically
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <3634905.slyix8Dz5L@helmutmobil.site> (sfid-20111011_192130_182380_1BC4FD20)
References: <1318349335-22514-1-git-send-email-helmut.schaa@googlemail.com>
	 <1318350345.3965.11.camel@jlt3.sipsolutions.net>
	 <3634905.slyix8Dz5L@helmutmobil.site>
	 (sfid-20111011_192130_182380_1BC4FD20)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 19:38:33 +0200
Message-ID: <1318354713.3965.14.camel@jlt3.sipsolutions.net> (sfid-20111011_193839_939772_96FCEF88)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-10-11 at 19:19 +0200, Helmut Schaa wrote:
> Am Dienstag, 11. Oktober 2011, 18:25:45 schrieb Johannes Berg:
> > On Tue, 2011-10-11 at 18:08 +0200, Helmut Schaa wrote:
> > Since there's no over-all memset I think you need to clear the padding
> > explicitly now.
> 
> Like this one? :)
> 
> > +	rthdr = (struct ieee80211_radiotap_header *) skb_push(skb, rtap_len);
> > +
> > +	memset(rthdr, 0, rtap_len);

Oh, oops, sorry!

Looks good to me then.

johannes

