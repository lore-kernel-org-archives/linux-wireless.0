Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42065 "EHLO sipsolutions.net"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932515AbbCFIkE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 03:40:04 -0500
Message-ID: <1425631172.3339.1.camel@sipsolutions.net> (sfid-20150306_094011_728646_500444FE)
Subject: Re: [PATCH v10 3/3] cfg80211: Schedule timeout for all CRDA calls
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Ilan Peer <ilan.peer@intel.com>, linux-wireless@vger.kernel.org
Date: Fri, 06 Mar 2015 09:39:32 +0100
In-Reply-To: <20150305225526.GC25035@wotan.suse.de> (sfid-20150305_235530_475137_C30BAA08)
References: <1425447127-22958-1-git-send-email-ilan.peer@intel.com>
	 <1425447127-22958-3-git-send-email-ilan.peer@intel.com>
	 <20150305225526.GC25035@wotan.suse.de>
	 (sfid-20150305_235530_475137_C30BAA08)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-03-05 at 23:55 +0100, Luis R. Rodriguez wrote:
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

Great, all three applied, thanks guys.

johannes

