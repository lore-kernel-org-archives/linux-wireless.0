Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.birdnet.se ([213.88.146.6]:50239 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752794AbYI3ON5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 10:13:57 -0400
Message-ID: <20080930141353.16996.qmail@stuge.se> (sfid-20080930_161400_462934_A9F3739F)
Date: Tue, 30 Sep 2008 16:13:53 +0200
From: Peter Stuge <peter@stuge.se>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/T] b43: to few loop tries in do_dummy_tx
References: <48E11F1E.50705@lwfinger.net> <48E14879.4050300@lwfinger.net> <20080930055034.16412.qmail@stuge.se> <200809301528.26304.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809301528.26304.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> > Nice work, but as it's a spec of another driver implementation rather
> > than hardware (or even the firmware API) I don't think it should be
> > so authoritative. If other values are clearly better why not use
> > them?
> 
> What crap are you smoking?

Maybe we just miscommunicated, or maybe I misunderstood something
about the reverse engineering process. I am very new to this project.


> The b43 and b43-legacy driver are _based_ on these specifications.
> There are no other specs available.

I know. Allow me to clarify my train of thought:

* Specs are created by reverse engineering of a binary blob.

* After development of b43*, many can happily use the drivers. \o/

* As it turns out, b43* can be made even more reliable by doing
  things slightly different than what the specs say. Case in point
  looping a little longer.

At this point, if there are only/mostly benefits, I don't see why
deviating from the specs is bad - after all they "only" document
another driver, right?


//Peter
