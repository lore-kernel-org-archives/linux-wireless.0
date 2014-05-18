Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dev-nolb.cloudtrax.com ([54.203.245.161]:56702 "EHLO
	dev-nolb.cloudtrax.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbaEREOa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 May 2014 00:14:30 -0400
Message-ID: <53783355.6070205@open-mesh.com> (sfid-20140518_061435_854662_C31A3CDD)
Date: Sun, 18 May 2014 06:13:09 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iw: print expected throughput when dumping station
References: <1400350632-2422-1-git-send-email-antonio@meshcoding.com>
In-Reply-To: <1400350632-2422-1-git-send-email-antonio@meshcoding.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ch7g0XWgWsTqjMA5a3gVQ7mOBqpNMAxUN"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ch7g0XWgWsTqjMA5a3gVQ7mOBqpNMAxUN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 17/05/14 20:17, Antonio Quartulli wrote:
> From: Antonio Quartulli <antonio@open-mesh.com>
>=20
> Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
> ---
>=20
> This patch is based on the "Export the expected throughput towards a pe=
er"
> patchset sent on linux-wireless

well, this just means that the iw private copy of nl80211.h needs to be
updated in order to use this feature.

Cheers,


--=20
--=20
Antonio Quartulli


--ch7g0XWgWsTqjMA5a3gVQ7mOBqpNMAxUN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTeDNaAAoJEEKTMo6mOh1VpkMQAIL1Ljesm6IOmIrGqQT7cXm3
s2Jom5sBsDaCtUl9lJ601a2gC7o35dGwkMncfLfCO00xO2QQ/iRvu21e/Z43W0xV
ZNeixEJMW2B4mTMA5bCp0SyKPll8h4tY4b5XOpJnH+SVIorQY72z66abosn0vUUk
pZMKCS3AXvfbTTRvWwtJ+XPl6WnAQXgwwPxfD5tmmNvWGcaEscxMwm30l2PN9wPe
pgA4GdUIb5FrttzbU1oR8IBqvv1C27sd3wruH2dHUtOoix05tUiLRqFhn2tTt0LN
JgSIvPikH+DkV+R20Kpf3MN+GxcBFt33BFtMDclFi0maoHqk3BclefOWqA6GWoCe
BYSbu+fgYztgKcLayklH46N5W+RvedKsbLA4vQ3EynCFGNZJ1a0FJQo9xa3MFbjn
W7GHP89XMcNVIzxc5kvcaGR/r4oYgQ0kYuxhfwhD0zmNSzLoj1wMDAwkJNwIc5Y7
b1E6s/o5NzcfzSAqA7F/7PZfzdKlV/8+M6+k9bmvwLVhgdRX8IeFaZcXnyyl9SFd
YKxEN8LJzhRXgOnVFfge+FhYKdaYMhyiHRtTpCFDjvagaNoQmVFg8aNE9mhAmqyd
nkvecO4ohuCfWoICRn3KuS9Mvs4xlNDUQtl/4PhwpaoGBDlb+6iUYnbQ0DWT1bPZ
hQfEikrIdBpFSe1qQF+h
=swiO
-----END PGP SIGNATURE-----

--ch7g0XWgWsTqjMA5a3gVQ7mOBqpNMAxUN--
