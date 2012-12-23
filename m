Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:35530 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab2LWMri (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2012 07:47:38 -0500
Date: Sun, 23 Dec 2012 07:47:35 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: Bartosz Markowski <markowski.bartosz@gmail.com>
Cc: Pontus Fuchs <pontus.fuchs@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 06/17] cw1200: Mini-AP implementation
Message-ID: <20121223124734.GB29607@shaftnet.org> (sfid-20121223_134746_405341_2ECE7CA0)
References: <1356191120-5280-1-git-send-email-pizza@shaftnet.org>
 <1356191120-5280-7-git-send-email-pizza@shaftnet.org>
 <50D61117.8020009@gmail.com>
 <CAM8CFPgJu5CR9tU_mMw1_0yDUEj-dLk2G+6W91W1-H4LMa+BUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eAbsdosE1cNLO4uF"
In-Reply-To: <CAM8CFPgJu5CR9tU_mMw1_0yDUEj-dLk2G+6W91W1-H4LMa+BUw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--eAbsdosE1cNLO4uF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 22, 2012 at 09:41:26PM +0100, Bartosz Markowski wrote:
> Depends on air condition a single NULL packet can be confirmed even after
> BSS loss evt what leads to connection_loss_work cancellation. We queued f=
ew
> NULL frames (5 if I good remember and fired them to confim BSS loss to ma=
ke
> sure AP is really gone).

I've noticed the LMAC spits out BSS_LOST events all the time, almost=20
alwas followed immediately with BSS_REGAINED events.

Is there something that the LMAC is doing that causes it to miss 20 (!)=20
beacons in a row?  Otherwise it speaks rather poorly about the LMAC's=20
internal timekeeping.  :)

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--eAbsdosE1cNLO4uF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFQ1v1mPuLgii2759ARAhBzAKD1j/VdYNZKu42/w8zMLw+ppFaW7wCgqUyD
IeCAI3n7GqtUs/nv4+PUw58=
=x+El
-----END PGP SIGNATURE-----

--eAbsdosE1cNLO4uF--
