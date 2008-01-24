Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43511 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbYAXOao (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 09:30:44 -0500
Subject: Re: [RFC] mac80211: proper short-slot handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Michael Buesch <mb@bu3sch.de>,
	Michael Wu <flamingice@sourmilk.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	bruno randolf <br1@einfach.org>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Yanbo Li <dreamfly281@gmail.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Daniel Drake <dsd@gentoo.org>
In-Reply-To: <1ba2fa240801221226ra00fd76x8724b51023717b5e@mail.gmail.com> (sfid-20080122_202631_352414_1D2D107D)
References: <1199974496.3861.80.camel@johannes.berg>
	 <200801161737.00682.IvDoorn@gmail.com>
	 <1200501699.8708.9.camel@johannes.berg>
	 <200801161751.58244.IvDoorn@gmail.com>
	 <1ba2fa240801221226ra00fd76x8724b51023717b5e@mail.gmail.com>
	 (sfid-20080122_202631_352414_1D2D107D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-G2/RaNRd9axqxH3S85Gw"
Date: Thu, 24 Jan 2008 09:38:54 +0100
Message-Id: <1201163934.3454.42.camel@johannes.berg> (sfid-20080124_143120_287879_69E6FA35)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-G2/RaNRd9axqxH3S85Gw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Finally I got to test this but somehow I'm not getting any changed bit
> set except
> association one. I'm still not sure if this is problem of iwl driver or m=
ac80211
> If anybody tested please let me know

Hmm. And you're positive the network you were on supports short slot?
But looking closely at the code does reveal a bug, short slot should be
supported even in absence of an ERP IE.

johannes

--=-G2/RaNRd9axqxH3S85Gw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR5hOnaVg1VMiehFYAQLzTA//d2RJDs8l4z1KL/GGXSUi/hqhsCaHQLir
UkUutt4Bfddwtdgt1ZBCQYtgVVauxJThR4qoRp1J2UUadexjBw+dp0o6BilHKIk8
ML8kXHWSqLOHPtQ81Pitl+GLlconaWMBdOgOqeDR+YSs2+Y0FaOLAwRQDdD4NwZl
a+XQFs3dvdhGue2c2MHMYkGJPX2UYqP/4abwgAok02ib9ykzWZ9JiVcO2qw4/xv4
iqUwprjdh53kn6xS8TAa656W5AfIil+DgRcrupT5V+zXFSPpu7uofgbHG5zTuB9R
EXtBZrMcmue5xX0YE8snt20PzfzheVAqJRZ6xW66K++cf6lviV0kKdFeShk+MX48
cXvvHCiCxLFFjLbkOoWRk83RhXo8Bt3oqDePApws25nKrZXIk6bNtwjKF6S0I87F
eSGVX7E2FMKhuqLWh3bHx769ZWaqFCHkindlPYGjsVipHrGp0azFZ3jiJjqnUDh3
9dGRVZ5k4Lk1FClIhUV9Il6rTVzbfG9LQGH60RolXppY4AQmE6IB5YaZFfxk2H1f
PqxD1ZFtHz1a+bC4b5eJgMie22BKVjQ831NbeKwi3fbeyxprelt57WREAlJfJiri
B8jDxnfPtHKFLVcGCd9elunvdrRFTfy1CQdo3aIxHMBCjORzBZSeK2ZZyQ9pfzph
6Uo5xrk/Jo8=
=zbb+
-----END PGP SIGNATURE-----

--=-G2/RaNRd9axqxH3S85Gw--

