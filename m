Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55095 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbXHBJ6X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 05:58:23 -0400
Subject: Re: chaning mode only when interface down?
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <46B1A14B.2070808@warmcat.com>
References: <46B18B77.5020802@gmail.com>
	 <1186046044.24230.11.camel@johannes.berg>  <46B1A14B.2070808@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KixCNoVL2BBhTfvwctTU"
Date: Thu, 02 Aug 2007 11:59:47 +0200
Message-Id: <1186048787.24230.15.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KixCNoVL2BBhTfvwctTU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-02 at 10:18 +0100, Andy Green wrote:

> NM has some other things that needed fixing last time I looked at it...
> it thought it knew better than I did if a wireless interface was in
> Monitor mode that I "really wanted it" to be in Managed.

Hah yeah that is *really* annoying. Especially if you already have one
virtual managed interface and it insists on changing the other one.
Luckily, as long as it's up, it doesn't succeed :)

johannes

--=-KixCNoVL2BBhTfvwctTU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGsasT/ETPhpq3jKURArJjAJ0WmRVu5cvWkPgGOTB7vGk3/61/tACfT5Vx
e+T0GwzrQLPSFvKHNtez4zc=
=oOhU
-----END PGP SIGNATURE-----

--=-KixCNoVL2BBhTfvwctTU--

