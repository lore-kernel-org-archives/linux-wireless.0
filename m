Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39772 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbZHRIpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 04:45:54 -0400
Subject: Re: [PATCH] mac80211: Decouple fail_avg stats used by mesh from
 rate control algorithm.
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless@vger.kernel.org, andrey@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org
In-Reply-To: <1250554555-32259-1-git-send-email-javier@cozybit.com>
References: <1250554180-30646-1-git-send-email-javier@cozybit.com>
	 <1250554555-32259-1-git-send-email-javier@cozybit.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-gJ9Rf60E84WTP3asTqMO"
Date: Tue, 18 Aug 2009 10:45:51 +0200
Message-Id: <1250585151.1313.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gJ9Rf60E84WTP3asTqMO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-08-17 at 17:15 -0700, Javier Cardona wrote:
> Mesh uses the tx failure average to compute the (m)path metric.  This use=
d to
> be done inside the rate control module.  This patch breaks the dependency
> between the mesh stack and the rate control algorithm.  Mesh will now wor=
k
> independently of the chosen rate control algorithm.
>=20
> The mesh stack keeps a moving average of the average transmission losses =
for
> each mesh peer station.  If the fail average exceeds a certain threshold,=
 the
> peer link is marked as broken.

Looks good, means it can also work for ath9k etc. eventually.

johannes

--=-gJ9Rf60E84WTP3asTqMO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKimo7AAoJEODzc/N7+QmaUSQP/2VdGlF2VQxbkxpVNmygjtkd
BY9lM6E/fzcfIp8HN7rs3zoB++v5vFDxkDQThjwf0MMItdS+raUDXNG+Sc15RP5W
3ZrkxLYNUaPJf3erRkN4GwjTyh3TVDimKPpNkHpszg/1TxDeN4Zb1JeNZwn6EsIC
IILns40dQIw0bYmivUbGejZnLU1VpAz68GCMKCPbjSw0Yqhon9/78IMBi4APg8ze
q4ESBpiyMnI3bmvPndBXY6ubR81kjUEJMvGLPIolg9am7sLb6oqO9D1PLM30GaWe
eIC/LPK5gkcAIOV4S/eAARhw15QIS7LlFiJ/+T2VF4YADrfJ/NDEgljhEkRfIwkl
gxboeCI1UfCplPt8jGr/0SypBBqupMt+dlue3nZewJGZN6dSKsWOVZOKNyDe67Jq
7xhWe4w688v/dVziAcwAs1Qh1wDL3yEh4dFv0rBP6NsuUhPVs1oGtGK/gbjntftY
MdOFUdRIH/8NjeVYizByhoKzAAQUR3lDzsZ02sPp5+i/pzlbM+RvV82d/GgNSa8n
sXg/brchw9dDSHg4CuPrSms7QhDeH9m8tVLPkVw5hZWWvXnyb+5vi6oVbpgZUbpn
xoeNT0rpx9UsaDFMAiWWJz5OyEfyCtFMVzF3KED6vIwvs2S+MkF7JKWYKvkEEyIu
wBhlUoHKh44EsvvNvy43
=20wD
-----END PGP SIGNATURE-----

--=-gJ9Rf60E84WTP3asTqMO--

