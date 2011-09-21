Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34423 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab1IUNpj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 09:45:39 -0400
Date: Wed, 21 Sep 2011 09:40:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Greg KH <greg@kroah.com>, Franky Lin <frankyl@broadcom.com>,
	gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for mainline
 patch #2
Message-ID: <20110921134056.GB2828@tuxdriver.com> (sfid-20110921_154542_268049_6BB3612E)
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
 <20110920130338.GA9885@kroah.com>
 <1316524874.3953.41.camel@jlt3.sipsolutions.net>
 <CACna6rxxoRoLi9C3RBsot8kvZx4k5AZVHzHoE17q-iT1U7i5qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rxxoRoLi9C3RBsot8kvZx4k5AZVHzHoE17q-iT1U7i5qg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 20, 2011 at 10:56:49PM +0200, Rafał Miłecki wrote:
> 2011/9/20 Johannes Berg <johannes@sipsolutions.net>:
> > On Tue, 2011-09-20 at 06:03 -0700, Greg KH wrote:
> >
> >> And while code is great and nice, I still haven't seen any real answers
> >> to all of the questions that were asked of the Broadcom driver team
> >> during that review by the linux-wireless developers about how things
> >> will be handled properly due to the overlap in functionality with the
> >> existing "real" driver in the tree.
> >
> > Let's qualify this to "some developers".
> >
> > One thing I'd like to point out is that the Broadcom's firmware API has
> > always undergone changes over time. I'm actually surprised that b43
> > works as well as it does (which, tbh, isn't very well at all, at least
> > for me with some 11n PHY). I also don't think that Broadcom are going to
> > maintain compatibility and/or maintain new firmware features for old
> > devices, that just doesn't make any sense.
> 
> Actually, when we got some single response from Broadcom about their
> relation to b43, they haven't mentioned support for old HW is any
> problem at all. They just pointed we don't support calibration for
> N-PHY and we don't support 802.11n feature for a better performance.
> 
> I feel we're creating some problems ourself. Just some guessing that
> support for older HW can be real problem for future development... not
> confirmed by anyone at all.

Their new firmware doesn't run on the older hardware, no?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
