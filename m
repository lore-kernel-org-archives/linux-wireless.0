Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39644 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab0JNUuw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 16:50:52 -0400
Subject: Re: [PATCH 2/6] Ad cfg80211 call for threshold notifications
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTincG_-s4pWx+m=keMSfhzWfTQeCCGMQzHYk-WTA@mail.gmail.com>
References: <20101013224851.9C46820418@glenhelen.mtv.corp.google.com>
	 <1287040404.4641.5.camel@jlt3.sipsolutions.net>
	 <AANLkTincG_-s4pWx+m=keMSfhzWfTQeCCGMQzHYk-WTA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 22:51:36 +0200
Message-ID: <1287089496.4641.443.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-14 at 13:43 -0700, Paul Stewart wrote:
> I documented that this value in ieee80211_i.h.  Other parameters in
> this file are left undocumented in this module (rssi_hyst, for
> example, is documented in mac80211.h and nl80211.h (in fact, my docs
> in nl80211.h look a little sparse -- I'll fix that up).  I don't
> object to doing it -- I'm just trying to wrap my head around the
> correct conventions.

Anywhere is fine I guess (nl80211.h should work) but I didn't see any
actual units? It would seem to be in Mbps but you're also using the
".bitrate" field from a channel, which is in units of 1/2 Mbps?

johannes

