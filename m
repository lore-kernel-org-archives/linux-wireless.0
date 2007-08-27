Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57813 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbXH0KsA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2007 06:48:00 -0400
Subject: Re: letting drivers choose their preferred rate scale
From: Johannes Berg <johannes@sipsolutions.net>
To: ian <ischram@telenet.be>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <46D01D57.6060806@telenet.be>
References: <46CF95F9.6090802@telenet.be>
	 <1188028962.9529.13.camel@johannes.berg>  <46D01D57.6060806@telenet.be>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mggGSwZAKk6K25n4C6vp"
Date: Mon, 27 Aug 2007 12:49:09 +0200
Message-Id: <1188211749.6756.11.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mggGSwZAKk6K25n4C6vp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-08-25 at 14:15 +0200, ian wrote:

> I reread the discussion carefully and can't find any specific
> comments on the patch which for clarity I will reproduce below.

Then I guess I remember wrong and the comment was raised in another
thread. The problem we have is that once any rate control algorithm is
loaded, it will be default for any future drivers, which is often
inappropriate. Hence, it would be great if
hw->preferred_rate_control=3D=3DNULL would indicate "use default" where
"default" would be set to "simple" to start with but also changeable.
(although the change functionality could just be not usable from
userspace for now)

johannes

--=-mggGSwZAKk6K25n4C6vp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG0qwl/ETPhpq3jKURAso7AKCS81i86fTkVw12MU2bkMQneb4LdQCePNan
uh1qH7E8+mb5Gna1lHKgL6w=
=naqd
-----END PGP SIGNATURE-----

--=-mggGSwZAKk6K25n4C6vp--

