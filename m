Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57521 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752409AbbJRSd0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2015 14:33:26 -0400
Message-ID: <1445193191.31451.79.camel@decadent.org.uk> (sfid-20151018_203333_180607_4C5140EA)
Subject: Re: [PATCH] iwlwifi: Fix module firmware information for 3160
From: Ben Hutchings <ben@decadent.org.uk>
To: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-firmware@kernel.org
Date: Sun, 18 Oct 2015 19:33:11 +0100
In-Reply-To: <1445190425.31451.70.camel@decadent.org.uk>
References: <1445190425.31451.70.camel@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-+RI+Eh6TXBzsrPmg4NNR"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+RI+Eh6TXBzsrPmg4NNR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2015-10-18 at 18:47 +0100, Ben Hutchings wrote:
> IWL3160_UCODE_API_OK is no longer defined, so we end up with this
> in the module information:
>=20
> firmware:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi-3160-IWL3160_U=
CODE_API_OK.ucode
>=20
> It looks like IWL7260_UCODE_API_OK should be used instead now.
[...]

Somewhat relatedly, I noticed that iwlwifi is now requesting firmware
files that aren't yet in linux-firmware.git. =C2=A0Please can you submit
them for inclusion?

Ben.

--=20
Ben Hutchings
A free society is one where it is safe to be unpopular. - Adlai Stevenson
--=-+RI+Eh6TXBzsrPmg4NNR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAViPl5+e/yOyVhhEJAQrFdw//b2rWJHFO2Ae6AWZjG9pOIkwWp+bV1zWN
/po5EtoM4AUobiXVNzaEL0tQwN8/Yp8KcF/qhRp2XJNJPqPGcN+X7zzVwnqhWIst
99f8O5UDNiEP64t8mxclT4p6MGx9zBS33A5rQ0p1ZqBFtzbYPdt0YhGU9YvCE+xJ
HdYignrBIohmcqDJbO3KPCBcq5DCWxA2e24RXJ7itM8VO5AsRN2cEJwL3me/gZA+
NNafdRw+Z0ZJHLnfOPCWI/iMH227+zvx895+ROYw/eJp3rXinRMnnPjhA7fNo6oU
5z/jSioBCYmfRTEseeT6J+6WOxP8EbMCR8/j0pR6WnyBNble83Dmm5pr7im6LGN1
/faETds8ZcEgLldY2NjxfscinAvzNx2/pR3ZPSTZvo2XkrIzOO3E7jxc7Ond/CcB
8upMU1lvSKkbG5vCgVeGW3mRkfawesyv7lvx3nI/y43I7hM7RtAOqtmqkGjvJlZM
5xVkaD0ZmLQkntWiSI3yzw9KVjpCrqSRsk9pFetSU2Uu4VYewD+AFvxPNTweEg63
0fmVuuSm5NG5dloxH4qxvTQ2ZEMRh7QLTK5DY2gTnoJYHAKFp8w8kfrNq7rK/rpz
cLehi+MSD+PQA7iBFm4P5AL59lnBd3wIoH8FvsR+Yc8xvSo7rNMIhexZgohuoUBm
jU7Bu78+td8=
=36kr
-----END PGP SIGNATURE-----

--=-+RI+Eh6TXBzsrPmg4NNR--
