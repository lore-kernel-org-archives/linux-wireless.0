Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:24147 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab2AaTOb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 14:14:31 -0500
Date: Tue, 31 Jan 2012 20:13:38 +0100
From: Antonio Quartulli <ordex@autistici.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211/mac80211: userspace peer authorization in IBSS
Message-ID: <20120131191337.GA28554@ritirata.org> (sfid-20120131_201435_731197_83D40C06)
References: <1326806209-18753-1-git-send-email-ordex@autistici.org>
 <20120130204748.GE2493@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
In-Reply-To: <20120130204748.GE2493@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 30, 2012 at 03:47:48 -0500, John W. Linville wrote:
>   CC      net/wireless/nl80211.o
> net/wireless/nl80211.c: In function =E2=80=98nl80211_join_ibss=E2=80=99:
> net/wireless/nl80211.c:4808:6: error: =E2=80=98struct cfg80211_ibss_param=
s=E2=80=99 has no member named =E2=80=98rsn=E2=80=99
>=20
> Am I missing a patch?

no, I simply sent the wrong version of this patch. I had several copies due=
 to
the number of tests I did.


Definitely drop this patch v2 is going to be sent
Thanks.

Cheers,


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQEcBAEBAgAGBQJPKD1hAAoJEFMQTLzJFOZFD7QIAK4RpwmAcvSqv8hZHy9DCW9i
tsZYF7zclxQtftjtlo6pWqKJCjtpYWgngLbgsunsvFaC//cZYIAOg0FrpjvKmP+T
1JgxNpyWqialLaln0mKVYnQvWG+M+ZDkRJ5kHC0QKit6NbjjegUyi54lKvqFgq/q
8iJP/BAjkJY19SzyTQqW37t2f4oWeKSXKwB8JMiKtJiqE4hOqC6WWIcAQlBdOJzb
w8D0Sq8D+E4wtuDJm98+XSxumVebfP9PXVNM85j1PhK5eYjVZAn+l6vikh29A0UO
cSNqOFYHuq3v/e1Ouuz+2dIXU5gbAW2bj3pqSHobZHdRZBqUWOedgkq8BkYyMTU=
=eZxw
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
