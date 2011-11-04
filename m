Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59299 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1KDQaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 12:30:24 -0400
Subject: Re: [PATCH v3 3/3] mac80211: Allow overriding some HT information.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EB4126E.1020802@candelatech.com>
References: <1320299722-30113-1-git-send-email-greearb@candelatech.com>
	 <1320299722-30113-3-git-send-email-greearb@candelatech.com>
	 (sfid-20111103_065549_863747_7FFD5818) <1320310045.3950.23.camel@jlt3.sipsolutions.net>
	 <4EB2CBCC.6080709@candelatech.com>
	 <1320417690.3969.88.camel@jlt3.sipsolutions.net>
	 <4EB41014.6000002@candelatech.com>
	 <1320423893.3969.104.camel@jlt3.sipsolutions.net>
	 <4EB4126E.1020802@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Nov 2011 17:30:20 +0100
Message-ID: <1320424220.3969.105.camel@jlt3.sipsolutions.net> (sfid-20111104_173027_301239_E258DE67)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-04 at 09:27 -0700, Ben Greear wrote:

> > So I still stand by what I said earlier -- you should not allow
> > advertising a smaller value than the hardware wanted to use initially.
> > If the AP doesn't use that smaller value, all is well, but if it
> > actually uses a smaller value then the hardware might fall over.
> 
> Ok, I'll add that restriction.  When this all settles, maybe I
> can get some info from the ath9k folks about what their hardware
> can actually support.

There's little point in advertising something bigger than the HW
supports, so I'd say that's the smallest :-)
(ok, so this might be for hw crypto, etc., but ath9k could advertise a
smaller value when hw crypto is disabled for example)

johannes

