Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56918 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab0BWPiP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2010 10:38:15 -0500
Subject: Re: [RFC] Improve software scan timing
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@iki.fi>
In-Reply-To: <201002231633.06394.helmut.schaa@googlemail.com>
References: <201002231619.55189.helmut.schaa@googlemail.com>
	 <1266938710.3934.7.camel@jlt3.sipsolutions.net>
	 <201002231633.06394.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Feb 2010 16:38:13 +0100
Message-ID: <1266939493.3934.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-02-23 at 16:33 +0100, Helmut Schaa wrote:

> > > Kalle, Johannes, how is the listen_interval handled in the
> powersave
> > > code?
> > > Are we only sleeping for one beacon interval or are we ignoring
> the
> > > listen_interval currently.
> >
> > I figured this listen interval stuff would come back to bite us at
> some
> > point. I don't think we should negotiate a listen interval of 1.
> OTOH,
> > I'm not convinced that all APs would reject it with a status code of
> 51
> > if it's too large? Or is that tested anywhere like WFA?
> 
> No idea. However for iwlwifi for example we always used a listen
> interval
> of 20 any I never saw any associations getting rejected because of
> this.
> 
> So maybe we could just increase the default to something between 5 and
> 10 to be on the safe side?

Yeah, maybe. Could it be useful for userspace to ask for a specific
value with assoc? Though I'm not really sure what it would use ...

johannes

