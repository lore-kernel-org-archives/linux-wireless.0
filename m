Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:56016 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab3ABPH2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 10:07:28 -0500
Date: Wed, 2 Jan 2013 10:07:24 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 11/17] cw1200: v2: WSM (ie host-firmware) host interface
Message-ID: <20130102150724.GA3371@shaftnet.org> (sfid-20130102_160736_140828_AF24792B)
References: <1356218312-13616-1-git-send-email-pizza@shaftnet.org>
 <1356218312-13616-12-git-send-email-pizza@shaftnet.org>
 <20130102143708.GA13185@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
In-Reply-To: <20130102143708.GA13185@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 02, 2013 at 09:37:08AM -0500, Bob Copeland wrote:
> I think this should be
>=20
>     size =3D round_up(size, FWLOAD_BLOCK_SIZE);
>=20
> Otherwise it fails if size > 2 * FWLOAD_BLOCK_SIZE (it may never be,
> but it still looks wrong).

Good catch!  I'd already fixed a couple of code constructs like this.

(I'll probably have a v3 patch submission this weekend.  Contributions=20
coming out of the woodwork, plus more cleanups and improvements..)

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFQ5E0rPuLgii2759ARAsTbAJ4h2m1q4R/HJMfARvpkxI2DRa+Y5ACgjxIK
7pkKpjtbM4y17E8npGSiix4=
=WwxN
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
