Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g19.free.fr ([212.27.42.27]:41294 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759200AbYG0GlA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2008 02:41:00 -0400
Received: from smtp1-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp1-g19.free.fr (Postfix) with ESMTP id F06311AB2CC
	for <linux-wireless@vger.kernel.org>; Sun, 27 Jul 2008 08:40:58 +0200 (CEST)
Received: from localhost (ble59-5-82-233-204-229.fbx.proxad.net [82.233.204.229])
	by smtp1-g19.free.fr (Postfix) with ESMTP id BA3261AB2AC
	for <linux-wireless@vger.kernel.org>; Sun, 27 Jul 2008 08:40:58 +0200 (CEST)
Date: Sun, 27 Jul 2008 08:40:58 +0200
From: =?UTF-8?B?Q8OpZHJpYw==?= Auger <cedric@grisbi.org>
To: linux-wireless@vger.kernel.org
Subject: Re: iwl3945 slow for downloading
Message-ID: <20080727084058.78b57f53@grisbi.org> (sfid-20080727_084118_416285_0F872381)
In-Reply-To: <488B5736.1080401@openwrt.org>
References: <20080726161140.59041730@grisbi.org>
	<488B3969.4050405@openwrt.org>
	<488B48C1.6090506@lwfinger.net>
	<488B5736.1080401@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le Sat, 26 Jul 2008 18:56:22 +0200,
=46elix Fietkau <nbd@openwrt.org> a =C3=A9crit :

> Larry Finger wrote:
> > Just for comparison, my BCM4312 running b43 from the latest
> > wireless-testing gets the following tcpperf throughput:
> >=20
> > AP Mode          TX          RX
> >=20
> > Mixed b/g    19.8 MB/s   23.0 MB/s
> > g-only       20.5 MB/s   23.1 MB/s
> >=20
> > For these tests, the connecting end was wired to the router. The
> > difference in TX speeds was about what I expected - the small
> > difference in RX speeds was not. In any case, if you see a large
> > difference with iwl3945, that would be useful information.

> On the laptop that I mentioned, this problem was only happening
> sometimes. I did not figure out what actually triggered it.
> Most of the time the throughput was similar to what you posted here,
> but when it went down, it went down right to 100-120 KB/s

i'm happy that it happened sometimes too because i was begining to feel
crazy ;-) all the last tests seem to show an upload problem, but at the
begining, i was thinking i had a download problem (from internet), but
from yesterday, i cannot reproduce that, only upload...
=20
> Could it be that this is triggered by the use b/g protection mode due
> to reception of foreign beacons of B devices by the AP? Has anybody
> tested RTS/CTS in detail?

for that i think it goes beyond my abilities...
i forgot to say about the AP, i think it's not g wifi, it's MIMO.
perhaps it could change something.
and for information, the second computer i use to do the tests is also
a 3945ABG intel wireless, but installed with ubuntu and iwl3945 too
(but the default installation), with a 2.6.24 kernel.
the difference with me, except the computer itself, is debian, kernel
2.6.26 compiled by myself, and before i used ipw3945, but remove it
completely
thanks
cedric
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
