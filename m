Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58544 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbXLUUno (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2007 15:43:44 -0500
Subject: Re: [PATCH] mac80211: better rate control algorithm selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	sam <sam@ravnborg.org>, Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <20071221210017.36f34fe3@morte>
References: <1198253375.16241.76.camel@johannes.berg>
	 <20071221210017.36f34fe3@morte>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-z4hmdZtqAnJqms0Q9etv"
Date: Fri, 21 Dec 2007 21:43:36 +0100
Message-Id: <1198269816.16241.82.camel@johannes.berg> (sfid-20071221_204354_488801_20269C18)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-z4hmdZtqAnJqms0Q9etv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



> What about avoiding to force any algorithm to y, and instead always build=
 a
> dummy (a few lines of code which would just set the rate to the lowest
> available) rate control algorithm into mac80211?

Why?

johannes

--=-z4hmdZtqAnJqms0Q9etv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2wld6Vg1VMiehFYAQKWPQ/7B8fy7b0e1AVh0niaqQo7Xp6OUqDaxVjF
0h8e8FSi6seWQp1vhRRhzvYobyagdpAtlMSjXxUrhfYhmX3Y23m358AF655Vo73U
nyr8OF/BdGgMXSZxSEAKjtAK1XrrB1lMU+fxqZBq3pcNlVeWvwSs2C3xm0VkqnIn
OS6b8ZgbE0n8e8iJA1t5DhDBEEy3uPVWij9Np88laDFQpnMPzq9hRyH+DDIc9PE/
l6G+hAGJE9wijdc2oLwr5vm7NqJ+RCIphGKooe48YIXj9JWTRgAHWC3MTNh+dNv/
p7RNWoiQguJNr+4gqQucyCJlzzwvYzXzNpGTCKGppjg+/IfMc5V4SA7FlOtwGaM0
U8TzPSU0WePt0GgEEyXMnyUN8hKS8ySBSv4eoV8NylC1Er1GK6Rkr978siOBPc1p
pJ6/HCk+eidgUp4NpdjUtb0ppaC6lgi34jE+amyAiXfxldTfEFQ+34uYKaj0dddz
aagiXdI/QE0I4/gwsltblGHJi9lKNzp0+3jlmCBmkJEl1XIQ+YHX+/fyeMIl6tou
aZOCZZmh3EjBB+4ZpnD9AW4N8z7LIULU6CLEUBYgF8Jt7gIXyyW39QrKxFdEXFoD
IHyFvQY0Wdyb9tEWvujvz9YB/sf69j/t/DrmxTK4EZvOdH6zp+M4J0gIBGRf+HfC
MtG8nnlxisU=
=HSLR
-----END PGP SIGNATURE-----

--=-z4hmdZtqAnJqms0Q9etv--

