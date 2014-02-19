Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4752 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804AbaBSP2p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 10:28:45 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Subject: RE: [PATCH v3 6/6] mac80211: Enable initiating radiation on indoor
 channels
Date: Wed, 19 Feb 2014 15:28:29 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A03338353E@HASMSX106.ger.corp.intel.com> (sfid-20140219_162858_003556_35111C6B)
References: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
 <1390818118-27261-7-git-send-email-ilan.peer@intel.com>
 <20140219001458.GF14296@garbanzo.do-not-panic.com>
In-Reply-To: <20140219001458.GF14296@garbanzo.do-not-panic.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'll abandon this change ... 

Thanks,

Ilan.

> -----Original Message-----
> From: Luis R. Rodriguez [mailto:mcgrof@gmail.com] On Behalf Of Luis R.
> Rodriguez
> Sent: Wednesday, February 19, 2014 02:15
> To: Peer, Ilan
> Cc: linux-wireless@vger.kernel.org; wireless-regdb@lists.infradead.org
> Subject: Re: [PATCH v3 6/6] mac80211: Enable initiating radiation on indoor
> channels
> 
> On Mon, Jan 27, 2014 at 12:21:58PM +0200, Ilan Peer wrote:
> > Allow active scanning and frame injection on channels marked with
> > IEEE80211_CHAN_NO_IR iff the channel is also marked with
> > IEEE80211_CHAN_INDOOR_ONLY and the wireless core thinks that it
> > operates in an indoor environment.
> >
> > Signed-off-by: Ilan Peer <ilan.peer@intel.com>
> 
> I don't see why being indoor should allow to override the NO-IR flag. I do see
> however why being indoor should enable to IR if you are IR if you have the
> indoor flag. Enabling to IR if you are indoor for all NO-IR channels is... pretty
> permissive I do not see the correlation.
> 

Make sense. I did not have such relaxations defined, just thought that similar relaxations could also be used in cases of scanning etc. but I guess this is not always true. 
