Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:1231 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbYKZJxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 04:53:45 -0500
Received: by wa-out-1112.google.com with SMTP id v27so187545wah.21
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 01:53:44 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18733.7188.148730.783104@localhost.localdomain> (sfid-20081126_105350_558419_3BD03642)
Date: Wed, 26 Nov 2008 15:21:16 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
Subject: Re: [RFC] nl80211: Add frequency configuration (including HT40)
In-Reply-To: <1227688845.4613.53.camel@johannes.berg>
References: <20081125190533.GA27879@jm.kir.nu>
	<18732.54720.739365.435163@localhost.localdomain>
	<1227688845.4613.53.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2008-11-26 at 10:21 +0530, Sujith wrote:
> > Jouni Malinen wrote:
> > > + * @NL80211_ATTR_WIPHY_FREQ: frequency of the selected channel in MHz
> > > + * @NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET: included with NL80211_ATTR_WIPHY_FREQ
> > > + *	if HT40 (40 MHz channels) are allowed:
> > > + *	NL80211_SEC_CHAN_BELOW = secondary channel is below the primary channel
> > > + *	NL80211_SEC_CHAN_ABOVE = secondary channel is above the primary channel
> > 
> > The driver needs to know if the selected channel is HT or not.
> 
> Can you explain what difference that makes? Is it for running the phy in
> pure legacy mode?

Yes, we calibrate the HW differently for HT/legacy.
Also, we have different rate tables for legacy/HT.
For HT20, it can reach 130 Mbps.

Sujith
