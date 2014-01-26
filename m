Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55424 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbaAZWWF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jan 2014 17:22:05 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Subject: RE: [PATCH v2 3/6] cfg80211: Enable GO operation on additional
 channels
Date: Sun, 26 Jan 2014 22:21:48 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A03336BD11@HASMSX106.ger.corp.intel.com> (sfid-20140126_232232_260893_5B8FA0BC)
References: <1389801162-14488-1-git-send-email-ilan.peer@intel.com>
 <1389801162-14488-4-git-send-email-ilan.peer@intel.com>
 <20140125000901.GA28512@garbanzo.do-not-panic.com>
In-Reply-To: <20140125000901.GA28512@garbanzo.do-not-panic.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Luis R. Rodriguez [mailto:mcgrof@gmail.com] On Behalf Of Luis R.
> Rodriguez
> Sent: Saturday, January 25, 2014 02:09
> To: Peer, Ilan
> Cc: linux-wireless@vger.kernel.org; wireless-regdb@lists.infradead.org
> Subject: Re: [PATCH v2 3/6] cfg80211: Enable GO operation on additional
> channels
> 
> 
> <--
> 
> > +		wdev_lock(wdev_iter);
> > +		if (wdev_iter->current_bss)
> > +			other_chan = wdev_iter->current_bss-
> >pub.channel;
> > +		wdev_unlock(wdev_iter);
> 
> -->
> 
> This is begging to be added as a helper.

Rethinking this ... currently this is not really used by other code paths other than the wext ones. Do u still want the helper function?

Ilan.
