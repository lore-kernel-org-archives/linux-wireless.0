Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40829 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002Ab3KLQmI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 11:42:08 -0500
Message-ID: <1384274524.14301.9.camel@jlt4.sipsolutions.net> (sfid-20131112_174222_708269_74D88D96)
Subject: Re: [PATCH] iw: add support for 5 and 10 MHz channels in IBSS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Date: Tue, 12 Nov 2013 17:42:04 +0100
In-Reply-To: <201311121739.21600.sw@simonwunderlich.de>
References: <1384273978-11510-1-git-send-email-sw@simonwunderlich.de>
	 <1384274088.14301.8.camel@jlt4.sipsolutions.net>
	 <201311121739.21600.sw@simonwunderlich.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-12 at 17:39 +0100, Simon Wunderlich wrote:
> 
> > On Tue, 2013-11-12 at 17:32 +0100, Simon Wunderlich wrote:
> > > 5/10 MHz requires to send the frequency information as chandef instead
> > > of the the old channel type, this change is included here as well.
> > 
> > I think you need to keep the channel type to stay compatible with old
> > kernels.
> > 
> 
> Wow, high-speed reply (1 minute 50 seconds), and you are right. :)

I needed most of that time to scan if you were really removing it ;-)

> I'll change that so it uses chandef only for 5/10 MHz and the old channel 
> types for the rest (NOHT,HT20,HT40+,HT40-).

You could also add both attributes, but whichever is more convenient,
the kernel obviously has to support both too.

johannes


