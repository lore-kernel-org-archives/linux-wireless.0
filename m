Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46836 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbbFQIzo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:55:44 -0400
Message-ID: <1434531342.1884.16.camel@sipsolutions.net> (sfid-20150617_105549_214929_879807ED)
Subject: Re: [PATCH] mac80211: Add missing case to PERR processing
From: Johannes Berg <johannes@sipsolutions.net>
To: agreen@cococorp.com
Cc: linux-wireless@vger.kernel.org, Jesse Jones <jjones@cococorp.com>
Date: Wed, 17 Jun 2015 10:55:42 +0200
In-Reply-To: <55787BA1.9030807@cococorp.com> (sfid-20150610_200244_860776_BB81D6C4)
References: <55787BA1.9030807@cococorp.com>
	 (sfid-20150610_200244_860776_BB81D6C4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-10 at 11:02 -0700, Alexis Green wrote:
> When the nexthop is unable to resolve its own nexthop it will send back a
> PERR with a zero target_sn. According to section 13.10.11.4.3 step b in the
> 2012 standard that perr should be forwarded and the associated mpath->sn
> should be incremented. Neither one of those was happening whichis rather
> bad because the originator was not told that packets are black holing.

Applied.

johannes

