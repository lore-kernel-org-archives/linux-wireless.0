Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39931 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbYFTHih (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 03:38:37 -0400
Subject: Re: 802.11 pccard, Agere 0x0156,0x0003?
From: Johannes Berg <johannes@sipsolutions.net>
To: Bernhard Reiter <bernhard@intevation.de>
Cc: linux-wireless@vger.kernel.org, Dave <kilroyd@googlemail.com>
In-Reply-To: <200806200935.55882.bernhard@intevation.de> (sfid-20080620_093552_914374_FDD213DC)
References: <200806181715.20516.bernhard@intevation.de>
	 <200806191023.39851.bernhard@intevation.de> <485A9A00.70700@gmail.com>
	 <200806200935.55882.bernhard@intevation.de>
	 (sfid-20080620_093552_914374_FDD213DC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NLCrjgBZ3skKrUOuxV10"
Date: Fri, 20 Jun 2008 09:37:58 +0200
Message-Id: <1213947479.8967.134.camel@johannes.berg> (sfid-20080620_093841_077534_4C5AFDC4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NLCrjgBZ3skKrUOuxV10
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Both versions can be found at <http://www.xs4all.nl/~pptp/agere>, which
> > also has patched versions for 2.6
>=20
> Cool!
> Just to make sure: This is a driver that - despite being unmaintained - s=
hould=20
> work? So could try it with 2.6.17, 2.6.24 and even newer?

Just FYI, there are patches in the queue that will most likely make all
(out-of-tree) drivers using wireless extensions break, so even if it
works now it will probably not with 2.6.27.

johannes

--=-NLCrjgBZ3skKrUOuxV10
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIW15RAAoJEKVg1VMiehFY5asQAL+fAP5Y15igPNIqE9pKrwcI
vChlxex6hRpR6DpoGF/jalBJBuZveCao3W3Sh/uf3kMq9zs8xTlR2/3ezN2RolsV
vzJOCJ38JP9RFHdwJ5pEEEcYGmum6ua0KEByZMe3peDa/8VJelCuPRe3IjoBz3CU
l0v2KiWevoB1vv0GGp6Zc/kecTDC6p29LgPSC8k+6s1QfDE6MDeGqdVTZ3m/TBuS
bqCfjIwUYBBW7gGEZCWRjt0lrAEJSjRpj8adyECKy2zK0Q9vrKuDeFpgUd2TLBJd
yDLLOivRxMS5hweG5h7dzSwk0fLmZmqXwoDoqbG68BX17AIjbNqkGaQluioxhxXQ
UaGEqlPSdzQpr4hXHwyaUItC6/iaiMXp+1kan0w+MgDJhEjMsQEPzQ7vPjw3TaM8
yFlq2gjAxmpGO7B7hJAaZs/SthwuJ/TCSpGyif7c8RbqKcddUDlv5zt6CBXSgvqO
o+tNdeXLGewPCUc74486rQnfrnuB8ghIPS0RwH2pCLHmon/sjLGBXHGhus6+E877
XHKYKUJVKgchP8BWc3H/HwgUT/zscC09gkc7ODO7X7j1vEK5T/HCkJaq0qCg/0vp
5sJM6wllLnOlpK/PF3tCCPnoClVH1JJ8MqZ9gez3hCBLxXsUBitTur2tVgpPvvcl
d5IjrPakUAO9X3pJqZ8M
=It3f
-----END PGP SIGNATURE-----

--=-NLCrjgBZ3skKrUOuxV10--

