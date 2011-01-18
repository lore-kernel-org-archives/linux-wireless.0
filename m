Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32997 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1ARMMU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 07:12:20 -0500
Subject: Re: [PATCH 3/5] mac80211: add NOL functionality
From: Johannes Berg <johannes@sipsolutions.net>
To: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
In-Reply-To: <201101181301.39953.bernhard.schmidt@saxnet.de>
References: <201101171621.29863.bernhard.schmidt@saxnet.de>
	 <20110117161133.792EB2082@mx.techwires.net>
	 <1295347426.3563.8.camel@jlt3.sipsolutions.net>
	 <201101181301.39953.bernhard.schmidt@saxnet.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 13:13:05 +0100
Message-ID: <1295352785.3563.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-18 at 13:01 +0100, Bernhard Schmidt wrote:
> On Tuesday, January 18, 2011 11:43:46 Johannes Berg wrote:
> > On Mon, 2011-01-17 at 11:05 +0100, Bernhard Schmidt wrote:
> > > NOL is a list of channels on which radar interference has been
> > > detected. Such channels are not allowed to be used for a certain
> > > amount of time.
> > 
> > I don't think this should be implemented in mac80211.
> 
> In cfg80211 then? I'd really prefer to keep all flag-handling together 
> instead of splitting it up between mac80211/userspace.

Yeah, cfg80211 sounds much saner, with APIs there etc.

johannes

