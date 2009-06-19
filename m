Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:33976 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbZFSTY1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 15:24:27 -0400
Date: Fri, 19 Jun 2009 21:24:19 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Bob Copeland <me@bobcopeland.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
	san@google.com
Subject: Re: [PATCH/RFC 7/7] wl12xx: add sdio support
Message-ID: <20090619212419.2f3626d7@mjolnir.ossman.eu>
In-Reply-To: <20090618022524.GC10014@hash.localnet>
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
	<1244685780-28930-8-git-send-email-me@bobcopeland.com>
	<20090613132144.6c7783bc@mjolnir.ossman.eu>
	<87bposnmxi.fsf@litku.valot.fi>
	<20090613220908.271865cd@mjolnir.ossman.eu>
	<20090613205737.GA30439@hash.localnet>
	<20090618022524.GC10014@hash.localnet>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-10991-1245439468-0001-2"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-10991-1245439468-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Jun 2009 22:25:24 -0400
Bob Copeland <me@bobcopeland.com> wrote:

>=20
> Just to follow up now that I've tested that again: the issue is msm_wifi
> setup loads before the mmc host driver, which interferes with mounting the
> sdcard in the other slot.  There's also some platform code in the host
> driver that registers callbacks when the wifi driver is loaded, presumably
> to avoid using a timer for card detect.
>=20

I'm afraid I don't understand the problem. If you power up the card
before the MMC system has started, it should still properly find the
card and activate the wl12xx driver once things are in sync.

> Anyway, this is only compile tested but should work when we get all that
> sorted...
>=20

Do you want me to merge it?

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-10991-1245439468-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAko75ecACgkQ7b8eESbyJLigIgCgl4J32tb+w6McFY73TD03ndEF
7WQAnicYgddi9s608wR0AiFcZBkl5fTi
=/fxr
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-10991-1245439468-0001-2--
