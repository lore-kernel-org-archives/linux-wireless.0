Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41608 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbaJFOYe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 10:24:34 -0400
Message-ID: <1412605472.3098.16.camel@jlt4.sipsolutions.net> (sfid-20141006_162436_806008_C43722F2)
Subject: Re: Proper way to use mac80211_hwsim.h in user-space tool?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 06 Oct 2014 16:24:32 +0200
In-Reply-To: <5429E151.1010706@candelatech.com> (sfid-20140930_004645_459678_B9B04F51)
References: <5429E151.1010706@candelatech.com>
	 (sfid-20140930_004645_459678_B9B04F51)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-09-29 at 15:46 -0700, Ben Greear wrote:
> As far as I can tell, the .h file is not installed anywhere
> in a normal OS.
> 
> What is the proper method to get this file sanitized and put
> into a more common location?

You mean from the kernel build? Then you'd have to move it into the
include/linux/uapi/ folder etc.

Is it worth it? You can just copy it after all.

johannes

