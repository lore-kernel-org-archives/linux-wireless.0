Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:56703 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625Ab3FRLp2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 07:45:28 -0400
Date: Tue, 18 Jun 2013 13:43:26 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Revert "mac80211: in IBSS use the Auth frame to trigger
 STA reinsertion"
Message-ID: <20130618114326.GB1124@ritirata.org> (sfid-20130618_134827_182549_7FF3E141)
References: <1371552313-3581-1-git-send-email-ordex@autistici.org>
 <51C043FE.6050108@lri.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
In-Reply-To: <51C043FE.6050108@lri.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 18, 2013 at 01:26:54PM +0200, Nicolas Cavallari wrote:
> On 18/06/2013 12:45, Antonio Quartulli wrote:
> > -	if (auth && !sdata->u.ibss.auth_frame_registrations) {
>=20
> The sole purpose of the auth_frame_registrations field is to be checked b=
y this code.
> The field and the code maintaining this field can be removed now.

Oh ok.
I was just looking around to understand how that field was used.

I'll send v2.

Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRwEfeAAoJEADl0hg6qKeOmKUP/1iZqlP/h+j5yWqaCPLrgx1K
SPpNyAIE48IOheCw3813AWhEBII4FQb8HhZLSaLwzyKqCHy3eaHE4Eu5gZ4y8u4t
r+qrlZyKMf/zGzOiGXaGjupQ1CAq/ephXiu6ct7EyTGA/WmrlfRHpMU0OiPCWsYf
qVTZYfLHELYLSlNj458TqO85YsNAMCZ0aic1TsNgD58p/Igs3QT1TS0ecQPDgSKy
d14/1uKmtad0ZFaNHE5naUW7Lpz076HyvMdwHfNU5ydDz2OjA9gmsRO9zulLHjFV
XkEq/w2SKYxS8rebspipqRsPYG0ojh/G7+4irA2X1Rbjqjw25m9/iQXe69ZBjR7O
rTcDTZ/Ujwpj2D4u2WI0ZAaCvewKHTaeXfbN+bmtdp/dh5BTGZc0thRHYi3oZ5ZY
nnvXaBUo+K10r5UXXObNs4XO53EJ4g+m4jkN8Y25tyf0/HwazmRvDLAooip6gp0f
W2y/aNIzo0YcE/KV8Zon8g4kuzeVbYV96WngF00S/8JYo7ay7yqfuQr4fZzI8Zob
A6lP9VOwQHoj/HbLYqj9wrOHY5l7DILada9ef10AxjY4pLVEIZ7Tx73WdghsmdPq
gUHTF7oPUj9jysjyMlDEkSbF2v4a3G0WC6y9qDldSEfrt0XYp45QNlqtrkdBuJp5
9EIP23iUURRBkz72sb0O
=K0r1
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
