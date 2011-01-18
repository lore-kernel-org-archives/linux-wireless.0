Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33042 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab1ARMP2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 07:15:28 -0500
Subject: Re: [PATCH 1/5] mac80211: add DFS related channel flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
In-Reply-To: <201101181259.46719.bernhard.schmidt@saxnet.de>
References: <201101171621.29863.bernhard.schmidt@saxnet.de>
	 <20110117161133.66B54207E@mx.techwires.net>
	 <1295347236.3563.5.camel@jlt3.sipsolutions.net>
	 <201101181259.46719.bernhard.schmidt@saxnet.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 13:16:13 +0100
Message-ID: <1295352973.3563.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-18 at 12:59 +0100, Bernhard Schmidt wrote:

> > I'm not sure about this -- shouldn't that be global information? If
> > one device in the system records a radar on the channel, it surely
> > applies to other devices as well, even if they are hot-plugged after
> > the radar was found?
> 
> True, I've based this on our IRC discussions, the consensus there was to 
> do it per-wiphy only at first.

I thought what we had discussed there (but I missed at least one
meeting) was that the *detector* state, for software-based detection,
should be per wiphy. I never heard anywhere that the result of that
should be local too.

johannes

