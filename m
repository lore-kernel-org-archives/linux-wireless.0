Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50127 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857AbZA3QvM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 11:51:12 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2009 08:51:12 -0800
Date: Fri, 30 Jan 2009 08:50:26 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Bruno Randolf <bruno@thinktube.com>
Subject: Re: [PATCH] mac80211: remove HW_SIGNAL_DB
Message-ID: <20090130165026.GD6534@tesla> (sfid-20090130_175119_356018_31B88CD7)
References: <1233310386.4161.25.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1233310386.4161.25.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 30, 2009 at 02:13:06AM -0800, Johannes Berg wrote:
> Giving the signal in dB isn't much more useful to userspace
> than giving the signal in unspecified units. This removes
> some radiotap information for zd1211 (the only driver using
> this flag), but it helps a lot for getting cfg80211-based
> scanning which won't support dB, and zd1211 being dB is a
> little fishy anyway.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Cc: Bruno Randolf <bruno@thinktube.com>

We should be able to convert zd1211rw to use dBm anyway, we shall
release a new "vendor driver" for it which I think has some bits for this.
Just need to get around to it.

  Luis
