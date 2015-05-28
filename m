Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55656 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbbE1HAi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 03:00:38 -0400
Message-ID: <1432796432.2459.0.camel@sipsolutions.net> (sfid-20150528_090041_764535_D52FB9BD)
Subject: Re: [PATCH] mac80211: fix kernel-doc comments in mac80211.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: andrey.konovalov@linaro.org, emmanuel.grumbach@intel.com,
	linux-wireless@vger.kernel.org
Date: Thu, 28 May 2015 09:00:32 +0200
In-Reply-To: <1432769411.6319.36.camel@decadent.org.uk>
References: <555a4e12.e323700a.26a6.ffff9e65@mx.google.com>
	 (sfid-20150518_223947_537367_CC6BC263) <1432127031.19214.9.camel@sipsolutions.net>
	 <1432769411.6319.36.camel@decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-05-28 at 00:30 +0100, Ben Hutchings wrote:
> On Wed, 2015-05-20 at 15:03 +0200, Johannes Berg wrote:
> > On Mon, 2015-05-18 at 23:39 +0300, andrey.konovalov@linaro.org wrote:
> > > Commits a818292 "mac80211: convert rssi_callback() to event_callback()"
> > > and a940909 "mac80211: notify the driver about authentication status"
> > > added two errors and one warning when building docs for the mac80211
> > > driver. Fix the kernel-doc comments so that the documentation targets
> > > could be built successfully again.
> > 
> > This was already fixed.
> 
> It's been one week and this is still broken in Linus's tree.  There was
> a fix for some of the other warnings, but I don't see these errors fixed
> anywhere.

Yeah, somehow I put this into my -next pile... Given how late we are, I
don't think I want to change that now though.

johannes

