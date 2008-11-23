Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59140 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbYKWT6K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Nov 2008 14:58:10 -0500
Subject: Re: [PATCH] Fix warning in info.c with gcc 4.3 (Ubuntu 8.10)
From: Johannes Berg <johannes@sipsolutions.net>
To: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?=
	<ariveira@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081123190951.686d099a@varda> (sfid-20081123_190954_927279_4E459CD8)
References: <20081123190951.686d099a@varda>
	 (sfid-20081123_190954_927279_4E459CD8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9Nfy12Fg0GYcE0mJtTjf"
Date: Sun, 23 Nov 2008 20:58:07 +0100
Message-Id: <1227470287.3599.52.camel@johannes.berg> (sfid-20081123_205815_176104_72E73BCC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9Nfy12Fg0GYcE0mJtTjf
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-11-23 at 19:09 +0100, Alejandro Riveira Fern=C3=A1ndez wrote:
> fix this warning i got with last pull
>=20
> info.c: In function 'print_flag':
> info.c:19: warning: format not a string literal and no format arguments

The \n you added shouldn't be there, I've committed an equivalent fix.

johannes

--=-9Nfy12Fg0GYcE0mJtTjf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJKbXMAAoJEKVg1VMiehFY7GwP/A8zHFHNPFbDNJG9JqRADAbY
8gfstJDNRq2dRLcBjeOgz9GfiExmrYJ07PNViO473k/fqm3tHpNWOBobRNDG1cvt
1oHqL+iUK9RJQj6jHVIO0ZZ/A9oYnL34ThgJQjvBqzvWvoKGBloRBrP/4SMTzMxv
H9soP0Grp/YKy5WDyjyHW5L143MkF39Noo+/Z9Zilu4Yv3dkfgPUUwIcZ8uz+Lrb
MwTvghQItpoguQ+Im8QXRvFS6Qo0b2MPFcSH3g6eoitc5QXDfbskyL2ENO1fLyPr
jTLIRmq5fRrPaxlJzIuPhq8dngoPyllZTFPD79k5hB3lNy/qbKldEiLxSNP0iXjl
YYOGUrC8gJa1zQ7O2EEsmEh5LHxhd69jX5FVO94vq5R23jnJe8TE7e1XZA5ZFOtm
r6oJvuMcSXSQhN28V5BMr2/JHl6z+jjMM/enm3899VR2lQV+f7ExARGMxGqQvyeL
QM3YoLdenYQTl33Yn62Ncm+YZQB6J/tM/7EffU6IACcHMPFpUbWTfLGgh49POoir
fQqmfsGwJB+JapQ+9Cppv0QriQFnyC110cq61XtBtEr4EP2k+TGcu7TIpcqJTyBp
Nm85tU0OlwkjFXFHlcnx2pDWSMHV9louRmDFcsUJS6VVjTdo27kKkXHmVkC5Debn
dAt7WG4eOmEGyNbKTXvz
=lYzB
-----END PGP SIGNATURE-----

--=-9Nfy12Fg0GYcE0mJtTjf--

