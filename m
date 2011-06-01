Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55305 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758823Ab1FAM0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 08:26:35 -0400
Subject: Re: [PATCH 2/3] mac80211: create a STA entry for a WDS interface
 after receiving a beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <4DE6256B.80106@openwrt.org>
References: <1306869394-83047-1-git-send-email-nbd@openwrt.org>
	 <1306869394-83047-2-git-send-email-nbd@openwrt.org>
	 <1306870354.29989.1.camel@jlt3.sipsolutions.net>
	 <4DE543E2.9070600@openwrt.org>
	 <1306872395.29989.3.camel@jlt3.sipsolutions.net>
	 <4DE54E16.7000709@openwrt.org>
	 <1306901843.3867.2.camel@jlt3.sipsolutions.net>
	 <4DE61A11.1070708@openwrt.org>
	 <1306926131.3867.8.camel@jlt3.sipsolutions.net>
	 <4DE61FEA.60903@openwrt.org>
	 <1306927838.3867.10.camel@jlt3.sipsolutions.net>
	 <4DE6256B.80106@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 14:26:27 +0200
Message-ID: <1306931187.3867.11.camel@jlt3.sipsolutions.net> (sfid-20110601_142638_607723_F1582B84)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-06-01 at 13:41 +0200, Felix Fietkau wrote:
> On 2011-06-01 1:30 PM, Johannes Berg wrote:
> > On Wed, 2011-06-01 at 13:18 +0200, Felix Fietkau wrote:
> >
> >>  >>   >>    >>     >     I don't understand how you can rely on beacons for WDS.
> >
> >>  Oh, right. I'll send a follow-up patch that forces a WDS to also have an
> >>  active AP interface before it's brought up.
> >
> > Hm, that might be sufficient, but what if the peer isn't sending
> > beacons?
> >
> > Can't we add a station entry and then update it if we receive
> > information from the peer? That'd be more compatible with others devices
> > that don't necessarily have beacons with WDS, and then we wouldn't have
> > to require it locally either (since realistically we might have to
> > interoperate with those anyway?)
> What other devices use WDS without beacons? So far I haven't seen any.

I don't know, at least older mac80211 could do that?

johannes

