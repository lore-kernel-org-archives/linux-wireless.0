Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16323 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbYLAUgq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 15:36:46 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 12:36:46 -0800
Date: Mon, 1 Dec 2008 12:36:44 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v3 4/4] mac80211: move dynamic_ps_timeout to hw.conf
Message-ID: <20081201203644.GN5992@tesla> (sfid-20081201_213650_428036_A5C4C01C)
References: <1227901784-5325-1-git-send-email-kalle.valo@nokia.com> <1227901784-5325-5-git-send-email-kalle.valo@nokia.com> <43e72e890812011111h53553a18x2d17c9cf267331dd@mail.gmail.com> <1228160468.10627.42.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1228160468.10627.42.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 01, 2008 at 11:41:07AM -0800, Johannes Berg wrote:
> On Mon, 2008-12-01 at 11:11 -0800, Luis R. Rodriguez wrote:
> 
> > Would it be too much trouble to add this via cfg80211/nl80211 instead
> > or at least add both? The more we can push in that direction the
> > better.
> 
> That would be good, but I don't think it's really a requirement right
> now since wext has the API we need already.

Sure, just wishful thinking.

  Luis
