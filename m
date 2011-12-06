Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43637 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932825Ab1LFCDH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Dec 2011 21:03:07 -0500
MIME-Version: 1.0
In-Reply-To: <1323082774.2670.40.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <CAA93jw7kQYONQiAozatRmdRRJeK0GB9eNDWtRZ3AL+OVKn0OpA@mail.gmail.com>
	<1323082774.2670.40.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Date: Tue, 6 Dec 2011 10:03:05 +0800
Message-ID: <CAJ-VmomuA7u5=zRGMK2Jd3WG+HWTRTZNST4JDVWU9kUEcfE91Q@mail.gmail.com> (sfid-20111206_030311_032824_C7F24FAD)
Subject: Re: Time in Queue, bufferbloat, and... our accidentally
 interplanetary network
From: Adrian Chadd <adrian@freebsd.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dave Taht <dave.taht@gmail.com>,
	bloat <bloat@lists.bufferbloat.net>,
	bloat-devel <bloat-devel@lists.bufferbloat.net>,
	netdev@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

For what it's worth, I've also been tinkering with time-in-queue for
the wifi queue management in FreeBSD. I don't have anything public
yet. What I have done actually seems to work quite well, when doing TX
queue time-in-queue management. (I'm ignoring RX queue management for
now.)

Yes, I think a weighted random drop with both time-in-queue and queue
depth would work well. I haven't sat down to model what it'd look like
given some traffic profiles.

I'll be sure to post some patches and results when I have them. :)



Adrian
