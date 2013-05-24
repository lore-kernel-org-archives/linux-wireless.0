Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rrcs-24-73-230-86.se.biz.rr.com ([24.73.230.86]:38405 "EHLO
	stuffed.shaftnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229Ab3EXXlm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 19:41:42 -0400
Date: Fri, 24 May 2013 19:36:13 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ST-E CW1200 driver (v6)
Message-ID: <20130524233612.GA5079@shaftnet.org> (sfid-20130525_014145_247216_6B542624)
References: <1367090847-11937-1-git-send-email-pizza@shaftnet.org>
 <20130524175001.GB2175@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
In-Reply-To: <20130524175001.GB2175@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 24, 2013 at 01:50:02PM -0400, John W. Linville wrote:
> I'm sorry, but this just doesn't build on the current wireless-next
> and I don't have enough time ATM to chase-down all the fix-ups.

I've already fixed it up against 3.10-rc, but I'll check it against=20
wireless-next and repost once it builds cleanly.

> Could you work that out and repost?  Please also check the Kconfig
> stuff, as that still seemed to be broken...

So it is.  Serves me right for not actually doing an in-tree build and=20
relying on checkpatch's output.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Delray Beach, FL                       ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFRn/lsPuLgii2759ARAr3oAKCSIXxj0/wkarpbSKZgZ7uM85I8MgCdFy+z
x1dHM9D0sBwl1vJyO8H+LDI=
=VJd6
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
