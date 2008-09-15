Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47355 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbYIOSQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 14:16:08 -0400
Subject: Re: [PATCH 2/2] Don't destroy authentication
	algorithm	before	authenticating.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ortwin =?ISO-8859-1?Q?Gl=FCck?= <odi@odi.ch>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <48CE8FBE.2040000@odi.ch>
References: <48CE8452.9080604@odi.ch>
	 (sfid-20080915_175050_484202_3CD78757) <1221494039.3700.47.camel@johannes.berg>
	 <48CE86B6.6080704@odi.ch>
	 (sfid-20080915_180118_027162_C9C60EF5) <1221494673.3700.54.camel@johannes.berg>
	 <48CE8FBE.2040000@odi.ch>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kLEK61w3a3zbSNhiIv6Q"
Date: Mon, 15 Sep 2008 20:15:09 +0200
Message-Id: <1221502509.3700.71.camel@johannes.berg> (sfid-20080915_201612_335877_E892789B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kLEK61w3a3zbSNhiIv6Q
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-15 at 18:39 +0200, Ortwin Gl=C3=BCck wrote:

> Really the only difference that I see now is the probe request/response.
> Attached are two Wireshark packets logs. Ignore all the Beacons and scrol=
l down=20
> until the authentication sequence.
>=20
> good - what my card sends with some binary drivers
> bad2 - what mac80211 sends (2.6.27-rc5 my 2 patches)

The packet capture indicates that the packets are retransmitted
indicating  that the AP isn't even acknowledging them, which in turn
indicates it's not receiving them. This suggests there's something wrong
with ath9k, are you positive it works with those mac80211 hacks?

johannes

--=-kLEK61w3a3zbSNhiIv6Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIzqYqAAoJEKVg1VMiehFYt88P/0xChU0xtzQqjH7qGFzQiw4C
3gEN2DMfJagDNOA6ABaSkvsToHhTmiLgKzdJdDHC4Rk+heOowyA3Olm0m1iZM7Wc
I5krrU2DD8LjUAhAOdlhy09XyZ8unliJL9+U93PAoorg5Rp8MZRHcGsiz9AU5WLo
Lk/0WqDfvW+eWKN5aqQZ78vpr0O8Eqkoy4sCJwxdOKP87G936LOa1t7JI0NrhGGw
UynAW++gDcm5fyjZi/KLpmXLXHnO/KBKlIXw34661NBNQrjbBvwnKP2tWagK7djK
/fbH0hrvgrxsuFhgtmsPNr4tVWYCbWDFzh4XPfGTQKrT6l5QZh6fu9kDDuzzvjsa
tAHDN0wJqMNDy5/i0UMkWmfaKQaiYeJtbSeqMYnHwHEMqJjz0FQKlCAyqvudqMhp
vs9YbERWSnkngoLgtHP11YrIvBQhdcwUzUHT4uDIn3txY4nrJWbY2kn8C/KpyQ3L
j5Eg5FOaSxneJ/rdnbenP4Ufm+5Lug6XIoIH0XVM7KaoxK567uPerDDT5WOcV/v6
nmXd/z4KIscf0Ru9+Udf5rka2Ns9OrSjJLlA9A4It9o1Squ0X/5N/qEKNHkMa3bH
sTYekxwXGtIJA4BsYINZKi2WdHxG5yVG83brhRJLHxWQJRSLQ4tPu3pKg1r/hOZS
XKwtDILmIzNAHrJXk3iM
=nUnE
-----END PGP SIGNATURE-----

--=-kLEK61w3a3zbSNhiIv6Q--

