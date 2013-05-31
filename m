Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:35941
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753886Ab3EaMGE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 May 2013 08:06:04 -0400
Date: Fri, 31 May 2013 08:05:54 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: cw1200 "sbus" conflicts with SPARC "sbus"
Message-ID: <20130531120553.GA31667@shaftnet.org> (sfid-20130531_140609_343566_CC2623E3)
References: <alpine.DEB.2.00.1305311127200.4645@ayla.of.borg>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
In-Reply-To: <alpine.DEB.2.00.1305311127200.4645@ayla.of.borg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 31, 2013 at 11:31:05AM +0200, Geert Uytterhoeven wrote:
>=20
> sparc64/allmodconfig:
>=20
> drivers/net/wireless/cw1200/hwio.c:51:21: error: macro "sbus_memcpy_fromi=
o" passed 4 arguments, but takes just 3
> drivers/net/wireless/cw1200/hwio.c:66:19: error: macro "sbus_memcpy_toio"=
 passed 4 arguments, but takes just 3
>=20
> http://kisskb.ellerman.id.au/kisskb/buildresult/8846508/
>=20
> At first I thought it was a bad/old implementation of a real SPARC sbus
> driver.  but it seems the two sbusses are completely unrelated.

Yikes.=20

Would it be sufficient to just rename that pair of macros, or should I=20
go and rename entire cw1200's "bus" subsystem?

Either way, I'll add this to the to-do list for the weekend.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Delray Beach, FL                          ^^ (mail/jabber) ^^
Quidquid latine dictum sit, altum viditur.

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFRqJIhPuLgii2759ARAqnIAKDuJmGl4GdnnN8FYROfmonYfRM2YACfU1oI
2WFw0GyBMlsAqdXHjnUrw40=
=SbeX
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
