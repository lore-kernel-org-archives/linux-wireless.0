Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:48187 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbaBTJck convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 04:32:40 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Spinadel, David" <david.spinadel@intel.com>
Subject: RE: [PATCH v4 1/5] cfg80211: Add indoor only and GO concurrent
 channel attributes
Date: Thu, 20 Feb 2014 09:32:37 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A03338424D@HASMSX106.ger.corp.intel.com> (sfid-20140220_103246_693750_A2438C54)
References: <1392824377-18254-1-git-send-email-ilan.peer@intel.com>
 <1392824377-18254-2-git-send-email-ilan.peer@intel.com>
 <20140219161101.GJ14296@garbanzo.do-not-panic.com>
In-Reply-To: <20140219161101.GJ14296@garbanzo.do-not-panic.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.
> > + * @IEEE80211_CHAN_INDOOR_ONLY: Only indoor use is permitted on
> this channel.
> > + *	A channel marked with IEEE80211_CHAN_INDOOR_ONLY can only be
> used when
> > + *	there is a clear assessment that the device is operating in an indoor
> > + *	surroundings, i.e., it is connected to AC power (and not through
> > + *	portable DC inverters) or is under the control of a master that is
> > + *	acting as an AP and is connected to AC power.
> > + * @IEEE80211_CHAN_GO_CONCURRENT: GO operation is allowed on this
> channel if
> > + *	it's connected concurrently to a BSS on the same channel on the 2
> GHz
> > + *	band or to a channel in the same UNII band (on the 5 GHz band), and
> > + *	IEEE80211_CHAN_RADAR is not set
> > + *	Instantiating a GO on a channel marked with
> IEEE80211_CHAN_GO_CONCURRENT
> > + *	can be done when there is a clear assessment that the device is
> > + *	operating under the guidance of an authorized master, i.e., setting
> up a
> > + *	GO while the device is also connected to an AP with DFS and radar
> > + *	detection on the UNII band.
> 
> 
> Would make sense to add here a comment indicating what you mentioned
> on the other thread about userspace being responsible for this verification.
> In this case the supplicant (wpa_supplicant).

Sure.
 
> >   *	using this channel as the primary or any of the secondary channels
> >   *	isn't possible
> > + * @NL80211_FREQUENCY_ATTR_INDOOR_ONLY: Indoor only use is
> permitted
> > + *	on this channel in current regulatory domain
> 
> I'd prefer the more verbose documentation to go here as this is the
> userspace API. What you can do is on the IEEE80211_CHAN_INDOOR_ONLY
> documetnation refer for further information to
> %NL80211_FREQUENCY_ATTR_INDOOR_ONLY.
> 

Done.

> > + * @NL80211_FREQUENCY_ATTR_GO_CONCURRENT: GO operation is
> allowed on this
> > + *      channel if it's connected concurrently to a BSS on the same channel
> on
> > + *      the 2 GHz band or to a channel in the same UNII band (on the 5 GHz
> > + *      band), and NL80211_FREQUENCY_ATTR_RADAR is not set
> 
> Same here.

Done.

Regards,

Ilan.

