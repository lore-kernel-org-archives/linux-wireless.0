Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56967 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab1ARKjw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 05:39:52 -0500
Subject: Re: [PATCH 1/5] mac80211: add DFS related channel flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
In-Reply-To: <20110117161133.66B54207E@mx.techwires.net>
References: <201101171621.29863.bernhard.schmidt@saxnet.de>
	 <20110117161133.66B54207E@mx.techwires.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 11:40:36 +0100
Message-ID: <1295347236.3563.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-17 at 09:31 +0100, Bernhard Schmidt wrote:
> Before a radar channel can be used, a full CAC has be done, the
> IEEE80211_CHAN_RADAR_CLEAR flags indicates that this has been done. If either
> during CAC or in-service monitoring interference is detected, the channel is
> added to NOL and marked with IEEE80211_CHAN_RADAR_INTERFERENCE.

I'm not sure about this -- shouldn't that be global information? If one
device in the system records a radar on the channel, it surely applies
to other devices as well, even if they are hot-plugged after the radar
was found?

johannes

