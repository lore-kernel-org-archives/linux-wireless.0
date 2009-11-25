Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53626 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934713AbZKYOIP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 09:08:15 -0500
Subject: Re: [PATCH 0/5] mac80211: stations per virtual interface, netdev
 reduction
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20091125133243.163478670@sipsolutions.net>
References: <20091125133243.163478670@sipsolutions.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-lXfGoyyQhoWv0uyp83ZE"
Date: Wed, 25 Nov 2009 15:07:44 +0100
Message-ID: <1259158064.32372.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lXfGoyyQhoWv0uyp83ZE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-11-25 at 14:38 +0100, Johannes Berg wrote:
> This patchset finally converts station to fully be
> managed per virtual interface.
>=20
> There are also two patches to remove the use of netdevs
> in mac80211.
>=20
> I've been running with this for a while with a few
> other scenarios too (like hwsim AP test) so I'm pretty
> confident it works.

Hoh humm, of course the minute I send it out I find out that it's
broken. Ignore this, sorry.

johannes

--=-lXfGoyyQhoWv0uyp83ZE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLDTotAAoJEODzc/N7+QmarbwP/jnJ0JRNQmWd127r5TInxJH9
wxOgKUeGKBva6Udiod3e2wJLoR2gXZhnIgGHbmhBVXLmnjlvm3WdLw6lKJvh3uTL
DNOBMd2ZZpMW0/y91kM4rUqSmMNIFtwitKprrW4RAThNJkRW53G/MYs5Sm5GQF8D
Gex28Z2V+bkVXTECrnT1HONb5WKhIILddnkC887Tb9f+nZ6iW4x0UL80z1LCF861
112UnvPyKpNowg4oUv/xXCvIqORfZ6lRhK1dTfSrRn8A1JSlemyJWf7pK79m6KSd
QSKWWWJx0OkdOdKToffvD5ZM9OJ4vgeW3s8a3kNUJ1zwkkHAmssgVMljSC6ihDux
5OBKAGpf8iiJ8CSISR5Aq0636WgfxZy0vFxe8JQRMS6rUCRYtX2W2JCDOO5yvbtl
4TXoS3ZZClsWS/YDynRakzrOwIBlZmxAD7KBWwpn53rc2IayB5GnDVqPZtUUXu9u
R7fRZtv8cNUpdFvPdNBZTHOKQYhgoJ/K7efpTYFhem9Xvc7w1kinLOuPZ44+WhMT
3qiRV/ifflnpRb6RnG8tTGCe/tObM+W6Vdw61Qp9Wv6QV4GzqtmkaB6xisHZ/SMf
kfoPJSEhuwURaMqE+jSup5MqcastvCPjn+HHp2gJzPsgBpCXE6/eh2v1ksT42c4a
O7h2n4IQrme6bWi/5jLe
=POe8
-----END PGP SIGNATURE-----

--=-lXfGoyyQhoWv0uyp83ZE--

