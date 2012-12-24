Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:53151 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab2LXTA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Dec 2012 14:00:28 -0500
Received: from stuffed.shaftnet.org (localhost [127.0.0.1])
	by stuffed.shaftnet.org (8.14.5/8.14.5) with ESMTP id qBOJ0PIc010650
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 24 Dec 2012 14:00:25 -0500
Received: (from pizza@localhost)
	by stuffed.shaftnet.org (8.14.5/8.14.5/Submit) id qBOJ0PfM010649
	for linux-wireless@vger.kernel.org; Mon, 24 Dec 2012 14:00:25 -0500
Date: Mon, 24 Dec 2012 14:00:25 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Subject: Re: RFCv2: ST-E cw1200 driver
Message-ID: <20121224190024.GB9739@shaftnet.org> (sfid-20121224_200032_603746_0A060192)
References: <1356218312-13616-1-git-send-email-pizza@shaftnet.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
In-Reply-To: <1356218312-13616-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 22, 2012 at 06:18:15PM -0500, Solomon Peachy wrote:
> Okay, here's the second pass.  Changes from v1:

I just finised going through a code drop that Sony provided=20
(v6.1.1.B.1.10 for the Xperia go/advance/sola/U) and merged a bunch of=20
changes they made.  I've also fixed a few more checkpatch warnings.=20

The most notable change is that the "bh_thread" abombination is gone,=20
but in its place is a single high-priority workqueue. =20

This code is undergoing testing on my desk now.  Needless to say, any=20
help with testing this out would be greatly appreciated.

To that effect, if anyone's interested in tracking my tree I created a=20
git tree of my work-in-progress, built on top of compat-wireless 3.6. =20
Its initial commit was the RFCv2 code.

	git://git.shaftnet.org/compat-wireless-cw1200.git

(I don't have an SDIO-capable target capable of running anything newer=20
 than Linux 3.2 at the moment, so I need to stick with compat-wireless=20
 for now)

Anyway, back to the bit mines.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFQ2KZIPuLgii2759ARAlvYAJ0R03kcaPS1GPruxG+Gm29SuV7QaACgpNth
Tc0X4UCsTmysEqL0dtrRnsY=
=K1xz
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
