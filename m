Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37877 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192AbXIELVj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2007 07:21:39 -0400
Subject: Re: [PATCH] hostapd: use nl80211 instead of prism ioctls to create  interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>
In-Reply-To: <20070905025508.GH5273@jm.kir.nu>
References: <1187987850.24933.29.camel@johannes.berg>
	 <20070904011648.GX1835@jm.kir.nu> <1188913335.9942.16.camel@johannes.berg>
	 <1188917716.9942.37.camel@johannes.berg>  <20070905025508.GH5273@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2h5pK1qpPCz5P9+sjPs6"
Date: Wed, 05 Sep 2007 13:21:08 +0200
Message-Id: <1188991268.9942.93.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2h5pK1qpPCz5P9+sjPs6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-09-04 at 19:55 -0700, Jouni Malinen wrote:

> In my particular case, one of the main problems was in svn not working
> after libexpat update on Gentoo.. ;-)  This made it a bit difficult to
> fetch the correct version.

Heh :)

> At this point, we are indeed talking about quite bleeding edge stuff,
> but I'm planning on releasing hostapd 0.6.1 at some point soonish and I
> would hope that mainline Linux kernel will get enough stuff for at least
> minimal AP functionality and at that point, I do not really want to
> point people at an svn repository as the only means of getting a
> required library..

What's "soonish"? Realistically, if we keep working at this rate, I
don't expect we'll have AP functionality in before 2.6.26.

johannes

--=-2h5pK1qpPCz5P9+sjPs6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG3pEk/ETPhpq3jKURAgC+AJ9sAb+qcgW5sKwNZRAiwQL/rDELtwCePhNK
ePlXavlMfmY/AWhVRv62HHo=
=/wGi
-----END PGP SIGNATURE-----

--=-2h5pK1qpPCz5P9+sjPs6--

