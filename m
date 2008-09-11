Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44565 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbYIKVTs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 17:19:48 -0400
Subject: Re: wireless-testing build failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Davide Pesavento <davidepesa@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <2da21fe50809111407w23ffe5e4r1c46dc0d6907de9@mail.gmail.com> (sfid-20080911_230716_503931_D6EDD0C6)
References: <2da21fe50809111407w23ffe5e4r1c46dc0d6907de9@mail.gmail.com>
	 (sfid-20080911_230716_503931_D6EDD0C6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XU8/qwWVYzhgpv40HMll"
Date: Thu, 11 Sep 2008 23:19:08 +0200
Message-Id: <1221167948.3742.0.camel@johannes.berg> (sfid-20080911_232002_908427_5A468A49)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XU8/qwWVYzhgpv40HMll
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-11 at 23:07 +0200, Davide Pesavento wrote:
> Hi,
>=20
> after the last pull, compilation fails with the following error:
>=20
>   CC [M]  net/mac80211/mlme.o
> net/mac80211/mlme.c: In function 'ieee80211_rx_bss_info':
> net/mac80211/mlme.c:1537: error: 'struct sta_info' has no member named
> 'supp_rates'

Ah, IBSS debug, will send a fix. Sorry about that.

johannes

--=-XU8/qwWVYzhgpv40HMll
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyYtIAAoJEKVg1VMiehFY8fkQAMWpMAQaOUzrQfmK6D6hQ3kP
M1OA+QpBV82s8zw77xD4efAeWgbCpws1//YHvalz2NDHzUebKBjSqfXHWrR+66iN
8lfkTdHKKg74xvHygiBP//5uPpzGDWJy4TrSR0datIbc6U1hcsbd2rdzXlYpRoup
rRePoZCaDHpCWlYJsFGonJgVOi4seJ89wIbxuwgCXvidraB76YvR82gc731WfjhX
fsc4cE2fXyNOxRjYb8brhVXNmltOb16PpXkpLgUr786LQZ3rfkg/5EucRhEsOe+E
8yizkhy3q0GywbEXgyrEmPYRahDhEyzU2iNj6DDQk9wy4krmA5HXxIY4Qbn5s9EA
oMTcnyQzUNTuC/iNGi3NmCqlBETJzTHSS54O91XMLsXkUNn6uGWuJYZNkINT4zHO
5wc379IKAUWL/0/ChUmdUfkrMGhGALN6BIt4KF6+GkA11lbLQGObi51zgqeUkxPZ
GQKJ0jKwiWmCI/5Nkaly79F3WipiUdpjvZ6eE85ncFYZ0irZ5m/XnUvsiYxJlQUG
wKZ7JNH478oljUfF/TmP1qva07mEn+jjbeNUoq04cVfekZIziqGHzxuP5yR7dsmQ
88iG1EPvYQc/+ExTh7syFZ9Cjc9TKWK4FgnqVBzenyRbQ7pRuXHcsQcKwBTfpacP
nT3xd1KNwWPVBkamRUaj
=PjYm
-----END PGP SIGNATURE-----

--=-XU8/qwWVYzhgpv40HMll--

