Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54482 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbXLDQ7I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 11:59:08 -0500
Subject: Re: questions regarding removing the depencency on CONFIG_IEEE80211
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071204152538.GF19911@tuxdriver.com> (sfid-20071204_152625_949526_A1849EC3)
References: <200712041140.07516.hs4233@mail.mn-solutions.de>
	 <200712041153.24896.hs4233@mail.mn-solutions.de>
	 <1196780198.26155.17.camel@localhost.localdomain>
	 <20071204152538.GF19911@tuxdriver.com>
	 (sfid-20071204_152625_949526_A1849EC3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3/o8mIMcqThY7Z9Gw8xb"
Date: Tue, 04 Dec 2007 17:58:36 +0100
Message-Id: <1196787516.10274.24.camel@johannes.berg> (sfid-20071204_165912_058267_068D5B92)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3/o8mIMcqThY7Z9Gw8xb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> We've been talking about a new component for this kind of
> shared generic 802.11 code for some time.  In my head I call it
> "lib80211". :-)
>=20
> Maybe it is time to start it?  The header of a thousand bytes start
> with a single char... :-)

So far we've stuffed that into cfg80211 like the radiotap stuff. I'm not
against taking the radiotap stuff for example out of cfg80211 into
lib80211 though.

johannes

--=-3/o8mIMcqThY7Z9Gw8xb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR1WHO6Vg1VMiehFYAQIY9w/8Ckr9u+qIv5hEHC4i0JrcfaF0dzSstkL5
7tEOer1FijGikJZYrRQ5L+DyFHonvBk1LgOtGPL3GHMrEZob+nrjcagw7iT+BLhb
YukQ41xFqLjw0QFs/+np2JDMB0jftbNjNQpoPWAX1SOfArC5VlHodg6tvXWIiBw4
DRG00CKeGFTlnibyth2UbOG+4CR6zwp5M+KhYRVb+pwkO4OmZCfb0tboIpUWaI4Y
+Ic9wW+rXamO17J0dndbbiYFKz1JkF9iXECUaRY1DAWc7s72O+PgEsfaNo7FTYJQ
sC/QavKYARTAk084ypDI8ENPCjTp3d8QSq8JUUBFCl4BujmHM4bPI0G8fNCqvv+D
SmsoR43CgcCAO9ZpeQaotG6rLkh8tE8u+ACQ5vySfSv9DhEpmpHTHZSEr1c0RtMw
6HkIPpxAFv4aAHeZidmmnxVPff7EdIN8Js/q5c9oZslSUNeldUGPbiFljpR/T8K+
FegQlozPhUdhEZXOGAj5cgJbEkmid24su2mN36ak7pKgsF33/s9aZiTCSatV/l9v
FAizNdZ8qvi+B6NC8+5k1bB+yaa2Flzssa/6fIkTioFGyF+kKFb9XonclIh30gzV
UbhFCaIiQOyvkW4RpY5qGsuQdgqIKzWGkcbPkYt3P2gLmNIWwgVnzBdbALLrlO5L
BWYQ4YF4bd4=
=M0lu
-----END PGP SIGNATURE-----

--=-3/o8mIMcqThY7Z9Gw8xb--

