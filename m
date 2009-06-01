Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ip78-183-211-87.adsl2.static.versatel.nl ([87.211.183.78]:55095
	"EHLO god.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbZFAWWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 18:22:47 -0400
Date: Tue, 2 Jun 2009 00:22:46 +0200
From: henk <henk@god.dyndns.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath5k in AP mode works!! (but sometimes with an oops, and a panic)
Message-ID: <20090601222246.GA32667@god.dyndns.org>
References: <20090524222027.GA32198@god.dyndns.org> <b6c5339f0905270550y50a925fbk4b891db8bbb9d9b@mail.gmail.com> <20090527184956.GA14462@god.dyndns.org> <20090528234702.GA9455@hash.localnet> <20090529220222.GA22246@god.dyndns.org> <b6c5339f0905291806j4a7f99f4r9fb40a6a0182cf52@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b6c5339f0905291806j4a7f99f4r9fb40a6a0182cf52@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 29, 2009 at 09:06:57PM -0400, Bob Copeland wrote:
> On Fri, May 29, 2009 at 6:02 PM, henk <henk@god.dyndns.org> wrote:
> > Wouldn't it be better to reverse the deinitialisation? To make sure we
> > dont hit an interrupt in between? Like:
> >
> > ? ? ? ?ath5k_beacon_disable(sc);
> > ? ? ? ?ec->vif = NULL;
> 
> Yeah, actually I gave this some thought but I can't now rationalize
> the current order, so maybe I just goofed.
> 
> -- 
> Bob Copeland %% www.bobcopeland.com

I have tested hostapd+ath5k (only master mode without VLANs) for a few days
now with the new patches. System seems stable no glitches found.

I have aggregated your patches against compat-wireless-2009-06-01:
	http://bugzilla.kernel.org/show_bug.cgi?id=13381#c5

I would say a new milestone in ath5k driver development has been reached 
with working AP support.

Thanks!

Henk
