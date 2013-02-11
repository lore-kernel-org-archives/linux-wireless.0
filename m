Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:52351 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759136Ab3BKTZM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 14:25:12 -0500
Date: Mon, 11 Feb 2013 14:25:10 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 01/14] cw1200: v4: low-level hardware I/O functions
Message-ID: <20130211192509.GD3123@shaftnet.org> (sfid-20130211_202517_460294_37184951)
References: <1360355527-12159-1-git-send-email-pizza@shaftnet.org>
 <1360355527-12159-2-git-send-email-pizza@shaftnet.org>
 <1360372559.13487.14.camel@joe-AO722>
 <20130211185322.GB3123@shaftnet.org>
 <1360609295.2028.44.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zS7rBR6csb6tI2e1"
In-Reply-To: <1360609295.2028.44.camel@joe-AO722>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--zS7rBR6csb6tI2e1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 11, 2013 at 11:01:35AM -0800, Joe Perches wrote:
> No.  It's just a guideline.  As far as I'm concerned,
> ignore every checkpatch message you don't agree with.

Okay, glad to hear that.  (there are still several hundred that should=20
be fixed, but mass renaming variables is a bit of a PITA..)

> Just be aware that there's a tool to help you get your
> code looking more like what most others generally consider
> "kernel style".

Yeah, I've known about checkpatch; but when it generates the better part of
800 complaints, sometimes finding the ones that matter is a little difficul=
t.

> Though when you add "new" code, stuff like
>=20
> 	> +     u32 sdio_reg_addr_17bit ;
>=20
> is untidy because of the space before the semicolon.

No argument from here.

FWIW, while I've worked quite a bit of this codebase, there are still=20
large swaths of this driver I haven't given more than a cursory glance=20
because they haven't needed debugging.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--zS7rBR6csb6tI2e1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFRGUWVPuLgii2759ARArvJAKDJGXS2RJWZ4rJxYWfap5VDs2D4LACeKW8R
Yuev0TNDLGq/y7iuy71T+M4=
=0YHe
-----END PGP SIGNATURE-----

--zS7rBR6csb6tI2e1--
