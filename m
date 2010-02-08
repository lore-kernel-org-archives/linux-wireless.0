Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59290 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab0BHQov (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 11:44:51 -0500
Subject: Re: [PATCH v3] mac80211: Retry null data frame for power save.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <8e92b4101002080513n788ef64erb33baef2393b0d54@mail.gmail.com>
References: <1265631421-2574-1-git-send-email-vnatarajan@atheros.com>
	 <201002081342.20062.chunkeey@googlemail.com>
	 <8e92b4101002080513n788ef64erb33baef2393b0d54@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tkd2MYtTlc2/6JC6T58e"
Date: Mon, 08 Feb 2010 17:24:39 +0100
Message-ID: <1265646279.3783.8.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tkd2MYtTlc2/6JC6T58e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-02-08 at 18:43 +0530, Vivek Natarajan wrote:

> > On a related issue: What about _inverting_ the flag, so it will
> > be set for devices which can't give any accurate tx_status
> > information. This has the advantage that we don't have to touch
> > other drivers?
>=20
> Shall I rename it as HW_NO_TX_ACK_REPORT?
> Looking at the other flags, they show some positively present
> feature in the hw. In those lines, HW_REPORTS_TX_ACK_STATUS
> might be better.

The positive feature flag has the advantage that we don't have to touch
any of the essentially unmaintained drivers, so I much prefer having it
that way so maintainers can enable the flag after testing etc.

johannes

--=-tkd2MYtTlc2/6JC6T58e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLcDq/AAoJEODzc/N7+QmapRYP/AwszpS7YEOeqsmMtLgxxQcH
mrO1N1eIe5CC0VW3KDjTI+FgbJqeP0iGao2FMfD/Bl+42fAAzUbBCrlRhSLC9JjD
ivYUM23TtP8XaqXMeG0bUM/0BUvZiysRdJ3jEkuTAg9wrua2hbzHAmU1dhDn5VkX
REiWt2Bj6P88szzq2dVaiN8icCH6DappqwPo4LTylrc0IeSP8/NpXCN3y0dt6LM1
tZQXgDzQ2qcU5Gvo3eQIcR2EkIwsrL8FyGV2Px76pToGUnAq3rL2wQXccvJc+E1D
IgFwrtwZ7KgLWjTWa3E/kshTklp93tGaHAsKh6an01R4IqvxhstfOCD3XYPTjLEw
QT3cA6hDC0aoMLQn3NQdNgxLqOBy4D7rnWaZlted4OEt2/tHGQhEQtjvbpD0ekb2
KZ0mSSXlS7MiNYVnDBm/lK/ckQa3icvFqZ9JkLSPyKMju2VoPfnawte27/ZJJb4P
qfSRSyQSQlN8lvidKh/OThM1Os7LS0HWR9MfsW4T9ViIqfQJOb/BPiZnBpgIvZFB
wthjMZmoho5YN9CCBE4lHaBQospp3RcszhMlQzdn32vdhaknRzb2OdO03Bc8YTlv
CWiH9sNBmYdPAGPT+hPZ0BZNMxjRVZiXcUPHBiYxBFfnWM6WWZ9FFJP9rkQvp2xa
lQGVZCqx2M7PRxvCQT9h
=OCPK
-----END PGP SIGNATURE-----

--=-tkd2MYtTlc2/6JC6T58e--

