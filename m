Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37187 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab0JETnF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 15:43:05 -0400
Subject: Re: [PATCH v2 2/3] mac80211: wait until completely disassociated
 before new association
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>, Jouni Malinen <j@w1.fi>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <Amod.Bodas@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
In-Reply-To: <20101005193623.GC11831@tux>
References: <1285965233-11097-1-git-send-email-lrodriguez@atheros.com>
	 <1285965233-11097-3-git-send-email-lrodriguez@atheros.com>
	 <1286198080.3620.34.camel@jlt3.sipsolutions.net>
	 <20101004163605.GC2105@tux>
	 <1286210392.3620.40.camel@jlt3.sipsolutions.net>
	 <20101004180458.GP2105@tux>
	 <1286217898.3620.54.camel@jlt3.sipsolutions.net>
	 <20101004205551.GR2105@tux> <1286265582.3641.6.camel@jlt3.sipsolutions.net>
	 <20101005193623.GC11831@tux>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 21:43:04 +0200
Message-ID: <1286307784.3641.30.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-05 at 12:36 -0700, Luis R. Rodriguez wrote:

> > Come to think of it -- some p2p stuff in the supplicant might time out
> > if we do this,
> 
> Its no different than the case of a DTIM 1 case when we do bgscan
> and need to scan through some passive scan channels.
> 
> > I think we need to cut the drivers/mac80211 some more
> > slack in the supplicant and not assume the remain-on-channel will start
> > quickly.
> 
> Not sure I follow, do you mean that as per API we want to document
> offchannel operation may loose broadcast/multicast data frames?

Never mind ... it's not really related to this issue much. (but no, I
meant that the offchannel operation might not start quickly)

johannes

