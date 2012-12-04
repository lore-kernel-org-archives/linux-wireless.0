Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:32882 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab2LDKnE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 05:43:04 -0500
Date: Tue, 4 Dec 2012 11:42:52 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [PATCH] mac80211: adapt slot time in IBSS mode
Message-ID: <20121204104252.GA25450@pandem0nium> (sfid-20121204_114308_942844_D794C43F)
References: <1354569690-23559-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <CAGRGNgXqQAnUK7_nKkwVpn1OyVMb2B8Dykbjr2X=6AJTa5OJZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
In-Reply-To: <CAGRGNgXqQAnUK7_nKkwVpn1OyVMb2B8Dykbjr2X=6AJTa5OJZg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Julian,

On Tue, Dec 04, 2012 at 10:00:33AM +1100, Julian Calaby wrote:
>=20
> I don't know if this is done elsewhere, but this code doesn't match
> the comment - there is no test for IBSS mode.

As Nicolas pointed out, this is only called in IBSS - it is part of the
ibss join/initialization code, so this is not a problem. :)

Cheers,
	Simon

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlC906wACgkQrzg/fFk7axaW5QCggIev+9nBGSXTL0ad5mAkSfDq
+OEAn0AZwtFqP17xNPbSYQoah3VLoyFm
=gMl6
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
