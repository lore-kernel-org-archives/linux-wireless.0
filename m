Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59660 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab1ARKnC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 05:43:02 -0500
Subject: Re: [PATCH 3/5] mac80211: add NOL functionality
From: Johannes Berg <johannes@sipsolutions.net>
To: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
In-Reply-To: <20110117161133.792EB2082@mx.techwires.net>
References: <201101171621.29863.bernhard.schmidt@saxnet.de>
	 <20110117161133.792EB2082@mx.techwires.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 11:43:46 +0100
Message-ID: <1295347426.3563.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-17 at 11:05 +0100, Bernhard Schmidt wrote:
> NOL is a list of channels on which radar interference has been detected.
> Such channels are not allowed to be used for a certain amount of time.

I don't think this should be implemented in mac80211.

johannes


