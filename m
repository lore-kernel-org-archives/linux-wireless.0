Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38604 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbYBMMI7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 07:08:59 -0500
Subject: Re: [PATCH RFT/RFC] b43: Add QOS support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <200802122356.40865.mb@bu3sch.de>
References: <200802122205.42799.mb@bu3sch.de>
	 <200802122356.40865.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xyydpoD4jSvzzdjuwS17"
Date: Wed, 13 Feb 2008 13:08:29 +0100
Message-Id: <1202904509.8931.33.camel@johannes.berg> (sfid-20080213_120902_990700_F94A9159)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xyydpoD4jSvzzdjuwS17
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Hm, it seems there are two other variables in SHM we should probably writ=
e:
>  0x000E  EDCF Status Offset

I'll have to double-check that.

>  0x0030  TXF Current Index

I don't think we need to write that, it's used internally by the ucode
to manage the queues.

johannes

--=-xyydpoD4jSvzzdjuwS17
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7LdvKVg1VMiehFYAQIkLRAAwEqB0DVLXxIvy+Fez9gatqtdBG7Mnn1i
J1mLSfH25sFhkUZU6URiW3TxnENGnKNbH40B3E9LGCef7s0k4DNMAVIoeEaSTbTT
T0YOYYWioLtZM2AMyMDWJppXgjB1Xah9ZyWn3Z4fhDrt9JvxY/MTjn7GRis5IGUI
wxkGv/1QfejgZ33U4Q/EDV8YxtD2TwONrqLgjmw5bYBqJ+iYojD1coxMZ15acrTS
M/hbZ1VcQWCNdiW2ub0EGf2DXx152jmVBcIvVWvjFkckZ6/ot2k4bRZAl7djZJQR
X4yC3++nAkg+OMYTbjlVPMf5ZEqKZCzXMVEJKomN6DTJzMd451vCTOSezNWm5WJR
paVcVWgEfW1Gaoq94v9RtI3pFOfy7d4NuGrLn/UyFseAsXJL8tgyAOW5eKYFFdXR
c7nYTmpVH7knBqGjckNMtbH01hKaK4ern3FGB6jZQwtOUr986GKT6PWouWV/xNoZ
IW1DvkxzO2V43dYzyieiUeK8Ukzbrk68fr19KzQhPHBjVjkAMboASxaFYD1vkdzR
P7U5jbhLjvWDYhzCr6DqNfup9xZd+228n5eE482jjBpEGUwP9jUJwPP/FwLSEVKj
ROxSBRye6PRusafZ/GdcPElsQchsTxZuswSZydLYv4KbIcrPvde9EALdqR3pid0l
iOyfCOz+1Wo=
=rGtZ
-----END PGP SIGNATURE-----

--=-xyydpoD4jSvzzdjuwS17--

