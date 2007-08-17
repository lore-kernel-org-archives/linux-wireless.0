Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50654 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280AbXHQKSV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2007 06:18:21 -0400
Subject: Re: [PATCHv3] mac80211: dynamic wep
From: Johannes Berg <johannes@sipsolutions.net>
To: Volker Braun <volker.braun@physik.hu-berlin.de>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Linux Wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1187288761.6462.47.camel@carrot.hep.upenn.edu>
References: <1187151162.3253.18.camel@thinkpad>
	 <200708142355.27708.flamingice@sourmilk.net>
	 <1187191455.6462.14.camel@carrot.hep.upenn.edu>
	 <200708152158.11677.flamingice@sourmilk.net>
	 <1187288761.6462.47.camel@carrot.hep.upenn.edu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Dj6bU6GUpFsfwhoZslZC"
Date: Fri, 17 Aug 2007 12:21:02 +0200
Message-Id: <1187346062.23489.154.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Dj6bU6GUpFsfwhoZslZC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-16 at 14:26 -0400, Volker Braun wrote:

> key_index & 0x80 means unicast, and the actual index is 3 =3D key_index &
> 0x03.

So that just means we have to allow bending the rules and allow
configuring a non-zero key index with pairwise WEP keys. Not too much of
a problem, I'd think.

As for the key selection changes on reception, I don't like those you've
made but the code is totally wrong even for WPA.

johannes

--=-Dj6bU6GUpFsfwhoZslZC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxXaO/ETPhpq3jKURArFSAJ9nqE1M+4xkPH1mvTkP3s2TuLAnwgCfRJ1B
Cy+BD1AZCsUCu9cSY0P9+j0=
=E293
-----END PGP SIGNATURE-----

--=-Dj6bU6GUpFsfwhoZslZC--

