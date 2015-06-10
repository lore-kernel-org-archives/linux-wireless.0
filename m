Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60286 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbbFJVj1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 17:39:27 -0400
Message-ID: <1433972365.3145.18.camel@sipsolutions.net> (sfid-20150610_233931_115832_058BF671)
Subject: Re: Add netdev name to  NL80211_CMD_STOP_AP event?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 10 Jun 2015 23:39:25 +0200
In-Reply-To: <5578AA11.2020505@candelatech.com> (sfid-20150610_232022_833916_9A1896A2)
References: <5578AA11.2020505@candelatech.com>
	 (sfid-20150610_232022_833916_9A1896A2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-10 at 14:20 -0700, Ben Greear wrote:
> While trying to make 'iw' able to print out something useful for
> the 'stop_ap' event, I notice there is not really any human friendly
> info in the message (just phy id (which may not match phy name), ifindex, and some other
> wiphy related numeric ID.
> 
> Any reason not to add the netdev name (NL80211_ATTR_IFNAME) to this and
> related messages?

We're not really adding that *anywhere*, and you can trivially look it
up based on the ifindex, so why bother?

johannes

