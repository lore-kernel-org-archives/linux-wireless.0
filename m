Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39443 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395AbYILUes (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 16:34:48 -0400
Date: Fri, 12 Sep 2008 13:34:38 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: The new regulatory code kills my wireless
Message-ID: <20080912203438.GB7722@tesla> (sfid-20080912_223454_117582_BD0C6C10)
References: <48CAA8D6.1030605@lwfinger.net> <20080912174036.GC6134@tesla> <48CAB90C.5090302@lwfinger.net> <20080912191919.GA7722@tesla> <1221250959.5576.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1221250959.5576.10.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 12, 2008 at 01:22:38PM -0700, Johannes Berg wrote:
> On Fri, 2008-09-12 at 12:19 -0700, Luis R. Rodriguez wrote:
> > Well no, IMHO people *should not* use the old regulatory stuff if
> > possible, the idea is to kill it ASAP, you should only use the old
> > regulatory stuff if you *need* to, meaning you have some dependency
> > on the old module parameter for some strange odd ball reason or if
> > you cannot compile and install crda or iw.
> 
> Well, TBH, I was just too lazy to do that ;)

Sorry, I forgot to factor in lazy people, that's important. I hope
there are no lazy distributions.

  Luis
