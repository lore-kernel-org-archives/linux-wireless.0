Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37188 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838AbXHFKJF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 06:09:05 -0400
Subject: Re: further plan wrt. monitor interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Ulrich Kunitz <kune@deine-taler.de>
Cc: Daniel Drake <dsd@gentoo.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070804074616.GA17144@deine-taler.de>
References: <1186178959.13315.30.camel@johannes.berg>
	 <46B3B2AD.1040509@gentoo.org>  <20070804074616.GA17144@deine-taler.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BnKyM/2GGhwHnHklUoyn"
Date: Mon, 06 Aug 2007 12:11:00 +0200
Message-Id: <1186395060.28655.52.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BnKyM/2GGhwHnHklUoyn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-08-04 at 09:46 +0200, Ulrich Kunitz wrote:

> Just my 2 cents: I wonder, how you would handle the situation,
> that a device can support two MACs in parallel?=20

I think you're not thinking about two MACs but rather two MAC addresses,
right? If so, yes, not having multiple MAC addresses was an omission in
cfg80211 that should be fixed, but I don't think it makes sense to
actually have two full MACs.

johannes

--=-BnKyM/2GGhwHnHklUoyn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGtvO0/ETPhpq3jKURAnxqAKCDGYGMvmx4Uf2ivBJxCSLG6JOqlgCgiV13
OtciDCAI/1mykVOSEr9F37I=
=IdHi
-----END PGP SIGNATURE-----

--=-BnKyM/2GGhwHnHklUoyn--

