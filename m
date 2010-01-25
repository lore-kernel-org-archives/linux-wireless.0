Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56724 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab0AYJcK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 04:32:10 -0500
Subject: Re: mac80211: Breakage in software encryption (iwl3945)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jochen Friedrich <jochen@scram.de>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4B5CE054.9020306@scram.de>
References: <1264277460.13250.10.camel@maxim-laptop>
	 <1264330613.23766.17.camel@johannes.local>
	 <1264357465.4152.4.camel@maxim-laptop> <4B5CD773.1010107@scram.de>
	 <4B5CE054.9020306@scram.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fuTo4ODAr5wJJUH03yXK"
Date: Mon, 25 Jan 2010 10:32:02 +0100
Message-ID: <1264411923.23766.33.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fuTo4ODAr5wJJUH03yXK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-01-25 at 01:05 +0100, Jochen Friedrich wrote:

> > I have the same problem since compat-wireless-2010-01-20 with=20
> > iwl3945. compat-wireless-2010-01-15 works OK. However, as i don't=20
> > use any module parameters, i guess i'm using hw encryption.
>=20
> I bisected this to commit 813d76694043d00b59475baa1fbfaf54a2eb7fad.=20
> Reverting this patch makes compat-wireless-2010-01-20 and later run OK.

Thanks. I'll look into that today.

johannes

--=-fuTo4ODAr5wJJUH03yXK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLXWUNAAoJEODzc/N7+QmaOf4P/1WIIASemU9U8sXa6deh7nGW
mKbhbSVh9lW0VmyyS/D6YmiLqBHT2RQZYdlSF7jyy4E5jwX07zsEEXxX47+y03Tz
qD+gRwUtt928HqsYbwrAt+sf3oYTobyqwD8OnpKW81JBRfgE+q3of5xwpWVXT4dq
ZYW57M4cgx7YCSvSjfnoUuQEXCTyhPp0UeaD1xxBzJbxJEnEwoUvag4At30bE1R1
ckxJIHczcl59lR0UhewN4ste7z09mAm+ggCCJsTATsxneFr8RbrSktn323Mhq1z7
ScktCsP4M/HmspkgAlIymyS0rrojkyP/UBZWWqTBn3po8vsyKQ/Ap1GMt8hcNaQt
g7E/iaqkDnIhcW5YsZRPQE8nKxNqtLtrd5ORraBuKFzgfJBC0W2bXm/mGvpNEm60
gp9BDcdQ7cCjz/B0d2v8QA50IS2eEDO2FGkWgsVSJ/7HuqBAUCeknrmtDHP946Qv
BQtv4PWqL9t+txTa01EY9rMdL0+TZh7iM/X9peXjuBV1FPqJ9NXbU09PvNQRpmSa
4LJuIIfweeqDPRQN0dxpJThYZhHdvKNPmMwpNVU2C5nKPv4IUOYlvNoJmMD2qAoi
2S+TpU90I9O8wD7ha9K/y9Sg3I4qfioEt2rZXzpPPly0uHbYsjRUY6dOwVLUMTp0
HLaTiWBUCEmrw51GKH68
=6ZKm
-----END PGP SIGNATURE-----

--=-fuTo4ODAr5wJJUH03yXK--

