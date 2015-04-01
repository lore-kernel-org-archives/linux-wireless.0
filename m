Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57494 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbbDAJXA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 05:23:00 -0400
Message-ID: <1427880174.3428.4.camel@sipsolutions.net> (sfid-20150401_112304_748336_981350CF)
Subject: Re: [PATCH v2] cfg80211: Stop calling crda if it is not responsive
From: Johannes Berg <johannes@sipsolutions.net>
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@suse.com" <mcgrof@suse.com>
Date: Wed, 01 Apr 2015 11:22:54 +0200
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A04D092DC4@HASMSX106.ger.corp.intel.com>
References: <1427717749-27225-1-git-send-email-ilan.peer@intel.com>
	 (sfid-20150330_141354_463006_F82C75ED) <1427878274.3428.2.camel@sipsolutions.net>
	 <CB3B3D4774441E42AA3EA0E1BA8230A04D092DC4@HASMSX106.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-04-01 at 09:19 +0000, Peer, Ilan wrote:

> > Applied, but I put the condition in a place before printing more messages, and
> > changed the messages back to the original ones.
> > 
> 
> But this would miss the update in case that the internal DB is also used.

Hm, true, I'll move the prints later instead.

johannes

