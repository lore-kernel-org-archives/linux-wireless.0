Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34694 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbZKHOBJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 09:01:09 -0500
Subject: Re: ar9170 in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <4AF6CC02.8080204@web.de>
References: <4AF6C7CD.7060108@web.de> <878wehf85v.fsf@purkki.valot.fi>
	 <4AF6CC02.8080204@web.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rHKFUue5MRPEiIuFK7Ia"
Date: Sun, 08 Nov 2009 15:01:10 +0100
Message-ID: <1257688870.29454.52.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rHKFUue5MRPEiIuFK7Ia
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-11-08 at 14:47 +0100, Jan Kiszka wrote:

> > IMHO AP mode should not be enabled until it's confirmed that power
> > save mode works properly.

Agreed.

> How common is the combination of powersaving and mcast in practice?

Uh, it's nothing to do with the combination. If you don't support proper
mcast buffering, any powersaving client will be in big trouble due to
ARP/NDP etc.

Any device that supports powersaving is thus impacted. That ranges from
desktops and laptops down to your cellphone.

> Given that quite a few useful scenarios are blocked right now (unless
> you know what to patch), I would at least vote for a config option or a
> module parameter. That gives a chance to warn the user about this
> limitation without locking out people that are no hackers.

Given that we want to have everything support powersave on the client
side, I have to disagree -- supporting something that will be
troublesome for many clients will just make it look bad.

johannes

--=-rHKFUue5MRPEiIuFK7Ia
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK9s8iAAoJEODzc/N7+QmaZkEQAKzv6UmLp3Oo6WsSImQq+Agu
a4YqmoXMzlVTM2kWJwaVF4xdGNcepajAK6aXPNhR0u8Xl6S6v/u+djwOIscdVZxk
AMFKvaW98dZYjT8odvbrHldhkRc2KnOaoHNI6nrl7pg2O6LBUuS1gO6lH7jW2gng
lPxTLjheWQ+G46msSh3WEG4/ymNe4LRy2A8HlxfNk+6SZu3QF1TgBi5K7aScAHMq
8hMmIHsANnWC2YbGqk4kskfZWYxCNvOUZ2y5SprSRkVR7CJM8Ys3SZbDyXxrPglU
eDY5CVa64sJOtwL9xuTRGrIoSmy54lwvp8aDUz0/VlcBCIiBY4By38WLg4F98TKw
Q+RuwCdIZAgIA2dt2nEoOHzxSonqDcq795ZbmZB1Y3kKopYSLZP9Af6BtI4+TlnG
IRswzDGXiaizV/WAU+3R5rcQ2o/dLzqyHzNXCcLl5iHIJnrS82qvzaQPf2jwjp8X
V8en3QJ+usydyCkmnfXXLUTrDAafb/tfkTS127V01gFnC9KHnZ5/7UO2n1LqEpdY
vcqotNTSWbZa1odCru2UXA+1bdZpaqDaXcIrGwHGVsZQG6ciJrf4s1iTygzjze0C
KRGIr0Hz0fB/zCdiiCROI+nkVaRlOwLn81tyYoAM5c6/TMW5L0+1DYddkf9ZuU+v
I3l7Vw+qQM6Dp2FX2UuU
=KwSV
-----END PGP SIGNATURE-----

--=-rHKFUue5MRPEiIuFK7Ia--

