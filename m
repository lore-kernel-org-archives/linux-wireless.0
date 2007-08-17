Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50026 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392AbXHQKP6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2007 06:15:58 -0400
Subject: Re: question for developers (help plzz!!)
From: Johannes Berg <johannes@sipsolutions.net>
To: maali Al Janoob <mms82@hotmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <BAY111-F25D952C7E01CC8CB5A47B2B6DF0@phx.gbl>
References: <BAY111-F25D952C7E01CC8CB5A47B2B6DF0@phx.gbl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gQ3234jZP3Zmm9rn1lCn"
Date: Fri, 17 Aug 2007 12:18:46 +0200
Message-Id: <1187345926.23489.151.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gQ3234jZP3Zmm9rn1lCn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-17 at 00:54 +0400, maali Al Janoob wrote:

> I came to know thorugh this mailing list that those two chipsets might no=
t=20
> require a firmware, and that gave me hope in finding all the 802.11=20
> functionalities in the open source driver codes,

Heh. No, that most likely just means that the stuff was in hardware or
the firmware is on a ROM.

> Aside from this, if any one is aware of any chipset that implements ALL=20
> 802.11 funcitonalities in open source software, please save me with it.

Nope. I don't think there's one, it just doesn't make sense to implement
the backoff algorithm in software because it's too timing sensitive.

johannes

--=-gQ3234jZP3Zmm9rn1lCn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxXYG/ETPhpq3jKURAhhhAJ4mol4MiVjJGOeckFUSYlkdUR81uACeLGUx
/WXIjCuBfonAQ+cBSsxrhik=
=lgLB
-----END PGP SIGNATURE-----

--=-gQ3234jZP3Zmm9rn1lCn--

