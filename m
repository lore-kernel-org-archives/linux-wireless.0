Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52461 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbZELPbO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 11:31:14 -0400
Subject: Re: [PATCH 6/6] ar9170: stop data queues on channel switch
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <b6c5339f0905120829l4e78f71ep73e28d0e9118ed2e@mail.gmail.com>
References: <200905120109.09906.chunkeey@web.de>
	 <1242110389.3873.53.camel@johannes.local>
	 <b6c5339f0905120829l4e78f71ep73e28d0e9118ed2e@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tjNsabw4c5x6mU8GE+z3"
Date: Tue, 12 May 2009 17:30:27 +0200
Message-Id: <1242142227.4331.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tjNsabw4c5x6mU8GE+z3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-12 at 11:29 -0400, Bob Copeland wrote:
> On Tue, May 12, 2009 at 2:39 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >>       if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
> >> +             err =3D ar9170_stop_and_flush_queues(ar);
> >> +             if (err)
> >> +                     goto out;
> >
> > Why don't you do that in the pre-scan method?
>=20
> Will pre-scan be called once per scan or once for every channel switch?
> If the former, I think it's not the right place to flush.

The former.

johannes

--=-tjNsabw4c5x6mU8GE+z3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCZYPAAoJEODzc/N7+Qma3XEQAJgNmAnZ0FkKe5QEfygkurs4
WHMFlcGb95ljg6nHQKsd5AeH3O9fpsGI0B5mSKZDu3nEVb8NFrVilNnmgsBCRBmp
5nD1DSEP9CrNfkdVWepOalpXbhV1c8eZ48zqHgHDIGLb1yv7FWm/KJiDz3zg/BFP
WudWuQWYTBQ/pVC/CYoiYTJtKciJXUroiYczjgl6QNwO35uwDmGNuXFGBCB33dQW
aVX1iYHvb1qHCe9VMnXfO2L9cClGWV3SER9OTejHHFDabOjMc1c8+x1A5WLZkjQz
EL4wp5piBIBiLxflTNbEU/NATsQ/gPTNu8AMy88Rh8zuM41DjpH+9AFVZJMFP5pC
4xVk+RqweGo6fxhWPAxhldKiHGMVyU2IROIQUaFyH1gLRfzjmtp4TnE1yj5kA5B+
EbH1UO4B+AP9xcuO4tGWqvHVWZqHpoDFBe4M+LGnJIXzYF6HJbP+/Yp8oHZ+EqhS
5Q1PA0vwxfzsqIluzQEfUz2h5w53VZrMBteydYrpVhVLnwB1rIBwezKlrp87KeLy
DF92U3fdIrexHoNQ/ba8JSEmhvzWMvCX0mDT2CGE8lejCMa/yGrIj9p3fq7Lwzb2
upt2PLRwD/OnFkrdpmn2IbDSAE0oyy4TZD2nuHrHmtTAgKtuFmXLjF2iO6xkMqrU
35JrQKAOKo0wBNfjzZz/
=hojc
-----END PGP SIGNATURE-----

--=-tjNsabw4c5x6mU8GE+z3--

