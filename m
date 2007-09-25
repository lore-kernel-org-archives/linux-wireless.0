Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52689 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588AbXIYPKE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 11:10:04 -0400
Subject: Re: API to regulatory control (1)
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <923504.45912.qm@web51410.mail.re2.yahoo.com>
References: <923504.45912.qm@web51410.mail.re2.yahoo.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pyOReCxcaM+0+BwtC0Wt"
Date: Tue, 25 Sep 2007 17:11:17 +0200
Message-Id: <1190733078.18521.312.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pyOReCxcaM+0+BwtC0Wt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-09-25 at 07:43 -0700, Joerg Pommnitz wrote:
> > From what I can see, this finishes the channel restrictions API. Since
>  > none of the information in the channels list is specific to some devic=
e,
>  > it may be allocated statically.
>=20
> Well, I beg to differ. I'm working on a system were we have regulatory
> approval to use a TX power of up to 4W in certain channels. This means
> that the regulatory settings (e.g. allowed channels) are different for
> cards with amplifier and those without, even on the same machine.

Thanks for your offer for patches.

johannes

--=-pyOReCxcaM+0+BwtC0Wt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG+SUV/ETPhpq3jKURAn08AJ9e/GV9ea3q4me6k9nNKPHK8ABZMwCcDSVp
CcJUvHrkKDDqYav3MJ8vI1E=
=uDwd
-----END PGP SIGNATURE-----

--=-pyOReCxcaM+0+BwtC0Wt--

