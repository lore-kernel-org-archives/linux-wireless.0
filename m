Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:24268 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab2HZUGi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Aug 2012 16:06:38 -0400
Date: Sun, 26 Aug 2012 22:06:24 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath9k_htc: allow coexistence of IBSS with other modes
Message-ID: <20120826200624.GK7642@ritirata.org> (sfid-20120826_220641_933098_A9A67815)
References: <1345968773-17166-1-git-send-email-ordex@autistici.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4wkndigzIeYF6Hbg"
In-Reply-To: <1345968773-17166-1-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--4wkndigzIeYF6Hbg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 26, 2012 at 10:12:52AM +0200, Antonio Quartulli wrote:
> Practical tests shown that ath9k_htc devices allow an IBSS VIF to coexist=
 with
> VIF set up on other modes. This patch removes the check which block the c=
reation
> of any other VIF whenever an IBSS one is already present.
>=20
> Signed-off-by: Antonio Quartulli <ordex@autistici.org>

Johannes, please drop this patch. I'll send Patch 1/2 again because I'll al=
so
remove all the driver-specific checks for interface combinations.

Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--4wkndigzIeYF6Hbg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlA6gcAACgkQpGgxIkP9cwf/hQCggtNykcWepjH0xKQ/bHt94s+b
8RgAnA1gqKpejr5sWTOE/0BizG83HBDB
=nt8n
-----END PGP SIGNATURE-----

--4wkndigzIeYF6Hbg--
