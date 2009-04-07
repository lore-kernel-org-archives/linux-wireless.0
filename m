Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51050 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761311AbZDGUyJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 16:54:09 -0400
Subject: Re: [PATCH v2 3/5] mac80211: check if HT40+/- is allowed before
 sending assoc
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890904071344v30c663c5sb50937ce54e1b92b@mail.gmail.com> (sfid-20090407_224440_415119_E05566A5)
References: <1239048958-11775-1-git-send-email-lrodriguez@atheros.com>
	 <1239048958-11775-4-git-send-email-lrodriguez@atheros.com>
	 <1239099071.22453.12.camel@johannes.local> <20090407162345.GC5758@tesla>
	 <1239131370.6199.0.camel@johannes.local>
	 <43e72e890904071338q4f9667ddo2958067c57442888@mail.gmail.com>
	 <1239136863.7475.66.camel@johannes.local>
	 <43e72e890904071344v30c663c5sb50937ce54e1b92b@mail.gmail.com>
	 (sfid-20090407_224440_415119_E05566A5)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-E7JWZTxe2aWuyojKuNrg"
Date: Tue, 07 Apr 2009 22:53:34 +0200
Message-Id: <1239137614.8456.10.camel@johannes.local> (sfid-20090407_225413_985708_4405C3D8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-E7JWZTxe2aWuyojKuNrg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-07 at 13:44 -0700, Luis R. Rodriguez wrote:

> >> That's what was there or what I added in my patches.
> >
> > Indeed, it's already there. I guess I got confused, sorry for the noise=
.
>=20
> hehe, np, are these ACKed now then?

Yeah seems fine to me -- I'm happy as long as the userspace interface
doesn't include all this :)

johannes

--=-E7JWZTxe2aWuyojKuNrg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ271LAAoJEKVg1VMiehFYQasP/Aip/cil0vOK7C1L2oe+z7C7
KjEmn7cNMT/fBXwpmFM5hHJ3pDeDe1wbPmyIGg8whAFo9mkO0n72FwbBxr9uiDIv
I4GY6Q0PTu4t/PfMjvCxECbLt6CtfMN3T1bv9syrJnIInolZ+XshaB+DFKh/HqEM
qZX73lyvJkshMpOli82nOJ9cCLRhYDzgRAF8ED2ab2LZk75gTf13VRRNBK948TR3
73sQ007A0XhDNxaiVNXrJrKdH6X9h61I5MH5RPgbyYiJBPS/4iY2M9KHi86cVyvn
trjhAux9oqXqsVw8A06ptxujm2DTwQRJUtfwBq4wB0soRQlFi8onagXbHkmyx7zj
+B4MwQ5LLuGI7JDAbB9D+RgHr/9P+HXbZyoJ5tbT2CiZvf0XE2zdiOy49FIjqQlR
1BI3ixejYCg3Pg8/SWs2LhV77Ky7cPXngl+l4qBJpIsgV/osjR4QbNevnCrMF8D0
xQHME3Pb0UvHJ4aGp6NVkcfnt+kWGq6pfcxCz9mXSypQPQZcORA1zvYdnb40Dhhn
HPIFLL5mH8pxbDBgtdimjtBpELziZsm8vA1bAQT7VjZKNdFvdES9EdDhd4/igIaA
DMNQOsXviEzGO7T6d36rZxGC7/YuySAQvXbPWeZUCaIU1zUwN7wju2PxbyrJnCEK
KjanUmemeqb0l1qXwxIY
=dQHQ
-----END PGP SIGNATURE-----

--=-E7JWZTxe2aWuyojKuNrg--

