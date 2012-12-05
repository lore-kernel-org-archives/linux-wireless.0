Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47690 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab2LEJEc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 04:04:32 -0500
Message-ID: <1354698297.9972.4.camel@jlt4.sipsolutions.net> (sfid-20121205_100438_778981_61CC2184)
Subject: Re: [PATCH] mac80211: Moving Zero Len subframe reporting under
 driver capability check.
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 05 Dec 2012 10:04:57 +0100
In-Reply-To: <CABPxzYKvtgdoxU-dFS2F0tz_1F6cz02uvVgy5qfMPCEbLOZZ=A@mail.gmail.com> (sfid-20121205_063839_781806_ABA3EF11)
References: <CABPxzYKvtgdoxU-dFS2F0tz_1F6cz02uvVgy5qfMPCEbLOZZ=A@mail.gmail.com>
	 (sfid-20121205_063839_781806_ABA3EF11)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-05 at 11:08 +0530, Krishna Chaitanya wrote:
> Zero Len subframe makes sense only when driver supports the reporting
> of zero len subframes.

Yes, but if the driver is stupid enough to set RX_FLAG_AMPDU_IS_ZEROLEN
without setting RX_FLAG_AMPDU_REPORT_ZEROLEN I'm not sure we care?

johannes


