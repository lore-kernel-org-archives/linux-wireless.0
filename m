Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35616 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab2KSIc7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 03:32:59 -0500
Message-ID: <1353314009.9310.1.camel@jlt4.sipsolutions.net> (sfid-20121119_093303_044986_34B8255D)
Subject: Re: [RFC v2 4/8] nl80211/cfg80211: support VHT channel configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 19 Nov 2012 09:33:29 +0100
In-Reply-To: <50A9B312.2010603@posedge.com>
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>
	  <1352492254-29399-5-git-send-email-johannes@sipsolutions.net>
	  <50A62FDA.2070307@posedge.com>
	 <1353069457.9490.3.camel@jlt4.sipsolutions.net>
	 <50A9B312.2010603@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-19 at 09:48 +0530, Mahesh Palivela wrote:

> >> Should we have NL80211_CHAN_WIDTH_LEGACY or rename
> >> NL80211_CHAN_WIDTH_20_NOHT to NL80211_CHAN_WIDTH_NOHT to cover non HT
> >> associations in both 2.4 & 5 GHz bands.
> >
> > Huh? I must be misunderstanding something -- both 2.4 and 5 GHz bands
> > use 20 MHz bandwidth by default?
> >
> 
> 2.4 band channel spacing is 5 MHz and we can use 20 MHz bandwidth only 
> in HT mode.

Umm, no.

johannes

