Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55234 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714AbaLOMAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 07:00:05 -0500
Message-ID: <1418644802.5731.3.camel@sipsolutions.net> (sfid-20141215_130024_565062_25C27B46)
Subject: Re: [PATCH] mac80211: add an intermediate software queue
 implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 15 Dec 2014 13:00:02 +0100
In-Reply-To: <548AFB9C.1060408@openwrt.org>
References: <1416352495-82172-1-git-send-email-nbd@openwrt.org>
		 <1418390516.2470.46.camel@sipsolutions.net> <548AF047.9080404@openwrt.org>
	 <1418392866.2470.49.camel@sipsolutions.net> <548AFB9C.1060408@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-12-12 at 15:28 +0100, Felix Fietkau wrote:

> > Management (and maybe control) frames can have different priorities as
> > well, this is only used for something with TDLS now I think though.
> With my implementation, those would go through the normal tx codepath,
> bypassing the software tx queues. Can you think of anything else that
> would need per-AC vif queues?

Not off the top of my head. I just didn't even quite understand that you
were still using the normal tx path

johannes

