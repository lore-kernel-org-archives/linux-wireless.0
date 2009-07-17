Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44736 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934210AbZGQITL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 04:19:11 -0400
Subject: Re: ath5k and Atheros AR242x - No scan results
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, Joel Roth <joelz@pobox.com>,
	Bob Copeland <me@bobcopeland.com>
In-Reply-To: <200907170806.23728.hs4233@mail.mn-solutions.de>
References: <20090630170916.GB5137@sprite>
	 <1247734019.19467.0.camel@johannes.local> <20090716100743.GC3867@sprite>
	 <200907170806.23728.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KY9v9rkdAtUMk5qOGeH7"
Date: Fri, 17 Jul 2009 10:18:35 +0200
Message-Id: <1247818715.1055.16.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KY9v9rkdAtUMk5qOGeH7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-17 at 08:06 +0200, Holger Schurig wrote:
> > 1. kernel and driver setup - use compat-wireless
> >
> > 2. set wireless interface to UP
> >
> > 	ifconfig <interface> up
> >
> > 3. find available networks using
> >
> > 	iw dev <interface> scan
> >  or
> > 	iwlist <interface> scan
>=20
> And maybe here the tools could emit "interface <interface> isn't=20
> up" as a more specfic error message ?!?

They do.

johannes

--=-KY9v9rkdAtUMk5qOGeH7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKYDPXAAoJEODzc/N7+Qma01IQAJrEWbwOmz6fQoAboE0wuyTi
DFWBS+2OcyP1SBzaVDreD6ZyjdTeIa9TUTLD57bik0P6AYvPhYKIbHEK18dIdhyh
xtU/JpynQxhTDnKMEr3x2cr596gmhyy/SAhCQ6aCcmZtw/M0Q61TiQcOcuxYp6Vf
xNwgLyDqDqgxfWH8CwQQP5iNEpYMCdrfG1TloW2lqscea4vJ5Xf+oZnYnrOom2ep
Ry5NDGoVRNhs5d7r6+53zddHy7gyV3pskstWipMMRuZyySJZBlvhyS+CkZ8xKYlY
1KsPs2MVtcHkUwjDTLD4gwbWlrDPGh6m62MQ7Jv0olSG0nTv+NNpuT/GeLwFTm3G
yTYsGLKP8bLDMJNlpjGkIgzNyT3ZuweWeqslTi+lYTb2SEkNxUjKAfpGNvP/W+PB
u7OPsiVXmiYucJ2RkxDqTlt5YzjAzI+nmMUbDqNB6nP7u/2kJ+elgfmRSns9a/6I
uy9dMBuR+IBtBOHfAP8cDJRFJaKGr4NeXeeTH02kwrAdoD0u9KAOOe3ETR0XJPja
g82rjDOg/O5bY6uQsaLMmfvhLHlKk5QIH3MNeEGzMD81OCyuVjsJkgVLYDWT2LpM
S6LTA43coNcIlfInFsonsIcrE1bvPE62LT1939Qpi16snRC36Z6znRCTAhIKrBrR
O+PYG0UkRFJnuUrzQADc
=jq5K
-----END PGP SIGNATURE-----

--=-KY9v9rkdAtUMk5qOGeH7--

