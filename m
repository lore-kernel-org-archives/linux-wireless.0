Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:38886 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab2LVVWz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 16:22:55 -0500
Date: Sat, 22 Dec 2012 16:22:52 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 06/17] cw1200:  Mini-AP implementation
Message-ID: <20121222212252.GE5120@shaftnet.org> (sfid-20121222_222303_980048_651D8589)
References: <1356191120-5280-1-git-send-email-pizza@shaftnet.org>
 <1356191120-5280-7-git-send-email-pizza@shaftnet.org>
 <50D61117.8020009@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sfyO1m2EN8ZOtJL6"
In-Reply-To: <50D61117.8020009@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--sfyO1m2EN8ZOtJL6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 22, 2012 at 08:59:19PM +0100, Pontus Fuchs wrote:
> Please kill CONFIG_CW1200_*_DEBUG  and use pr_debug or other dyndbg
> interface instead. Goes for all files.

Just finished the last of that now.  (man, what a PITA..)

> Please get rid of CONFIG_CW1200_USE_STE_EXTENSIONS. The "extensions"=20
> is standard stuff anyway.

I'm currently working on auditing all places wrapped by STE_EXTENSIONS=20
and determining what to nuke (or permanently enable) on a case-by-case=20
basis.  More on this in a bit.

I'll submit a v2 RFC this evening, I think.  (Still under drivers/staging)

It's worth mentioning that I don't have any hardware to test my changes=20
out at the moment; it's all sitting on my desk at $dayjob.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--sfyO1m2EN8ZOtJL6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFQ1iSsPuLgii2759ARAomeAKDIkTH9UB3o7dwAgG5PCDt+JHiubwCdHknS
w425nh6xmZwhq8WRLpffuTI=
=+js3
-----END PGP SIGNATURE-----

--sfyO1m2EN8ZOtJL6--
