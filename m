Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44040 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358Ab3JQOi6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 10:38:58 -0400
Message-ID: <1382020735.14410.14.camel@jlt4.sipsolutions.net> (sfid-20131017_163901_652600_A561DA9F)
Subject: Re: NetworkManager not listing access points
From: Johannes Berg <johannes@sipsolutions.net>
To: Detlev Casanova <detlev.casanova@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Date: Thu, 17 Oct 2013 16:38:55 +0200
In-Reply-To: <3301062.MLBKDh0Ksv@naboo> (sfid-20131011_174257_646312_6E07DE10)
References: <31357461.i5mG9q5IfA@naboo> <2916718.7t7kLXuBQV@naboo>
	 <1381131658.13586.0.camel@jlt4.sipsolutions.net> <3301062.MLBKDh0Ksv@naboo>
	 (sfid-20131011_174257_646312_6E07DE10)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-10-11 at 17:43 +0200, Detlev Casanova wrote:

> > > > > occur before commit 0172bb75073e11a5aa9d8a953bdaefb8709f00c8
> > > 
> > > ("cfg80211:
> > > > > use DS or HT operation IEs to determine BSS channel")
> > 
> > [...]
> > 
> > > I looked into wpa_supplicant and after an upgrade from 0.7.3 to 2.0,
> > > the problem seems to be fixed.
> > 
> > Huh, that's odd. Did 0.7.3 use wext driver?
> 
> Yes it did.

Hmm. Even taking that into account though I don't really see any
difference.

Maybe you could check if there's any difference in iwlist scan output
before/after the patch (for the affected AP)?

johannes


