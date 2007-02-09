Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946023AbXBICHN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Feb 2007 21:07:13 -0500
Subject: Re: [RFC PATCH 3/3] cfg80211: add wext-compatible client
From: Dan Williams <dcbw@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070208195526.GA5319@infradead.org>
References: <20070131013717.GA28076@tuxdriver.com>
	 <20070207004626.GA23096@tuxdriver.com>
	 <20070207004747.GB23096@tuxdriver.com>
	 <20070207004832.GC23096@tuxdriver.com>
	 <20070207004929.GD23096@tuxdriver.com>
	 <20070207075420.GB14703@infradead.org>
	 <1170940386.4385.49.camel@johannes.berg>
	 <43e72e890702081038k1d4f226eocf28c5faf6b79dc5@mail.gmail.com>
	 <20070208195526.GA5319@infradead.org>
Content-Type: text/plain
Date: Thu, 08 Feb 2007 21:09:20 -0500
Message-Id: <1170986960.2873.9.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-02-08 at 19:55 +0000, Christoph Hellwig wrote:
> On Thu, Feb 08, 2007 at 01:38:02PM -0500, Luis R. Rodriguez wrote:
> > >> in the series actually converts a driver to use it.  Both to make this
> > >> code not dead and give people and example on how to use the cfg80211
> > >> infrastructure.
> > >
> > >I guess I could make softmac use it.
> > 
> > Another idea here is we can provide a configfs frontend to cfg80211
> > therefore any device which implements cfg80211 will automagically have
> > a userspace frontend (/configfs/wireless/foo) ready to test cfg80211.
> 
> Huh?  We already have a wext fronted to nicely test cfg80211, what we
> need are backends.  In addition to that I think we should agree on
> one primary userspace configuration method for the future instead of
> adding lots of them just because it's so easy.  If the public opinion
> has changed 180 degrees and configs is preferred over nl80211 that's
> fine by me as long as the implementation is sane..

I'd prefer to keep the netlink based API for use from userspace tools
like NetworkManager and wpa_supplicant...  configfs is nice for scripts
and screenscrapers but not really appropriate for desktop stuff.

Dan


