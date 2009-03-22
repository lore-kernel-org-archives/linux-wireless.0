Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37719 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbZCVM44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 08:56:56 -0400
Subject: Re: Kernel panic with zd1211rw and today's compat-wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090322174515.22f11d92@home.aephome.ru> (sfid-20090322_134524_211033_029824A8)
References: <20090322174515.22f11d92@home.aephome.ru>
	 (sfid-20090322_134524_211033_029824A8)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fpaXU1HOYDUMS54VGwC2"
Date: Sun, 22 Mar 2009 13:56:52 +0100
Message-Id: <1237726612.19647.2.camel@johannes.local> (sfid-20090322_135658_672253_E9575196)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fpaXU1HOYDUMS54VGwC2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-03-22 at 17:45 +0500, Alexander E. Patrakov wrote:

> There are several different panic messages,
> the common thing is "Fatal exception in interrupt". Without uvesafb,
> they also include "zd_op_tx+0x98/0x1cc [zd1211rw]" as the last line,

http://git.kernel.org/?p=3Dlinux/kernel/git/linville/wireless-testing.git;a=
=3Dcommitdiff;h=3D3b23889bb2366c1b10f69bcca16cf53426b5e309

> but with uvesafb, this sometimes changes to
> "rate_control_get_rate+0xb7/0xc3 [mac80211]".

That I don't know about.

johannes

--=-fpaXU1HOYDUMS54VGwC2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxjWRAAoJEKVg1VMiehFYz9EP/juJYjNrR1pFXjAkKUvw0kU+
wZkvVwrSdc/jW6gPd3D8mzFpFEomBZtAfqlBeiq7dV1KvtbA+BE2SX7LrHmmZ0uZ
L7rWOkAbMrnO2UxFzdFETEqUtg/BniQWnvIackP7xJVsq7qrmtEpYDv/w7kaQOFr
KvvVcX0jYLvi3ZZIAU7dOX+yUnDAUPhyJYp0k7sSWnzIZL3mIXwCxB/A1WZs2UUK
ODirak+CCrp+pHz1rfjglNVgTOOEy5M53y19hXJqaWv9FN2gklsX/GxvdlGrNRto
MUrxdAEdeFw4fY3pE17Olnn2zL5jNLE/rRzqPpj5PHnhvJIZ+YNRLpYj57/ErTSq
47IU4r4iJISD9y3E2t4vbXqDJUYXpJnniW/gjPrvwwSWdiAq+sbjPctFi8+vU7sh
anO9ogXAyE731NQPQ4kNFn5Ojx/E8CGLVTg17KB5OVnlmQ1sDcolO+7MHaSQcq6j
8GWN61rl5PR23n5qReMZQSQb4ttFKrPApa3O8qiRsmybUqv4USMDDWNiCOhTwq2O
raHpfRBnoMp1Ea1RhENcFAQyqJI9oZzoSvWQ2IcVXaKLZ2Kys0n+mhlazTEMF/x7
7fTnUde+hDFN+5aQdywljyFprc0qCPmloudF0sj7yCYj987ozqLfJ7xF9Ck7Cnk5
v/U5YHhqL3hu0xPjddQz
=KlJV
-----END PGP SIGNATURE-----

--=-fpaXU1HOYDUMS54VGwC2--

