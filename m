Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54919 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756015AbbCCKBY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 05:01:24 -0500
Message-ID: <1425376880.2450.32.camel@sipsolutions.net> (sfid-20150303_110131_640671_0ADD62CC)
Subject: Re: [PATCH 00/16] Various patches from our internal tree
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Tue, 03 Mar 2015 11:01:20 +0100
In-Reply-To: <1425376034.2450.28.camel@sipsolutions.net> (sfid-20150303_104726_514804_825F6ABE)
References: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1425376034.2450.28.camel@sipsolutions.net>
	 (sfid-20150303_104726_514804_825F6ABE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-03 at 10:47 +0100, Johannes Berg wrote:
> All applied, except for 
> 
> > Arik Nemtsov (4):
> >   mac80211: update TDLS sta spatial streams before auth
> 
> this one where I'm trying to see if it can be combined with another
> patch.

And patch 15 broke the TI driver build, so I've dropped that.

johannes

