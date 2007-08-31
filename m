Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45960 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662AbXHaKNT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 06:13:19 -0400
Subject: Re: bad mac80211/softmac/xfs interaction
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200708301953.51926.mb@bu3sch.de>
References: <1188397301.8048.2.camel@johannes.berg>
	 <200708301953.51926.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Y9KcVeuY7BTsSWmD2wH0"
Date: Fri, 31 Aug 2007 12:14:33 +0200
Message-Id: <1188555273.7585.23.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Y9KcVeuY7BTsSWmD2wH0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-30 at 19:53 +0200, Michael Buesch wrote:

> related to this one?
> http://bugzilla.kernel.org/show_bug.cgi?id=3D8937

Hm. Hard to tell. I can hack up something that puts a big
WARN_ON(freeing scheduled work struct) if you like. I can easily trigger
this bug.

johannes

--=-Y9KcVeuY7BTsSWmD2wH0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1+oJ/ETPhpq3jKURAokcAJ49l+yzoSUu6/n1malOXj3NMglpIwCgqhzw
F6u7tJyoYCH/6prFs7uT+Vk=
=lKKH
-----END PGP SIGNATURE-----

--=-Y9KcVeuY7BTsSWmD2wH0--

