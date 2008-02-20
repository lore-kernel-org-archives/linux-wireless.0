Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52641 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbYBTS4r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 13:56:47 -0500
Subject: Re: implementing APSD?
From: Johannes Berg <johannes@sipsolutions.net>
To: Sam Leffler <sam@errno.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Michael Renzmann <mrenzmann@madwifi.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	bruno randolf <br1@einfach.org>
In-Reply-To: <47BC76FC.7070109@errno.com>
References: <1203521087.17534.74.camel@johannes.berg>
	 <1ba2fa240802201043v1bd4fbddsc55c2230eb2a1480@mail.gmail.com>
	 <47BC76FC.7070109@errno.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XnqsqBwrR2asvqn9F9OM"
Date: Wed, 20 Feb 2008 19:56:42 +0100
Message-Id: <1203533802.17534.83.camel@johannes.berg> (sfid-20080220_185651_206823_16A85D71)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XnqsqBwrR2asvqn9F9OM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >> Also, does Atheros hardware implement that, and how? It doesn't look
> >> like Broadcom firmware implements it, and I don't really understand ho=
w
> >> one could implement it without many hardware queues, since it seems
> >> timing critical to send out the frames to the station that is using
> >> APSD.
> >>
> >>    =20
> > Don't believe it's possible to that without HW support.
> >  =20
>=20
> Sorry, this is incorrect; you can do UAPSD w/o any special h/w support.

How would you do it? As far as I understand you need to set the "more
data" bit in an ACK frame.

johannes

--=-XnqsqBwrR2asvqn9F9OM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7x36aVg1VMiehFYAQL5pA//aifrcV7LeFfnpar5vE7lf3oyzIqKIFms
U9937EkG9JET4Tr5pBxRFZaecjSYw6w0B5UHmgDuK/E7CnV2fMt4StQUc6Po85kp
d6svJ8alIMlCMqGn7tnUq+Gn3aMHw9leIIYDM59iE5g6BHg9zmazl10rcEuuH64v
3c02+AqS8s2JGY2jsEIIqI8mRllLXJJqp4T2oqYrjeqngj4UEagJ7tWuQgrhzekY
XXhTwfmHNO+LGm9iS3kcCtNvLSOsO8MRJzmXiNemlEGPVOyHkqBg/UVv9mkHz1rA
2obWC1JSSIN42QqVngZ1TgaD/5oiC7pnQUo2L/lSCO25ps38JpFrW/sbXwekHttS
8/WFGFdlf/o2AQaoJvpxMNslGAsnVyYBYRImIGDg+94hOzDlg60WgUOPyHucDevE
YukZHV0qHmeoZXAjVMc/4SigoenmCwFY3CG2XfmgyUcjLln6zzFe+7Idqm04llZW
DFr/HtwfXqqtq7McFuTxXcnnds0uCBMOpFGahb/ucdp8CC+8stzzP14i7Gq7dx9y
ELuJ5UCSFU6vgMmn59tkyfw9KwocopSTBcpKm79VZDBIzqNwtGS9CNXx8NOMG8eb
2bHR0ncTKvZ8nMbhuWNEUvGa0HXThBDF9qjmcKOaLyu7jJLQMMDEQYwHMON4DFHP
rRveajy6/GU=
=fa78
-----END PGP SIGNATURE-----

--=-XnqsqBwrR2asvqn9F9OM--

