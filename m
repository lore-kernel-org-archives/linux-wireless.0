Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:42424 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab3A3Wcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 17:32:36 -0500
Date: Wed, 30 Jan 2013 17:32:32 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Pontus Fuchs <pontus.fuchs@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: RFCv3: ST-E CW1200 WLAN driver
Message-ID: <20130130223232.GA7307@shaftnet.org> (sfid-20130130_233240_322448_1D44FDAA)
References: <1357999575-12838-1-git-send-email-pizza@shaftnet.org>
 <50F3F743.1000802@gmail.com>
 <20130130190215.GA2167@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
In-Reply-To: <20130130190215.GA2167@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 30, 2013 at 02:02:16PM -0500, John W. Linville wrote:
> > I believe this driver should go into driver/net/wireless considering
> > that we have a maintainer, it has passed wifi cert and is in use in
> > production devices.
> >=20
> > I have a few patches queued up for you that fixes the last sparse
> > warnings too...
>=20
> Solomon, do you agree with this?  Are you going to repost again?

Yes, I have already moved the driver over into net/wireless in my tree,=20
plus a nontrivial pile of changes has occured since v3.  I hope to=20
post v4 by this weekend.

This is my current to-do list:

 * One final Kconfig option to eliminate
 * A possible crash (reported not three hours ago) that needs confirming
 * Hot unplug is still iffy (but better!)
 * Reworked SPI interrupt delivery completely untested
 * IBSS is still busted (haven't had time to tackle it properly)
 * Rebase against 3.8
 * Investigate adding OF bindings that can be used instead of platform_data

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFRCZ+APuLgii2759ARAnLCAJ0THqPywzyj10840UczEsMB2rMLmACg6o4l
mQ2X0bDWDm8TKD62gJMf8QE=
=OKCl
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
