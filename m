Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37195 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab1DEPUY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 11:20:24 -0400
Subject: Re: [RFC] mac80211: prevent authentication on channel mismatch w/
 hw conf
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110405151834.GB4837@vmraj-lnx.users.atheros.com>
References: <1301937866-14701-1-git-send-email-rmanoharan@atheros.com>
	 <1301941003.3795.0.camel@jlt3.sipsolutions.net>
	 <20110405151834.GB4837@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Apr 2011 17:20:21 +0200
Message-ID: <1302016821.4968.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-05 at 20:48 +0530, Rajkumar Manoharan wrote:
> On Mon, Apr 04, 2011 at 11:46:43PM +0530, Johannes Berg wrote:
> > On Mon, 2011-04-04 at 22:54 +0530, Rajkumar Manoharan wrote:
> > > Do not proceed authentication if hw was already configured
> > > with one of the vif's channel which is differed with requesting
> > > channel. Not doing so is causing unneccesary dissociation.
> > > This issue was originaly found while testing concurrent mode
> > > with p2p vif.
> > 
> > This will break any kind of pre-authentication, no?
> >
> Yeah...I completely ignored roaming part. sorry for that and thanks for pointing out.
> Is that fine to proceed authentication in case of matching ssid found in any of the vif's
> bss and having such vif iteration under auth. Please help me to sort out.

You could also pre-auth if it's a different network if you like ...

What's the problem anyway?

johannes

