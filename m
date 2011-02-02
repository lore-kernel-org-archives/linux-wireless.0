Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51788 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab1BBWyj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 17:54:39 -0500
Received: by vws16 with SMTP id 16so253168vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Feb 2011 14:54:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110202214014.GC28687@sig21.net>
References: <AANLkTi=bfq+2jev3YGCi0GwfZTkeKa9t2gfuQ8DkbB9p@mail.gmail.com>
	<20110202214014.GC28687@sig21.net>
Date: Wed, 2 Feb 2011 22:54:38 +0000
Message-ID: <AANLkTikWjiJJcpoG64q553WKsizqya-o=xeYcDsZSNuB@mail.gmail.com>
Subject: Re: Ralink RT2501/RT2573 USB Wireless Adapter crashes kernel 2.6.37
From: Eric Fernandez <zeb@zebulon.org.uk>
To: Johannes Stezenbach <js@sig21.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/2/2 Johannes Stezenbach <js@sig21.net>:

> No solution yet, but I'd like to point you to the
> thread on the rt2x00-users list:
> http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-February/003109.html
>
> Johannes
>

What Leonardo is reporting might be the same manifestation of the same
issue. This crash does not happen with kernel 2.6.36, and with 2.6.37,
it happens quite rarely. However, I can increase the chances of it
happening by heavily browsing the Internet, and especially when
seekinbg in Youtube videos, leading to a lot of downloading.

Another post in this mailing list is this one:
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-January/002935.html
since it reports a crash issue specific to 2.6.37 that did not happen
in 2.6.36 (started with
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2010-December/002868.html).

Finally, this issue seems to affect other users:
http://ubuntuforums.org/showthread.php?t=1613049&page=2 "There is a
fairly easy to trigger crash in this one with my USB Ralink
Technology, Corp. RT2501/RT2573 Wireless Adapter (rt73/rt2x00lib). I
am trying to get a proper snapshot of the trace for a report but at
least people might want to be a bit careful."

Eric
