Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:55966 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaEJM2s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2014 08:28:48 -0400
Received: by mail-wi0-f179.google.com with SMTP id bs8so2502986wib.12
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2014 05:28:47 -0700 (PDT)
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Subject: Re: [PATCH 0/4] wl1251 IBSS fixes
Date: Sat, 10 May 2014 14:28:45 +0200
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Pavel Machek <pavel@ucw.cz>,
	David Gnedt <david.gnedt@davizone.at>, freemangordon@abv.bg
References: <1398125395-5579-1-git-send-email-notasas@gmail.com> <CANOLnOO0xPH9kfZuqdbpYkdQrOFAOvL-4H0QmfAUVKCwg0ot2Q@mail.gmail.com> <201405092203.00729@pali>
In-Reply-To: <201405092203.00729@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3512066.ny6NrNLymF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201405101428.45185@pali> (sfid-20140510_142852_220658_A2C5FDBC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3512066.ny6NrNLymF
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 09 May 2014 22:03:00 Pali Roh=C3=A1r wrote:
> On Friday 09 May 2014 02:21:21 Grazvydas Ignotas wrote:
> > On Tue, Apr 22, 2014 at 3:09 AM, Grazvydas Ignotas
>=20
> <notasas@gmail.com> wrote:
> > > IBSS mode is currently advertised by wl1251 driver but is
> > > totally broken. First there is a disconnect hack for
> > > monitor mode that was recently merged, it abuses mac80211
> > > and causes corruption in IBSS mode, so I think should be
> > > reverted. Then there are several cases of station-only
> > > mac80211 functions called carelessly, what is also fixed.
> >=20
> > Ping.
> > This driver is orphan and hardware carrying it is outdated,
> > so acks / tested-bys are unlikely..
>=20
> Now I'm testing these patches on wireless-testing git tree
> from year 2010 compiled against patched maemo 2.6.28 kernel.
>=20
> Reason for using these historical wireless-testing version is
> that this version can be compiled against kernel which working
> with default Maemo system in Nokia N900.
>=20
> It looks like your patches fixed some kernel oops when
> iwconfig changing mode to ad-hoc.

Looks like everything working fine except power save mode. In=20
dmesg I see only these message:

wl1251: ERROR Power save entry failed, giving up

If you are OK with fact that I tested your patches with older=20
kernel (not last upstream), you can add my Tested-by.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3512066.ny6NrNLymF
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlNuG30ACgkQi/DJPQPkQ1IQ2QCcC1TPlhgLta3z3ReMgPXgPgKl
2QYAoI+/1DGiH3vQfma8rMuJvEMaljKt
=aWHl
-----END PGP SIGNATURE-----

--nextPart3512066.ny6NrNLymF--
