Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:43059 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216AbcFCRKG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 13:10:06 -0400
Date: Fri, 3 Jun 2016 10:10:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Anyone have a clone of wireless-legacy.git?
Message-ID: <20160603171007.GA22697@roeck-us.net> (sfid-20160603_191045_186750_8B9DBCF7)
References: <20160602183803.GH6230@tuxdriver.com>
 <20160603011827.GA2542@roeck-us.net>
 <1464937583.2224.0.camel@sipsolutions.net>
 <20160603143408.GL6230@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20160603143408.GL6230@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 03, 2016 at 10:34:08AM -0400, John W. Linville wrote:
> On Fri, Jun 03, 2016 at 09:06:23AM +0200, Johannes Berg wrote:
> > 
> > > http://www.filewatcher.com/_/?q=wireless-legacy.git, maybe ?
> > > 
> > 
> > Seems to work - both have the same branches:
> > 
> >   adm8211                 72c942ed694e [PATCH] adm8211: fix build breakage from skb->mac.raw
> >   at76                    279f8592e428 cfg80211: keep track of supported interface modes (at76)
> >   ath5k                   8584ac94e3bb [PATCH] ath5k: Internalize Atheros Turbo modes
> >   ath5k-2008-01-21        5b8ca29e11b5 ath5k: remove duplicate bssid variable
> >   mac80211-attic          2bc68d999610 [PATCH] mac80211: remove scan struct from hostapd_param
> >   mac80211-dungeon        ad097a32e9ad [PATCH] mac80211 [HT] 802.11 code compiles under CONFIG_MAC80211_HT
> >   prism54usb              101e59f5e18a prism54usb: more fix for wireless Kconfig changes
> >   rtl8180-2008-01-21      55fc0e806a93 rtl8180: remove calibration error message for rtl8225z2
> >   tiacx                   d6a6811c508b [PATCH] TI acx100/acx111: Make debug level selectable in configuration
> >   wireless-dev-2007-08-10 ca29ec8f05c1 Merge ../wireless-dev-legacy into wireless-dev-2007-08-10
> >   wireless-dev-2007-09-24 cd799e167394 Merge branch 'p54' into everything
> > 
> > johannes
> 
> I got them both from the two FTP sites, and both git repos appear to
> be identical.  It would be best if someone had an actual record of
> the commit hash values, but this might be the best I/we can do...?
> 
We do know this published SHA:

c1928199c27de433d1e81b78e3178be4f0e978d2

from the ath5k legal analysis.

There are a couple of hits for 72c942ed694ef6249c0df84c0802e7378884e7c7,
which is the full SHA for the adm8211 branch.

There are also lots of hits for 6a55617ed5d1aa62b850de2cf66f5ede2eef4825,
which I think is the master branch SHA, and is in the upstream kernel.

Guenter
