Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48964 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993257Ab2KOMJL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 07:09:11 -0500
Message-ID: <1352981382.9208.0.camel@jlt4.sipsolutions.net> (sfid-20121115_130915_485127_62A5FBFE)
Subject: Re: [RFC v2 2/8] nl80211: add documentation for channel type
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 15 Nov 2012 13:09:42 +0100
In-Reply-To: <50A4CB5B.6050201@posedge.com>
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>
	 <1352492254-29399-3-git-send-email-johannes@sipsolutions.net>
	 <50A4CB5B.6050201@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-15 at 16:30 +0530, Mahesh Palivela wrote:

> > +/**
> > + * enum nl80211_channel_type - channel type
> > + * @NL80211_CHAN_NO_HT: 20 MHz, non-HT channel
> > + * @NL80211_CHAN_HT20: 20 MHz HT channel
> > + * @NL80211_CHAN_HT40MINUS: HT40 channel, secondary channel
> > + *	below the control channel
> > + * @NL80211_CHAN_HT40PLUS: HT40 channel, secondary channel
> > + *	below the control channel
> 
> Typo. above the control channel

Good catch, thanks.

johannes

