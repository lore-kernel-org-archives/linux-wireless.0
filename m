Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55574 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933857AbXCKRdu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Mar 2007 13:33:50 -0400
Subject: Re: [PATCH] remove dead header junk
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jkm@devicescape.com>
In-Reply-To: <200703110151.43475.flamingice@sourmilk.net>
References: <1173112674.6131.93.camel@johannes.berg>
	 <200703110151.43475.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-c1AOnRdmKzh9X7oM/V2q"
Date: Sun, 11 Mar 2007 18:33:56 +0100
Message-Id: <1173634436.3382.6.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-c1AOnRdmKzh9X7oM/V2q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-03-11 at 01:51 -0500, Michael Wu wrote:
> On Monday 05 March 2007 11:37, Johannes Berg wrote:
> > -	PRISM2_HOSTAPD_SET_ASSOC_AP_ADDR =3D 11,
> FYI, this breaks the compile of the devicescape driver for hostap.

Ugh, why's that? That call isn't implemented so this breakage is
probably a good thing ;)

johannes

--=-c1AOnRdmKzh9X7oM/V2q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF9D2E/ETPhpq3jKURAuYAAKCKl8Q6vSqCKPyLubMB0DRx0fhLpgCfVyXl
llBlrtIBumG78dlq4MUnPBI=
=Qosl
-----END PGP SIGNATURE-----

--=-c1AOnRdmKzh9X7oM/V2q--

