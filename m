Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47695 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab2LEJFa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 04:05:30 -0500
Message-ID: <1354698356.9972.5.camel@jlt4.sipsolutions.net> (sfid-20121205_100537_084930_A4A93909)
Subject: Re: [PATCH] mac80211: Moving Zero Len subframe reporting under
 driver capability check.
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 05 Dec 2012 10:05:56 +0100
In-Reply-To: <1354698297.9972.4.camel@jlt4.sipsolutions.net> (sfid-20121205_100438_778981_61CC2184)
References: <CABPxzYKvtgdoxU-dFS2F0tz_1F6cz02uvVgy5qfMPCEbLOZZ=A@mail.gmail.com>
	 (sfid-20121205_063839_781806_ABA3EF11) <1354698297.9972.4.camel@jlt4.sipsolutions.net>
	 (sfid-20121205_100438_778981_61CC2184)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-05 at 10:04 +0100, Johannes Berg wrote:
> On Wed, 2012-12-05 at 11:08 +0530, Krishna Chaitanya wrote:
> > Zero Len subframe makes sense only when driver supports the reporting
> > of zero len subframes.
> 
> Yes, but if the driver is stupid enough to set RX_FLAG_AMPDU_IS_ZEROLEN
> without setting RX_FLAG_AMPDU_REPORT_ZEROLEN I'm not sure we care?

Plus your patch doesn't apply anyway.

johannes

