Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56381 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaDYPVJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 11:21:09 -0400
Message-ID: <1398439255.4152.10.camel@jlt4.sipsolutions.net> (sfid-20140425_172116_888806_3F22FE0E)
Subject: Re: [PATCH v4 00/13] cfg80211/mac80211: implement multi-vif chanctx
 reservations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, luca@coelho.fi
Date: Fri, 25 Apr 2014 17:20:55 +0200
In-Reply-To: <1397050174-26121-1-git-send-email-michal.kazior@tieto.com> (sfid-20140409_153551_014007_D6D68CDC)
References: <1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
	 <1397050174-26121-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140409_153551_014007_D6D68CDC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> The patchset incrementally improves chanctx
> reservations in order to support multi-vif
> reservations and in-place multi-vif reservations
> (typically for single-channel hardware, but
> multi-channel benefits from this too).

I've applied the first 12 patches, i.e. all but patch 13. As far as
patch 13 is concerned, I (a) need more time to review it, and (b) would
like to understand better how you intend to use it.

I also don't really like the "stub" thing. :)

Maybe it would also make sense to insert the "recalc" refactoring
somewhere around here?

johannes

