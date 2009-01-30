Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55929 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560AbZA3Ui0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 15:38:26 -0500
Subject: Re: [PATCH v6] mac80211: do not TX injected frames when not allowed
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Jouni.Malinen@atheros.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1233335309-28099-1-git-send-email-lrodriguez@atheros.com>
References: <1233335309-28099-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lqkBMq2a9IoOaoVPe0nj"
Date: Fri, 30 Jan 2009 21:38:20 +0100
Message-Id: <1233347900.4070.4.camel@johannes.local> (sfid-20090130_213828_694086_A3212536)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lqkBMq2a9IoOaoVPe0nj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-30 at 09:08 -0800, Luis R. Rodriguez wrote:
> Monitor mode is able to TX by using injected frames. We should
> not allow injected frames to be sent unless allowed by regulatory
> rules. Since AP mode uses a monitor interfaces to transmit
> management frames we have to take care to not break AP mode as
> well while resolving this. We can deal with this by allowing compliant
> APs solutions to inform mac80211 if their monitor interface is
> intended to be used for an AP by setting a cfg80211 flag for the
> monitor interface. hostapd, for example, currently does its own
> checks to ensure AP mode is not used on channels which require radar
> detection. Once such solutions are available it can can add this
> flag for monitor interfaces.
>=20
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>=20
> This v6 leaves the AP flag out and removes the unused sdata..

Yeah, let's go with this until hostapd is fixed anyway.

johannes

--=-lqkBMq2a9IoOaoVPe0nj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJg2U5AAoJEKVg1VMiehFYJasP/3MX1htySW/E1FQjGGDpPjbg
YcKaF6YsIuE/Yo9PwhKs+KRC+sgzZpXfQR9MrT43hViNhivLHziCu0Hez1Tk4UdF
1VE0uzIEM2epSgn9LzB6lbxU/8Wap+JQK1kWmf4oGT3GYVG1S4UuQeCGt5b7CYdF
BpJR0UBpz+W1DaAdzW3r4iCBSrMgajmPIFk7STWqo0QL2dZZ0R2o4ghbl0mF9CF2
Cdf6I7LbdplkH24R7JmM7Tv8UDTJ/AQ/nkpKGUSwJnNRXmP8lznHZQiWLbM6Ha00
guDZAM6t6reNsazg6X6pm0eqXW4DKi8ZV+dDwc5AglA5EaMg1AR7CQuCvLejsd2c
5i2WIDa22Da1iKteRoxVdprZfZWNwtC/NiO9p2jhwjZKPPmaqSaKeiURCYtbo9QE
FOv9rQ6Gen9IIHdM01vjQ8Y6M/kfkUZohIi5ZqNlLdeRBLr0CphmE62iywIjCUmO
hbJUfi1RjbKHjQw6iP34z65ScsSKsiCmBi2t4/gUVsnqR6XjWYseJ0diHGXq4v7o
n6/n5Vg+JMv60xy8I1oAiM3pG638eheHBvS5BTR0mv/9IKbyOFHGIEq/YdxxUHTA
Av/FOJPd/PaB6/wLmfQk5mtfNaeA2Xt+AOPloTVoJKqy4u5ci1VsNhHaSAplGX1d
H3tS6b+A5grbl36FuPwP
=H+mO
-----END PGP SIGNATURE-----

--=-lqkBMq2a9IoOaoVPe0nj--

