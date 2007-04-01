Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52437 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189AbXDAITf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Apr 2007 04:19:35 -0400
Subject: Re: mac80211 does not support WPA when used with wext
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: dragoran dragoran <drago01@gmail.com>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	John Linville <linville@redhat.com>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <200703311700.52792.flamingice@sourmilk.net>
References: <460E2B8C.4030002@gmail.com>
	 <200703311503.53445.flamingice@sourmilk.net>
	 <f6ca9fed0703311256m1b14ec35p836a62de532dd804@mail.gmail.com>
	 <200703311700.52792.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZSdmfCy1cTl26TGV3eEC"
Date: Sun, 01 Apr 2007 10:18:43 +0200
Message-Id: <1175415523.23438.55.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZSdmfCy1cTl26TGV3eEC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-03-31 at 17:00 -0400, Michael Wu wrote:

> No, this has nothing to do with that. The following patch should address =
that=20
> issue, but my copy of networkmanager already does WPA fine so I can't say=
 for=20
> sure whether it will help or not. A quick look through the networkmanager=
=20
> code seems to suggest this will work.

My NM also does WPA but fails (see previous thread), haven't gotten
around to debugging it yet. But it definitely tries WPA. Then, however,
when I decline to give it a key because I want to use wpa_supplicant
manually, it tells me that my card can't do WPA (encryption not
supported or something)...

johannes

--=-ZSdmfCy1cTl26TGV3eEC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGD2rj/ETPhpq3jKURAtN8AKCNvPFcY5VT9sS4eNpFNH3a2YoD6wCghdIw
uppPnOWA7+7DPD4vsL+Zes0=
=pfNQ
-----END PGP SIGNATURE-----

--=-ZSdmfCy1cTl26TGV3eEC--

