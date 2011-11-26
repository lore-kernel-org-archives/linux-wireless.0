Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34755 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab1KZUMU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Nov 2011 15:12:20 -0500
Subject: Re: Converting ipw2x00 driver to mac80211 framework
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1322338254.4283.2.camel@jlt3.sipsolutions.net> (sfid-20111126_211101_524928_E79A99E1)
References: <CA++WF2O0WjyqU0HEGR1XE9xDFzR+sxRboVWexRCMPi8okOVkkA@mail.gmail.com>
	 (sfid-20111126_053149_447307_E1B14D26)  <1322338254.4283.2.camel@jlt3.sipsolutions.net>
	 (sfid-20111126_211101_524928_E79A99E1)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Nov 2011 21:12:17 +0100
Message-ID: <1322338337.4283.3.camel@jlt3.sipsolutions.net> (sfid-20111126_211223_748846_D0487EC3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-11-26 at 21:10 +0100, Johannes Berg wrote:

> It would be much less risky to convert the entire thing to cfg80211, I
> think, basically just replacing the configuration layer in libipw_wx.c
> with a cfg80211 based one.

It might also be a good idea to do some cleanups first -- e.g. I notice,
just in a random look at the code, that reset_port isn't used anywhere
so all code related to that can be removed...

johannes

