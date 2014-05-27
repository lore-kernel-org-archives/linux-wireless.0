Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34964 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbaE0SM5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 14:12:57 -0400
Message-ID: <1401214369.8146.13.camel@jlt4.sipsolutions.net> (sfid-20140527_201300_795584_161D79ED)
Subject: Re: nl80211 kernel doc??
From: Johannes Berg <johannes@sipsolutions.net>
To: shankar swaminathan <shankswa@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 May 2014 20:12:49 +0200
In-Reply-To: <1401214293.8146.12.camel@jlt4.sipsolutions.net> (sfid-20140527_201140_738419_142F72F0)
References: <CADNhdGFpnY8Dy5ybV83QgpPShzSnk1eSNCHhsLb9r7svFGn9mw@mail.gmail.com>
	 (sfid-20140527_200810_822649_9A968E27) <1401214293.8146.12.camel@jlt4.sipsolutions.net>
	 (sfid-20140527_201140_738419_142F72F0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-05-27 at 20:11 +0200, Johannes Berg wrote:
> On Tue, 2014-05-27 at 23:37 +0530, shankar swaminathan wrote:
> > Hello,
> > 
> > the kerneldoc for nl80211 used to be very useful -
> > http://wireless.kernel.org/en/developers/Documentation/nl80211/kerneldoc
> > 
> > However, this link is not been working for a while now.
> > Is there any other equally good documentation for nl80211?
> 
> Oops. Most of the content is in
> https://www.kernel.org/doc/htmldocs/80211/index.html

Err, no, it's not. It should be, but it's not. You can look at the raw
nl80211.h file though, it was always the only source of the kerneldoc
anyway.

johannes

