Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34032 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbXJIJVF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 05:21:05 -0400
Subject: Re: Mode selection in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Mike Kershaw <dragorn@kismetwireless.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20071008143207.GB7430@drd1813.lan>
References: <200710052319.10600.linux@baker-net.org.uk>
	 <1191837339.4063.25.camel@johannes.berg>
	 <20071008143207.GB7430@drd1813.lan>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yjc1yUgEIL8RGvDlfkta"
Date: Tue, 09 Oct 2007 11:21:42 +0200
Message-Id: <1191921702.4013.15.camel@johannes.berg> (sfid-20071009_102108_661048_09A39C54)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yjc1yUgEIL8RGvDlfkta
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-10-08 at 10:32 -0400, Mike Kershaw wrote:

> I'd vote for allowing the user to set a mode - just like they're
> allowed to lock an AP association to a specific MAC, bypassing the
> hardware roaming algos.
>=20
> I've hit situations in the past where a card can get a very weak 11g
> link but a perfectly usable 11b link, and the hw did not want to drop
> back to 11b on its own.  Being able to lock to 11b only was key. =20

Actually, what you're advocating sounds like "please let me restrict the
bitrates to use" rather than "please lock me to a mode". And we need
that functionality anyway for AP mode.

johannes

--=-yjc1yUgEIL8RGvDlfkta
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwtIJaVg1VMiehFYAQJMfg//cnIb22j9xKJKfXlPpr/qpRZWJ/RY3SoM
pY3zGjSClsNBgD2FXwDVET3PDzTT2ScFY4oLBc+kBuROp+rCdmTcwrzRRZCDPkit
0Wk+oP9wYbe2qtST1Ypxzfs4QkwlE2NJQ1LLtUG/K2n/YBS2sMyRD0t4/AmnNPAs
XajHiu299zuvQR+qE+YRRXkgv769V2GuEe9noz+xm/2B1ozDFp46fCQz6KeWZ0Ac
N2DnTZAjX2IQZtoKmjU3QVjVFjKMDu5RW9RYRQHig6dYA4OYilpENzfwGhkon6tL
Aml/IDJ5bn/nSSB1VDLnUXKW2eZ57Vf69TCeBZTDFuFvDA42wOA2QPHiGret2N08
ta+vHjPC4Ipbwz7SuuN8UO/N5mQlTazHHYJ6YXFa9nsmZBiWrWkAyMsqUsl8gqjm
e34FGRgHAWo31C/89DPpWTumk99nwG0yp7jLVXgPCDH6lNMbgMJTRg6fQQKvBiq8
6nqe6SmdnvDwmNqAWF3v8BZ3yyO4V2dn8mv6AtorFywXqHTWbhJBz3eiFkfg3H6I
CBHEgCWqW/V+1/ejsmpxaGuZnXjsrnu0FqroK+bg+dKpY3+S41k/cEN9c6nFfhlA
k09syULl01wtAUz/k/Fk77Dy6wiIeZHZgvFySKjOTtUVJuct553Q45S9f7BeBlUZ
Wcr2n+wBw/I=
=x7mH
-----END PGP SIGNATURE-----

--=-yjc1yUgEIL8RGvDlfkta--

