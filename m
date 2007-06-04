Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:8497 "EHLO annwn13.rutgers.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752695AbXFDXJW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2007 19:09:22 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: mac80211 regulatory domain confusion
Date: Mon, 4 Jun 2007 16:08:38 -0700
Cc: "Daniel Drake" <dsd@gentoo.org>, linux-wireless@vger.kernel.org
References: <4661DCC7.7090907@gentoo.org> <43e72e890706041543o493980dbwaa885739a2c8ec08@mail.gmail.com>
In-Reply-To: <43e72e890706041543o493980dbwaa885739a2c8ec08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart11813147.9bUC9xTlOH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706041608.45584.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart11813147.9bUC9xTlOH
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 04 June 2007 15:43, Luis R. Rodriguez wrote:
> On 6/2/07, Daniel Drake <dsd@gentoo.org> wrote:
> > One of the items preventing us moving zd1211rw to mac80211 is the lack
> > of regulatory domain support in zd1211rw-mac80211.
>
> Its debatable if this should be a blocker for new drivers going into
> mainline. I don't think it should be.
It's a regression from the softmac version of the driver. With the new flag=
=20
which disables default configuration of the channels to FCC, drivers can=20
configure the channels with information from the eeprom. This is effective=
=20
for the majority of wireless drivers and should be used for the time being.

=2DMichael Wu

--nextPart11813147.9bUC9xTlOH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGZJt9T3Oqt9AH4aERAt44AKCaFYduasv+5WwAfJLqNrdeiMcONwCff+8a
8wnZcUQnhKTkZnkHgWPoK5E=
=LW1e
-----END PGP SIGNATURE-----

--nextPart11813147.9bUC9xTlOH--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
