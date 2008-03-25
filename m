Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:50287 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbYCYPdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 11:33:32 -0400
Received: by mu-out-0910.google.com with SMTP id i10so4059371mue.5
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2008 08:33:28 -0700 (PDT)
Date: Tue, 25 Mar 2008 16:08:48 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?=
	<ariveira@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: Re: Spammed logs again rt2500pci 2.6.25-rc6-00268-gd2532dd
Message-ID: <20080325160848.6dc3584f@Varda> (sfid-20080325_153338_139537_70C84F7E)
In-Reply-To: <200803251441.22394.IvDoorn@gmail.com>
References: <20080117225744.29aa214c@Varda>
	<20080325131250.5167e311@Varda>
	<200803251441.22394.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El Tue, 25 Mar 2008 14:41:22 +0100
Ivo van Doorn <ivdoorn@gmail.com> escribi=C3=B3:

> Hi,
>=20
> >  Linux Varda 2.6.25-rc6-00268-gd2532dd #1 SMP PREEMPT Mon Mar 24 14=
:44:13 CET
> > 2008 x86_64 GNU/Linux
> >=20
> >=20
> >  As the last time the thing is triggered with a p2p app making a lo=
t of
> >  connections deluge
> > =20
> >  My logs are spammed with the same msgs as other reports.
> >  If you need more info just ask.
>=20
> This issue has been resolved for 2.6.26. The fix for this bug is of s=
uch a scale
> that it could not easily be merged for 2.6.25.
>=20
> >  PS: i will not bother to make a report in the web forums becouse t=
he last time
> > i was ignored.
>=20
> You mean http://rt2x00.serialmonkey.com/phpBB2/index.php?
> 'ignored' is not the right word, more likely overlooked.

 Fair enough; english is not my mother tongue so maybe i sounded
harsher than intended. If that's the case my apologies

> There are quite a lot of messages and I don't always have time to ans=
wer them all.
> So there is no need to be upset about such thing, simply posting a re=
minder is usually
> enough to make it noticed by me...
>=20
> > (Someone may want to change the web forums pointer in the logs to=20
> > the linux-wireless mailing list)
>=20
> What pointer? And rt2400-devel is the mailinglist for rt2x00...
> The MAINTAINERS file in the kernel tree indicates 2 mailinglists for =
rt2x00:
> 	rt2400-devel@lists.sourceforge.net
> 	linux-wireless@vger.kernel.org

 Well my opinion is that instead of the webpage the mailing list should=
 be the
one being logged. Something like this (maybe use another define becouse
DRV_PROJECT may be used elsewhere i havn't checked):

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h
b/drivers/net/wireless/rt2x00/rt2x00.h index 6c72542..2791f67 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -44,7 +44,7 @@
  * Module information.
  */
 #define DRV_VERSION	"2.0.14"
-#define DRV_PROJECT	"http://rt2x00.serialmonkey.com"
+#define DRV_PROJECT	"<rt2400-devel@lists.sourceforge.net>"
=20
 /*
  * Debug definitions.



>=20
> Ivo

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
