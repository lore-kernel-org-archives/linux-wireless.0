Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dev-nolb.cloudtrax.com ([54.203.245.161]:43897 "EHLO
	dev-nolb.cloudtrax.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbaAUQK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 11:10:26 -0500
Message-ID: <52DE9BAA.6020205@open-mesh.com> (sfid-20140121_171029_383587_DDFFC045)
Date: Tue, 21 Jan 2014 17:09:14 +0100
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Antonio Quartulli <antonio@meshcoding.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 1/5] cfg80211: export minstrel best rate information through
 get_station()
References: <1390302591-3352-1-git-send-email-antonio@meshcoding.com>	 <1390302591-3352-2-git-send-email-antonio@meshcoding.com> <1390320014.6199.61.camel@jlt4.sipsolutions.net>
In-Reply-To: <1390320014.6199.61.camel@jlt4.sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lmj0JhfVUTdXDIfGhNI8J7c8B97HmG61j"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lmj0JhfVUTdXDIfGhNI8J7c8B97HmG61j
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 21/01/14 17:00, Johannes Berg wrote:
> On Tue, 2014-01-21 at 12:09 +0100, Antonio Quartulli wrote:
>=20
>> + * @prob: probability of success of this birate
>=20
> typo: bitrate
>=20
>> +struct cfg80211_minstrel_rate_info {
>> +	u32 bitrate;
>> +	u32 prob;
>> +};
>=20
> Do you actually care about this, rather than bitrate*prob, ie. somethin=
g
> like "expected throughput"?=20

Right now this is the way how we use it in the batman-adv code..but we
may decide to change it for some reason. This is why I preferred to keep
the two values separated.

> Actually this isn't expected throughput, but
> wouldn't something like expected throughput make even more sense?

How should I obtain that if not with the previous operation (bitrate*prob=
)?


--=20
Antonio Quartulli


--lmj0JhfVUTdXDIfGhNI8J7c8B97HmG61j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS3putAAoJEEKTMo6mOh1V/hsP/R6DScgSeagUdAfPN8//Y0d8
Ujrv3pLrCBvvYkfxeKI0O7O2js/IEXxhHM7IxGXXxGrXOGZEP6cJFShMf7/RTwRX
PW7wHhAFD4LqwvWTC5UEtuzAeDBwgQA6e9a9UNb5NFQ76IX1RpC5nwcMjE4ZP+DM
+GspOeJssHp9TQwYmjZdXScN+ZJeG2tUyR43e5KkbkZU3ZmM9L+cqi0mUkgVlVdU
iDYZ0ZtwS3bQF1C8VL8SsjZ9JCa9JZtlcHU4kvB16EIRfFitOWL0iKJnCuiB9V3u
+u6SbTTJ/xomuviFPlhIXj0nLJG/59aJKQs2LuqdVO1aHSB7TjpCZ5PzXO47brJ5
VlsxWjCxWzlg6aF62d45GgutZYoaqxnpCDqxN4qCDtnis3O36ZAK5BCe1PEYDTk1
40p1hBmPqAcuKHyxw05fzJaNC5mJzjf6rrTHLjvrS+7I38+4ZR3G4kDxLfzLZxwY
a1CXLmfLEbn/4YDMZcI7NSWZBTt7e0KjG8Ji0SU0pIDwo/5Yj71S+DVkbJm9wmCR
ntdWQ/ymCDK6BG5T3giYPJBzBY4lW0eIn57K1ciT26qTkd9dEcHZvrA0PnkvLTgb
avwC4g3EVZPU9xdon2o8E+4QtxAdXIo8fJSEKvSjmHVwvWFBrEoAUGnoZpZcYPJ0
k/ulCfeIZBJ3b1dnv+gT
=5YL3
-----END PGP SIGNATURE-----

--lmj0JhfVUTdXDIfGhNI8J7c8B97HmG61j--
