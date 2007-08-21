Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60697 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbXHVJWY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2007 05:22:24 -0400
Subject: Re: Lock problem with latest b43 patches
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	wireless <linux-wireless@vger.kernel.org>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
In-Reply-To: <46C9D3F6.7020306@lwfinger.net>
References: <46C7CACC.2000000@lwfinger.net>
	 <1187609202.6090.93.camel@johannes.berg>  <46C9D3F6.7020306@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mzrcrzTf/0ddcLiR8/Hf"
Date: Tue, 21 Aug 2007 20:58:51 +0200
Message-Id: <1187722731.8435.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mzrcrzTf/0ddcLiR8/Hf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-20 at 12:48 -0500, Larry Finger wrote:

> My / and /home partitions are local, but I do have mounted NFS partitions=
. Whatever happened here=20
> has been a one-time only event, at least so far. Until it happens again, =
I'll assume that an=20
> electron got crosswise somewhere. :)

I suppose it's unlikely because it looks like there was a page fault of
a memory mapped file involved. It may be worth sending it to the NFS
maintainer anyway.

johannes

--=-mzrcrzTf/0ddcLiR8/Hf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGyzXr/ETPhpq3jKURAhWCAJ9YQde+xRCXFWjkyxL2iv9S2r6PkgCeOLRy
fzVEds4dTe3oedZm3mZI9jI=
=hK4d
-----END PGP SIGNATURE-----

--=-mzrcrzTf/0ddcLiR8/Hf--

