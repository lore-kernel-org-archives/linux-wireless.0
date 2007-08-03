Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40319 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759639AbXHCKmT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 06:42:19 -0400
Subject: Re: mac80211 driver interface semantics
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: Ulrich Kunitz <kune@deine-taler.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>
In-Reply-To: <46B304FF.3000305@warmcat.com>
References: <46B27729.5030406@gentoo.org>
	 <20070803052935.GA12683@deine-taler.de>  <46B2E06F.4090706@warmcat.com>
	 <1186134894.4647.24.camel@johannes.berg>  <46B3032C.5040306@warmcat.com>
	 <1186137166.4647.34.camel@johannes.berg>  <46B304FF.3000305@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8Ef3KIxq7Cij5X2fk978"
Date: Fri, 03 Aug 2007 12:41:55 +0200
Message-Id: <1186137715.4647.36.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8Ef3KIxq7Cij5X2fk978
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-03 at 11:35 +0100, Andy Green wrote:

> Right, but since we marked up the skb "the integrity of the IP checksum
> is unknown", if anything wants to use the packet it should re-check it
> itself.  Won't that do?

It'll check the IP checksum anyway since we don't have hardware that
checks it as far as I know, but we want to check the FCS.

johannes

--=-8Ef3KIxq7Cij5X2fk978
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGswZz/ETPhpq3jKURAj/2AKCVve3pYIdmzjGUjdZcSc6i5lo9/gCgpGVz
hDgSsNLzfwv3y5wqk442nyY=
=9uVO
-----END PGP SIGNATURE-----

--=-8Ef3KIxq7Cij5X2fk978--

