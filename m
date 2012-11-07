Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:56777 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab2KGLup (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 06:50:45 -0500
Date: Wed, 7 Nov 2012 12:50:02 +0100
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iw: add set_mcast_rate command support
Message-ID: <20121107115002.GB4243@ritirata.org> (sfid-20121107_125056_424050_60E7F2D8)
References: <1352282283-31254-1-git-send-email-ordex@autistici.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lCAWRPmW1mITcIfM"
In-Reply-To: <1352282283-31254-1-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--lCAWRPmW1mITcIfM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 07, 2012 at 10:58:03AM +0100, Antonio Quartulli wrote:
> This patch adds the support to run the set_mcast_rate() command on
> adhoc and mesh_point vifs. With this command it is possible to tune
> the bitrate to use when sending group frames. This command can be used
> even if the vifs has already joint the ibss/mesh network.
>=20
> Signed-off-by: Antonio Quartulli <ordex@autistici.org>

ops, I forgot to say that nl80211.h in the iw package must be updated to let
this change work.

Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--lCAWRPmW1mITcIfM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlCaSuoACgkQpGgxIkP9cwfNggCglxg2okQoZD22nEDDCKdEqAig
B5EAnRi5SP9awfjbu05q3PZ3qZUOAOoR
=Iq6x
-----END PGP SIGNATURE-----

--lCAWRPmW1mITcIfM--
