Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42528 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3LCIyU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 03:54:20 -0500
Message-ID: <1386060856.4393.2.camel@jlt4.sipsolutions.net> (sfid-20131203_095425_215279_E0AD4728)
Subject: Re: [RFC] cfg80211/mac80211: drop GTK-protected unicast IP packets
From: Johannes Berg <johannes@sipsolutions.net>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Date: Tue, 03 Dec 2013 09:54:16 +0100
In-Reply-To: <529D9BBE.6040900@gmail.com> (sfid-20131203_095221_806346_3857F957)
References: <1386010316-2540-1-git-send-email-johannes@sipsolutions.net>
	 <529D9BBE.6040900@gmail.com> (sfid-20131203_095221_806346_3857F957)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-03 at 09:52 +0100, Pontus Fuchs wrote:

> > +/**
> > + * cfg80211_is_ip_unicast - check if packet is IP unicast
> > + * @skb: skb, in 802.3 format
> > + */
> > +bool cfg80211_is_ip_unicast(struct sk_buff *skb);
> > +
> 
> Not implemented anywhere. Leftovers?

Oops, yeah, I was going to make this a helper function but then needed
so much extra setup/checking there I just inlined it into mac80211.

Thanks for spotting!

johannes

