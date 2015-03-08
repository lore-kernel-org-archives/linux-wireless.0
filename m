Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:42588 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbbCHHej convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2015 03:34:39 -0400
From: "Peer, Ilan" <ilan.peer@intel.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v10 3/3] cfg80211: Schedule timeout for all CRDA calls
Date: Sun, 8 Mar 2015 07:34:35 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A04D040F1C@HASMSX106.ger.corp.intel.com> (sfid-20150308_083445_350153_A37C33B8)
References: <1425447127-22958-1-git-send-email-ilan.peer@intel.com>
 <1425447127-22958-3-git-send-email-ilan.peer@intel.com>
 <20150305225526.GC25035@wotan.suse.de>
In-Reply-To: <20150305225526.GC25035@wotan.suse.de>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks :)

Ilan.

> -----Original Message-----
> From: Luis R. Rodriguez [mailto:mcgrof@suse.com]
> Sent: Friday, March 06, 2015 00:55
> To: Peer, Ilan
> Cc: linux-wireless@vger.kernel.org
> Subject: Re: [PATCH v10 3/3] cfg80211: Schedule timeout for all CRDA calls
> 
> On Wed, Mar 04, 2015 at 12:32:07AM -0500, Ilan Peer wrote:
> > Timeout was scheduled only in case CRDA was called due to user hints,
> > but was not scheduled for other cases. This can result in regulatory
> > hint processing getting stuck in case that there is no CRDA configured.
> >
> > Change this by scheduling a timeout every time CRDA is called. In
> > addition, in restore_regulatory_settings() all pending requests are
> > restored (and not only the user ones).
> >
> > Signed-off-by: Ilan Peer <ilan.peer@intel.com>
> 
> Acked-by: Luis R. Rodriguez <mcgrof@suse.com>
> 
> For all of these.
> 
>  Luis
