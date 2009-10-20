Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44672 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbZJTGaE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 02:30:04 -0400
Subject: Re: [PATCH] cfg80211: sme: deauthenticate on assoc failure
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890910192324t3deab484nad855a5ecd109dd@mail.gmail.com>
References: <1256018933.4475.6.camel@johannes.local>
	 <43e72e890910192324t3deab484nad855a5ecd109dd@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AoG42stK/knOlFkkqqr+"
Date: Tue, 20 Oct 2009 15:26:27 +0900
Message-Id: <1256019987.4475.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AoG42stK/knOlFkkqqr+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-10-20 at 15:24 +0900, Luis R. Rodriguez wrote:
> On Tue, Oct 20, 2009 at 3:08 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > When the in-kernel SME gets an association failure from
> > the AP we don't deauthenticate, and thus get into a very
> > confused state which will lead to warnings later on. Fix
> > this by actually deauthenticating when the AP indicates
> > an association failure.
> >
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>=20
> Thanks Johannes.
>=20
> Tested-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>=20
> John -- this patch and the previous patch titled "mac80211: keep auth
> state when assoc fails" fix the SME warning as well. These are also
> 2.6.32-rc fixes.

And also done during the hacking session at KS.

johannes

--=-AoG42stK/knOlFkkqqr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK3VgPAAoJEODzc/N7+Qmar54QALgglYdeUVaaxjlIXhh+PwxZ
223IsCiZ2E2cP7DRR/KzH+zbA2OzAIYRqbpGeeju+Es38FByEqwAjqVdlcw+smYu
x2i4fzPomTUfRa4OFDTaCTOGrG8PalZBDyPqwT03EMhw8rR8BD3KGJu4PqbfQAoS
U0xN7AladF2lEOaNkMMqsYpORIVZnmc2hYS1t9XjzjfuGaZznI6RvpK5ChpgcXsn
Sqx+h2VKbMN8NS33kAgdNvOktg9S4KO/Kq4gxV5iGJdYBkmFGWIAcitVgNf7CI2B
9vKhWPHYyaIpOIO/flAnktIY6Va5hR+L0qpNTlZxLmRt853JS/c19Iji/QGeQu4c
NDfciUCK2WleHgqi2FDB0k6ab6wfO8G02THfZodycJ9iJCPeJgjUUjypp8P+yx5S
wd2l0L/BklPgpZSFRPC7W2j3g8YXAeilYNv3k15onNVmF3P4NGKtYEbvAayDYhei
SA4bee1i5XfdIAyCWt58SGueiZkCXUL8sV8s8D1KcQGW1x5PLLwGZar5dAD062fl
MKI4aMw+cwMTV5KQRS4rPbK4WI3AGpMttCft+tpC6dTsowmE6GuHzEjuwBeRhzUC
H/zquzdh+XdJjJNOBuevywMd3gAEmBSmg4d86utpcT7UGqK/ZsPdwoJ2rGZOrUvt
LwdY57M5Z/TOXchlRx3+
=9N9V
-----END PGP SIGNATURE-----

--=-AoG42stK/knOlFkkqqr+--

