Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58617 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab2FGU4L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 16:56:11 -0400
Message-ID: <1339102567.4630.8.camel@jlt3.sipsolutions.net> (sfid-20120607_225627_903541_548F61C9)
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >=
 n_queues))
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>
Cc: Andre Heider <a.heider@gmail.com>, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Date: Thu, 07 Jun 2012 22:56:07 +0200
In-Reply-To: <1339094215.4630.7.camel@jlt3.sipsolutions.net> (sfid-20120607_203710_507564_555516DC)
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com>
	 <1339014959.4523.0.camel@jlt3.sipsolutions.net>
	 <CAHsu+b-ByqBaci9W-oS3OPEK3LdRcuGphtQPOTQ02hPWNpWgQw@mail.gmail.com>
	 <1339053364.4517.0.camel@jlt3.sipsolutions.net>
	 <CAHsu+b9UjkF6VM_YjJkHVDQzrZqsWqmG-XJKFNeSCdWGbdEngw@mail.gmail.com>
	 <20120607180325.7752b3c0@milhouse>
	 <1339094215.4630.7.camel@jlt3.sipsolutions.net>
	 (sfid-20120607_203710_507564_555516DC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-07 at 20:36 +0200, Johannes Berg wrote:

> However, it's also possible to actually *use* the new mac80211 feature.
> That would also help with IEEE80211_TX_CTL_SEND_AFTER_DTIM, you could
> ask mac80211 to use a separate HW queue for it (for tx_ring_mcast.) This
> may be quicker.

This might do it, I haven't tested it at all:

http://p.sipsolutions.net/3c6b003bb06e5298.txt

johannes

