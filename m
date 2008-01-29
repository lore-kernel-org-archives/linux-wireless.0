Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33294 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757888AbYA2OFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 09:05:36 -0500
Subject: Re: [PATCH 1/2] cfg80211 API for channels/bitrates, mac80211 and
	driver conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240801271649j3b337b1aq182c8fd8303d7606@mail.gmail.com> (sfid-20080128_004913_561560_8A630ACA)
References: <20080124183837.577631000@sipsolutions.net>
	 <20080124184357.839387000@sipsolutions.net>
	 <1ba2fa240801271649j3b337b1aq182c8fd8303d7606@mail.gmail.com>
	 (sfid-20080128_004913_561560_8A630ACA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EV0tNNXvQS+Y8YXwmlf0"
Date: Tue, 29 Jan 2008 15:05:17 +0100
Message-Id: <1201615517.4394.2.camel@johannes.berg> (sfid-20080129_140542_626730_651204D3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EV0tNNXvQS+Y8YXwmlf0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Also inserting few, actually drawing it unusable. You are lucky we
> like you here :)
> The question is how we handle this?. Do you want  to resubmit this
> huge patch or we fix it somehow over it...

Can you point out any bugs? It works with my iwl4965 card (and the fix
for the unfortunate bug for the scanning problem).

johannes

--=-EV0tNNXvQS+Y8YXwmlf0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR58ym6Vg1VMiehFYAQLywBAAqt7lJnRCy8F/nxhkjyJ5atMJsq9SJIoD
eJk/Mq5HjX+fHQ4OknvMUK2jMUL+xhS909Q9pbeQ3+vXBSWiT5HP0mkPF4E06yWe
SDuLl4XSkchrDbpxs71BHLFvM0cqU8dFKWpzz0geSeep3FSJv+twPI24SFIwcNHO
uzLTsP2WhRxTZhGZion0xryBaMLkNglJ5W4fFI9a6C4V5bvMzEDFsNHRunjZP4hC
SFZ92NyXV8ckbbq9D3cqVd7Z0HuoaL7nygFxIV4eE0ZVvToYftV8C3r3B74nLx4F
t+sd3uamGNokTGXA9RgRyFgmYd6DS2dEkgNnP+Rttfs7EhdQLuWRF5CKx5dP163V
1SrpZYRDYNS4JZymQTy4594XzTgzbEXDjE5D5fxjmVJfKvly0lc7+RvHdhCRYJDi
OXTWaA5IzvxG026/IlTm6eJXpHzsWDCgPqrm4X8YodgYZTpfeSBCvGxixF1Fb+pH
YlLBYmAt1DO30PccQGm6HQw21R8PKPkvd2g7kSHo2KCF3vBkbe4zMcwAiff2kADc
UlM+zyzR47zXnr9wYdc9jhcNsBs5geYMiptAt5dH4htOjU8CkEZrCQBL3VLEkd+6
geqmIJ2wO7Go7DIBkrBJO9qxsXEfRT8mBE8ij+CQfbTWJ9At6iVxLghqvLv/YdH+
TBA7YaTdIfI=
=Bsgy
-----END PGP SIGNATURE-----

--=-EV0tNNXvQS+Y8YXwmlf0--

