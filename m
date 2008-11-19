Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56552 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbYKSPmB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 10:42:01 -0500
Subject: Re: Fwd: p54: testing AP mode: cannot switch to master mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefan Steuerwald <salsasepp@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <f76a32050811190737w37937e17ra361364ed345fd33@mail.gmail.com> (sfid-20081119_163733_464931_B9660D6E)
References: <f76a32050811190306s6a86f46dwc245200069ff8a82@mail.gmail.com>
	 <f76a32050811190316o28a49cddte30214c217877078@mail.gmail.com>
	 <1227095773.26243.22.camel@johannes.berg>
	 <f76a32050811190737w37937e17ra361364ed345fd33@mail.gmail.com>
	 (sfid-20081119_163733_464931_B9660D6E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TIpJ8xlUtXnSuAOAsGb3"
Date: Wed, 19 Nov 2008 16:41:26 +0100
Message-Id: <1227109286.26243.54.camel@johannes.berg> (sfid-20081119_164207_143843_A05CE149)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TIpJ8xlUtXnSuAOAsGb3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-19 at 16:37 +0100, Stefan Steuerwald wrote:
> > http://wireless.kernel.org/en/users/Documentation/modes#AccessPoint.28A=
P.29infrastructuremode
> > johannes
>=20
> Thank you, that's it, took the latest hostapd from git.
> I can now connect from my iPod to the XG-603 in AP mode (unencrypted
> and WPA/TKIP, WPA2/TKIP, WPA2/CCMP tested).

Cool

> However - data throughput seems low; accessing a webserver I get an
> update "now and then". I'm aware this can have a lots of causes - I
> have more time and more cards available (XG-601/ISL3880, and an
> AR5212/5213 one) and will play with this.

What rate control algorithm did you compile into the kernel? Minstrel
should perform quite well on p54, unless we made a mistake.

johannes

--=-TIpJ8xlUtXnSuAOAsGb3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJDOjAAoJEKVg1VMiehFYh7MP/13ZxvMtLg8/wUlHzJ86oTyF
CWMXZm1kJu+vVIbflIagvTimBjHj2/KmkqhDzRJaZSAt+2063B6C2ce1g8iYPTXe
EiLXwUekQjaUvCDiqpF3SuZXkbJAaSJHGMkfRlJeWr4Wh+aGaAl0ln7SUccoVwym
FzHrKilk5Zhik+BK8qWpyh6/DDVzVx8FKUtDZZUfhs6d+qzMITOUhIt8/pwrT/lU
VTjZu2BCfbwtM+RiouARAUzoEbaB/XqMwljv/Y+h8pp3g3sZn33EWKzcj7b+qw2M
6Y9ygZAQtlAoWXQaJ0AMJmEPgcG0lwuRWPtusOXyGxyokglI/jx9ePEOPZKE8+S7
0SHejH3ZDjK4rTN3YdQxhKtWvFN7qEVF7G/MmTcng+W5HPleBpA3KYWNC9iZtgqU
0RXgsmYuSAgYM07TM+uyDnsaf6Y3Rg1i9OEsOEdt2gTTuvSAODS/qNGJ3RYHKqar
j7+JlGDtG2oRWzHjsOtpUyu/Ts10eLGyIp+OCRMpxmbUOMSUCSwlfP8XSHqNXWg3
gp5OM9Gc/Gj1y6/X5wnmDx/fQ8zxfGJ4hoQvLmqEkVjdzDhq99jyS00COh/nIgu6
w1R4DYoJTSYXgyB2vXknqINvuNOrGO1CzfKpy2MW5vOeFfaoxJmOHT4jBfIZVoXm
aQixa0VpZNbo+nCYDVVE
=fbzn
-----END PGP SIGNATURE-----

--=-TIpJ8xlUtXnSuAOAsGb3--

