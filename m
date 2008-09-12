Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39324 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755967AbYILVP2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 17:15:28 -0400
Date: Fri, 12 Sep 2008 14:15:19 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: The new regulatory code kills my wireless
Message-ID: <20080912211518.GD7722@tesla> (sfid-20080912_231532_528680_A1707D21)
References: <48CAA8D6.1030605@lwfinger.net> <20080912174036.GC6134@tesla> <48CAB90C.5090302@lwfinger.net> <20080912191919.GA7722@tesla> <1221250959.5576.10.camel@johannes.berg> <20080912203438.GB7722@tesla> <48CAD837.9060909@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <48CAD837.9060909@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 12, 2008 at 01:59:35PM -0700, Larry Finger wrote:
> Luis R. Rodriguez wrote:
> >
> > Sorry, I forgot to factor in lazy people, that's important. I hope
> > there are no lazy distributions.
> 
> There may or may not be any of them, but there will be lots of people
> that are running kernels later than the standard for their distro - me
> as one example. Not all of them will have the skills or inclination to
> build CRDA. For them, I expect that the distro kernels will have the
> old stuff enabled as long as that option lives.
> 
> Note: The prerequisites for building CRDA should include netlink. That
> was the last stumbling block for me.

Yeah good point.

  Luis
