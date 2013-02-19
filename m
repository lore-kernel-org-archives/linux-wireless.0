Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:36075 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193Ab3BSSqM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 13:46:12 -0500
From: Sujith Manoharan <sujith@msujith.org>
Message-ID: <20771.51233.248133.141840@gargle.gargle.HOWL> (sfid-20130219_194616_306328_531ABCEE)
Date: Wed, 20 Feb 2013 00:14:49 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Adrian Chadd <adrian@freebsd.org>
Cc: Georgiewskiy Yuriy <bottleman@icf.org.ru>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	devel@lists.open80211s.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] improve operational ANI in Mesh mode
In-Reply-To: <CAJ-VmokAP6hSxjGDUu7Q5rSg3dvxfLapQBSLgYCvWc9b0YEPgA@mail.gmail.com>
References: <alpine.DEB.2.02.1302160630580.4293@icf.org.ru>
	<20130219134028.GA26332@pandem0nium>
	<alpine.DEB.2.02.1302191752110.31254@icf.org.ru>
	<CAJ-VmomPkPvABSJtdb6Y=fDNxyd_XtE6sk9yWQzw9qC7rjkwiA@mail.gmail.com>
	<alpine.DEB.2.02.1302192034420.7450@icf.org.ru>
	<CAJ-VmokUJtowcO0AWpyFLoLN0R0KowETb1BOyjN66rzPSDhjOQ@mail.gmail.com>
	<20771.50338.434076.484711@gargle.gargle.HOWL>
	<CAJ-VmokAP6hSxjGDUu7Q5rSg3dvxfLapQBSLgYCvWc9b0YEPgA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adrian Chadd wrote:
> It's easy enough to diagnose - just enable NF cal logging. Look at
> what's being read back from the initial NF cal and what's being
> written into the time-series average.

I discussed this with Felix a while ago, a small log is here:
http://pastebin.ca/2312828 (Note the jump in signal level).

> It may be that something dumb is happening, like there's no
> per-channel history, or the history from the wrong channel is being
> used on a new channel.

I am not sure about the dumb part, but ath9k doesn't have per-channel
history or calibration data. :)

Sujith
