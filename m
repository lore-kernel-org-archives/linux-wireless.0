Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37180 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbbETNDy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 09:03:54 -0400
Message-ID: <1432127031.19214.9.camel@sipsolutions.net> (sfid-20150520_150400_906673_352F2B73)
Subject: Re: [PATCH] mac80211: fix kernel-doc comments in mac80211.h
From: Johannes Berg <johannes@sipsolutions.net>
To: andrey.konovalov@linaro.org
Cc: emmanuel.grumbach@intel.com, linux-wireless@vger.kernel.org
Date: Wed, 20 May 2015 15:03:51 +0200
In-Reply-To: <555a4e12.e323700a.26a6.ffff9e65@mx.google.com> (sfid-20150518_223947_537367_CC6BC263)
References: <555a4e12.e323700a.26a6.ffff9e65@mx.google.com>
	 (sfid-20150518_223947_537367_CC6BC263)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-05-18 at 23:39 +0300, andrey.konovalov@linaro.org wrote:
> Commits a818292 "mac80211: convert rssi_callback() to event_callback()"
> and a940909 "mac80211: notify the driver about authentication status"
> added two errors and one warning when building docs for the mac80211
> driver. Fix the kernel-doc comments so that the documentation targets
> could be built successfully again.

This was already fixed.

johannes

