Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:55746
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932391Ab3FFKzp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 06:55:45 -0400
Date: Thu, 6 Jun 2013 06:55:39 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] cw1200: remove an unreachable goto
Message-ID: <20130606105538.GA6302@shaftnet.org> (sfid-20130606_125554_564282_C1401134)
References: <20130606105145.GC12953@debian>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
In-Reply-To: <20130606105145.GC12953@debian>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 06, 2013 at 03:51:45AM -0700, Dan Carpenter wrote:
> The "return" is correct and the unreachable "goto" line is wrong.
> I have deleted it.

A patch for this was posted earlier by Joe Perches.  It's in my tree=20
now, awaiting merging.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Delray Beach, FL                          ^^ (email/xmpp) ^^
Quidquid latine dictum sit, altum viditur.

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFRsGqqPuLgii2759ARAoblAKCkhxFHuWE0yqltP41WOMDYtY/PiQCfVDVH
s6eMr9j8F1eWgzz0l5K5ihA=
=19T3
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
