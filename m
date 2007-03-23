Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49780 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422888AbXCWNpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 09:45:52 -0400
Subject: Re: [PATCH 2/4] mac80211: Add radiotap support for Monitor mode RX
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: andy@warmcat.com, linux-wireless@vger.kernel.org
In-Reply-To: <200703221918.22256.flamingice@sourmilk.net>
References: <20070320103955.600509703@warmcat.com>
	 <20070320104104.318699229@warmcat.com>
	 <1174503091.3944.42.camel@johannes.berg>
	 <200703221918.22256.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oXbKqqoN/V4cm8XCCSRU"
Date: Fri, 23 Mar 2007 14:44:24 +0100
Message-Id: <1174657464.3366.8.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oXbKqqoN/V4cm8XCCSRU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-22 at 19:18 -0400, Michael Wu wrote:

> >  1) it needs a lot more documentation on what a driver needs to do for
> >     this (for example that it should only add radiotap headers if a
> >     monitor interface was added)
> >
> Lack of documentation makes code not work?

Heh, no, but it adds new driver API.

> >  2) afaik local->monitors is increased even for soft monitor interfaces=
,
> >     thus this will really fall on its nose when the driver supports
> >     radiotap but not monitor during operation.
> >
> Yes. I noted that in December when the patch was first posted. This will =
be=20
> fixed when I post a radiotap RX patch that's actually signed off. No sign=
 off=20
> from me means it's not done and probably not tested enough if at all.

Ok, good.

johannes

--=-oXbKqqoN/V4cm8XCCSRU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGA9m3/ETPhpq3jKURAhzkAJ9zWxfV+z88hh778/0at+wVxBXFpQCffHgj
il/fdJwHL+wFNCefJPLfIv0=
=xv1j
-----END PGP SIGNATURE-----

--=-oXbKqqoN/V4cm8XCCSRU--

