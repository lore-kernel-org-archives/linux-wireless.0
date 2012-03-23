Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36793 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab2CWOKH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 10:10:07 -0400
Message-ID: <1332511804.10384.4.camel@jlt3.sipsolutions.net> (sfid-20120323_151012_310371_99EDA802)
Subject: Re: [RFC 04/12] mac80211: prepare ieee80211_get_tx_channel_type to
 per-vif
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Micha=C5=82?= Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 23 Mar 2012 15:10:04 +0100
In-Reply-To: <4F6C8316.5080600@tieto.com>
References: <fee1d9db-75c7-4e26-a463-e5d436a24cc2@FIVLA-EXHUB02.eu.tieto.com>
		 (sfid-20120320_155525_168969_C5FBFFE9) <1332491869.3506.2.camel@jlt3.sipsolutions.net>
	 <4F6C8316.5080600@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-23 at 15:05 +0100, Michał Kazior wrote:
> Johannes Berg wrote:
> >
> >>   enum nl80211_channel_type ieee80211_get_tx_channel_type(
> >> -				struct ieee80211_local *local,
> >> +				struct ieee80211_sub_if_data *sdata,
> >>   				enum nl80211_channel_type channel_type)
> >
> > I have pending patches to delete this :)
> >
> 
> You mean you have patches that remove the ieee80211_get_tx_channel_type 
> function? Are they accessible publicly or do you have them in your local 
> repository? Do you mind sharing them or are you going to push them soon?

I sent them to the list as RFCs before, but you can also grab them at
http://johannes.sipsolutions.net/patches/kernel/all/LATEST/
(HT cleanups / HT channel type changes)

johannes

