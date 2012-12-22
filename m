Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:48017 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2LVUci (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 15:32:38 -0500
Date: Sat, 22 Dec 2012 15:32:35 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 16/17] cw1200:  Integration into the kernel build system
Message-ID: <20121222203234.GD5120@shaftnet.org> (sfid-20121222_213242_788479_2A6A33EB)
References: <1356191120-5280-1-git-send-email-pizza@shaftnet.org>
 <1356191120-5280-17-git-send-email-pizza@shaftnet.org>
 <1356207598.10280.0.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d01dLTUuW90fS44H"
In-Reply-To: <1356207598.10280.0.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--d01dLTUuW90fS44H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 22, 2012 at 09:19:58PM +0100, Johannes Berg wrote:
> > +config CW1200
> > +       tristate "CW1200 WLAN support"
> > +       select MAC80211
> > +       select CFG80211
>=20
> You should depend on mac80211/cfg80211, they in turn have dependencies
> that can't be resolved this way.

Done.

 - Solomon [Working on nuking the CW1200*DEBUG options...]
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--d01dLTUuW90fS44H
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFQ1hjiPuLgii2759ARAgraAKCgc0xo5MwB3exMiaAbNnPDa81KQgCgh9sL
rLs6jfQa1FndH5ZuJ5EwhAA=
=MU4d
-----END PGP SIGNATURE-----

--d01dLTUuW90fS44H--
