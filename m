Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:52290 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758040Ab3BNP6o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 10:58:44 -0500
Date: Thu, 14 Feb 2013 10:58:41 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: RFCv4: ST-E CW1100/1200 WLAN driver
Message-ID: <20130214155840.GA3232@shaftnet.org> (sfid-20130214_165848_061243_B811F9BD)
References: <1360355527-12159-1-git-send-email-pizza@shaftnet.org>
 <1360355765.29851.29.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
In-Reply-To: <1360355765.29851.29.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 08, 2013 at 09:36:05PM +0100, Johannes Berg wrote:
> > There are still a couple bits of code present for older (<2.6.36 and <3=
=2E2)=20
> > kernels, which I will strip out for inclusion in compat-drivers once=20
> > this is mainlined.  (Is there a better process I should follow here?)
>=20
> You should probably just submit it without those bits for the
> wireless-next tree and then to the relevant compat-drivers patches as
> needed.

I'm now working on silencing checkpatch's complaints (about 3/4 done=20
now); most of them revolve around the use of CamelCase variable names=20
all over the place.  In the process I'm doing other low-risk=20
opportunistic cleanups.

Once I'm done with that, I'll prepare another submission without the=20
backwards compability bits, rebased against wireless-next.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFRHQmwPuLgii2759ARAmaLAJ4zoj4s+7swmu5MjGwkbwG1fm5rsACfR8h8
BBh1YN4KcIOQFZmuEk6GFNY=
=RWeV
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
