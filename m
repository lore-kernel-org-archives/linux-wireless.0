Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56546 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372Ab0ECNYq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 09:24:46 -0400
Subject: Re: [PATCH] mac80211: improve IBSS scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <469051.90774.qm@web51402.mail.re2.yahoo.com>
References: <469051.90774.qm@web51402.mail.re2.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 15:24:44 +0200
Message-ID: <1272893084.3614.37.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-05-03 at 06:20 -0700, Joerg Pommnitz wrote:
> > WHY is it required for you? And yeah, I _am_ still opposed
> > to that.
> 
> Please don't laugh! Really, don't!
> 
> We have an embedded system that normally uses an IBSS network
> as a delivery system (can be deployed for field measurements).
> Some customers were unhappy that the networks could be detected
> on WLAN snoopers like Netstumbler. The quick and dirty solution
> to make the networks invisible was using the AH-demo mode.
> 
> Now "invisible on Netstumbler" is an advertised feature that
> must be maintained for ever after (the GUI has a checkbox 
> "hide from Netstumbler").

Ok ... I'll go improve netstumbler instead of laughing ... if there's
any traffic it can trivially be detected anyway, so what's the point?
Hidden SSID is a hack (which doesn't work with IBSS obviously), but this
kinda seems worse.

Seriously though, why should the upstream kernel support such bad design
decisions...? :)

johannes

