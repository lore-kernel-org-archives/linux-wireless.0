Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:46829 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbZCTWNB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 18:13:01 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [RFC][RFT][PATCH 0/5 v5] ar9170: ar9170 driver (aka mac80211's otus)
Date: Fri, 20 Mar 2009 23:12:57 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	otus-devel@lists.madwifi-project.org
References: <200903170408.12626.chunkeey@web.de> <200903202214.51394.chunkeey@web.de> <20090320212515.GA12078@kroah.com>
In-Reply-To: <20090320212515.GA12078@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903202312.57737.chunkeey@web.de> (sfid-20090320_231309_751963_1ED0B4EE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 20 March 2009 22:25:15 Greg KH wrote:
> On Fri, Mar 20, 2009 at 10:14:51PM +0100, Christian Lamparter wrote:
> > On Friday 20 March 2009 21:13:26 Greg KH wrote:
> > > On Fri, Mar 20, 2009 at 08:36:08PM +0100, Christian Lamparter wrote:
> > > > Based on the number of mails I got, this driver should be ready for inclusion.
> > > > So, this is probably the last RFC and the official patches will follow on
> > > > sunday (only if no one finds a bug that needs to be fixed ASAP.)
> > > 
> > > Wonderful!
> > :-)
> > 
> > > When the driver goes into the "real" portion of drivers/net please let
> > > me know and I'll drop the otus driver from the drivers/staging/
> > > location.
> > Well, I doubt that we can replace Otus, ever...
> 
> Why, what is lacking in the version you have that is in the otus driver?
>
Well, a few features that the vendors uses to encourage potential buyers:
- HT ( 802.11n - aka 300mbps )
- ANI (ambient noise immunity - so it works in noisy environments),
- TPC/DFS (802.11h - crucial if you want to "blast" the 5GHz band 
		      in most countries)
- AP/AD-Hoc 

comes to my mind. That said I didn't really look into otus to see which
of these feature actually works as advertised

Nevertheless ar9170 should fit the bill for users with 802.11b/g
accesspoint just fine.

and of course one could always argue that 802.11n is !still! a draft,
5GHz is not very widespread yet, and ANI only helps on very weak links...

However, I suggest that we wait and see what's the situation when
the first ar9170 bits are about to enter vanilla... deal?

Regards,
	Chr
