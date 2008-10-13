Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:47588 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759072AbYJMSMt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 14:12:49 -0400
Date: Mon, 13 Oct 2008 21:11:56 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>, Felix Fietkau <nbd@openwrt.org>
Subject: Re: [RFC] mac80211: fix short preamble determination
Message-ID: <20081013181156.GC30095@jm.kir.nu> (sfid-20081013_201326_756279_D5F77C40)
References: <1223713593.29811.38.camel@johannes.berg> <20081013155938.GA30095@jm.kir.nu> <1223919110.10113.1.camel@johannes.berg> <20081013175457.GB30095@jm.kir.nu> <1223921012.10113.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1223921012.10113.5.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 13, 2008 at 08:03:32PM +0200, Johannes Berg wrote:
> > Well, if you have many such devices, yes, but one might try to live
> > without such protection if there are some with very limited transmit
> > needs.
> 
> Would you then announce short preamble as the AP? That'd mean all other
> stations would use short preamble and the poor non-short-preamble STA
> would be left completely in the dark wrt. its NAV.

Yes, indeed. In other words, this would be something that could work
mostly in cases where there is a STA with very limited needs (e.g., send
measurement results once an hour, etc.). I'm not aware of any such
deployment, though.

> Ohh. Just a few days ago I sent an email with a request for
> interpretation (there really just is a typo in 802.11-2007 but...) That
> got forwarded around a lot, but I guess at least TGmb will see it :)

Yeah.. I'm sure it will show up in TGmb in Dallas meeting (mid-Nov). It
might even get fixed eventually the 802.11-2010 (or 2011, or 2012, or
who knows when.. ;-).

-- 
Jouni Malinen                                            PGP id EFC895FA
