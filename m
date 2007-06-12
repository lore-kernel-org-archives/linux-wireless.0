Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:60758 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754872AbXFLQqo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 12:46:44 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "Mark Powell" <Mark.Powell@csr.com>
Subject: Re: [RFC] {cfg,nl}80211 API
Date: Tue, 12 Jun 2007 09:45:30 -0700
Cc: "David Lamparter" <dl@diac24.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"David Lamparter" <lists@diac24.net>,
	"Dan Williams" <dcbw@redhat.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <20070611230434.GA13221@charon.n2.diac24.net> <20070612131458.GA6411@charon.n2.diac24.net> <F3555D2D288C3C4CBA0001C074188F119F88C3@cameurexb01.EUROPE.ROOT.PRI>
In-Reply-To: <F3555D2D288C3C4CBA0001C074188F119F88C3@cameurexb01.EUROPE.ROOT.PRI>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2087260.XKBSH4LOyk";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706120945.41154.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2087260.XKBSH4LOyk
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 12 June 2007 06:58, Mark Powell wrote:
> Very interesting. It raised a question in my mind...
> When associating to a WPA network, at what point should the driver open
> the controlled port?
> With wext/wpa_supplicant, the driver relies on knowing that the
> supplicant sets the pairwise key first and group key second and can open
> the controlled port after the second key.
>
> Can we tie down the correct behaviour more tightly in cfg80211/nl80211?
>
Shouldn't wpa_supplicant know when the connection is ready? It has support =
for=20
dormant mode, so the link can be held down by userspace until it is ready.=
=20
The driver shouldn't need to figure out when the link is ready to go up.

=2DMichael Wu

--nextPart2087260.XKBSH4LOyk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGbs21T3Oqt9AH4aERApfBAJ9EWc4KtUXRZs5fkQ7cnkFoeN1H5wCgw5B3
/+uSd3eUDjv80Soc2aocQKo=
=b4xk
-----END PGP SIGNATURE-----

--nextPart2087260.XKBSH4LOyk--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
