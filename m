Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45058 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058AbYBZPzA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 10:55:00 -0500
Subject: Re: mesh beaconing questions
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>
In-Reply-To: <1204040528.30146.44.camel@localhost.localdomain> (sfid-20080226_154432_804140_8257168D)
References: <1204034825.13162.233.camel@johannes.berg>
	 <1204040528.30146.44.camel@localhost.localdomain>
	 (sfid-20080226_154432_804140_8257168D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-W1CZW3oOJCSjktsoFxtW"
Date: Tue, 26 Feb 2008 16:54:19 +0100
Message-Id: <1204041259.13162.247.camel@johannes.berg> (sfid-20080226_155637_480160_5066A30B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-W1CZW3oOJCSjktsoFxtW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > 2. The Draft states to use either procedures 11.1.2.2 (IBSS) or 11.1.2.=
1
> > (infrastructure). It is easy to "port" 11.1.2.1 to mesh, but 11.1.2.2
> > reads like this:
>=20
> Next question, more relevant to how this affects the user:
>=20
> What's the meaningful difference between these two choices?  When would
> you use one and when would you use the other?  Should the user (ie, a
> user of something like NetworkManager) care whether a particular node is
> doing IBSS or infrastructure beacons?

Good point. I guess the relevance is that the IBSS mode requires less
power because you don't have to transmit every beacon? There's a *lot*
of text in the Draft about beaconing/synchronization and not having
TBTTs at the same time between different STAs and whatever though so
maybe there's more to it.

johannes

--=-W1CZW3oOJCSjktsoFxtW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8Q2KqVg1VMiehFYAQKIkw//ae+uxlcbGo1ZJR7oTHU81RnqoGwqGZ8e
ev2SMvLBAkMjfbe3KqnJmi0K1Rlr5+/Hde8ymeB+yERAbdaD3wj/5DHiWoxspnpY
b9MbyjBHaBPQjfjaHd+KgOpyyoIwTfNeplBN0yOs/SU2Ku316eu3BRft8cCBDVoe
GwgpJCWDeY67Y5lTtY8ws14MUGejFBoPYCS2Ie3Sxui72H4FdEJosJPcvrIadzGB
LPLRKExtk8jNiPiJnInS759DBkQ+HONBEPgsSCudW6JDAFyrOjPquhEcZRY/FEtS
jxGK5YsE0gFpHcyf++4dvoOtxBSAV2QEnaGSD9CTw1QqsZcChl0nMWiem+QVezUt
RayXUbFrIfCLBPIlO7TPTUXnWeXta0nxfSVZNzdj37RE6lHHUAf85SLa/W0RidvG
PX2irID/C9eKc6OWXWfzP7eKRn4u/HtPbR6H6T1ouoXU3QAl3LDmSR3VWM2T8UTC
HbKyDC2Zd6i7ukQTXkuv50VzocFA8UIMicuWg7pQX/9FLo95u/3MHfhXRLf0MsfL
inmlWGjTamgTW+4bERylwE2OF2pW6lOqIfvzPMIBuOl4YKh9N2Ln35KOvMSide5l
TAGhrY/JCFgyMNqt5A/Ar2gElDo7SbiJwSxXNzxp8AV89guWlCBKarQl8ZAvpKc9
yXlBoRVBLyE=
=2VT/
-----END PGP SIGNATURE-----

--=-W1CZW3oOJCSjktsoFxtW--

