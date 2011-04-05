Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:25631 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868Ab1DEPS2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 11:18:28 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2011 08:18:03 -0700
Date: Tue, 5 Apr 2011 20:48:34 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: prevent authentication on channel mismatch w/ hw
 conf
Message-ID: <20110405151834.GB4837@vmraj-lnx.users.atheros.com>
References: <1301937866-14701-1-git-send-email-rmanoharan@atheros.com>
 <1301941003.3795.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1301941003.3795.0.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 04, 2011 at 11:46:43PM +0530, Johannes Berg wrote:
> On Mon, 2011-04-04 at 22:54 +0530, Rajkumar Manoharan wrote:
> > Do not proceed authentication if hw was already configured
> > with one of the vif's channel which is differed with requesting
> > channel. Not doing so is causing unneccesary dissociation.
> > This issue was originaly found while testing concurrent mode
> > with p2p vif.
> 
> This will break any kind of pre-authentication, no?
>
Yeah...I completely ignored roaming part. sorry for that and thanks for pointing out.
Is that fine to proceed authentication in case of matching ssid found in any of the vif's
bss and having such vif iteration under auth. Please help me to sort out.

--
Rajkumar
