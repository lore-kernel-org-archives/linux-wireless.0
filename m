Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43075 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbXIQJyi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2007 05:54:38 -0400
Subject: Re: [Fwd: [AirForce One 54g] working]
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>, gmccullagh@gmail.com
In-Reply-To: <46EDAEC3.6020201@lwfinger.net>
References: <46EDAEC3.6020201@lwfinger.net>
Content-Type: text/plain
Date: Mon, 17 Sep 2007 11:54:32 +0200
Message-Id: <1190022872.3934.6.camel@localhost>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On So, 2007-09-16 at 17:31 -0500, Larry Finger wrote:

> 1. I've been getting tonnes of syslog errors like this:
> 	Sep 16 21:46:59 tilly kernel: [ 5171.869169] CCMP: decrypt failed: STA=00:09:5b:d2:f0:2f
> 	Sep 16 21:46:59 tilly kernel: [ 5171.872336] CCMP: decrypt failed: STA=00:18:84:11:78:d6
> 	Sep 16 21:47:05 tilly kernel: [ 5174.178449] printk: 122 messages suppressed.
>    which all seem to correspond to packets tranferred between my AP and
>    a second netgear laptop with an atheros chipset.  So it's not a worry.
>    ifconfig shows a collossal packet drop count, which seems to
>    approximately equal the number of packets sent+rec'd  by the other
>    laptop so I guess it's the same error as above.  Perhaps there's a good
>    debug reason for these printk statements, but they have their cost on the
>    machine.

Which of my patches do you have applied? I'll look into it at the end of
the week.

johannes

