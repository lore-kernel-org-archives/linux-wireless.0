Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54720 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209AbaEIUDG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 16:03:06 -0400
Received: by mail-pd0-f178.google.com with SMTP id r10so4108349pdi.9
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2014 13:03:05 -0700 (PDT)
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Subject: Re: [PATCH 0/4] wl1251 IBSS fixes
Date: Fri, 9 May 2014 22:03:00 +0200
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Pavel Machek <pavel@ucw.cz>,
	David Gnedt <david.gnedt@davizone.at>, freemangordon@abv.bg
References: <1398125395-5579-1-git-send-email-notasas@gmail.com> <CANOLnOO0xPH9kfZuqdbpYkdQrOFAOvL-4H0QmfAUVKCwg0ot2Q@mail.gmail.com>
In-Reply-To: <CANOLnOO0xPH9kfZuqdbpYkdQrOFAOvL-4H0QmfAUVKCwg0ot2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1491444.GnbF3doq8s";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201405092203.00729@pali> (sfid-20140509_220310_998946_E57A8A1E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1491444.GnbF3doq8s
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 09 May 2014 02:21:21 Grazvydas Ignotas wrote:
> On Tue, Apr 22, 2014 at 3:09 AM, Grazvydas Ignotas=20
<notasas@gmail.com> wrote:
> > IBSS mode is currently advertised by wl1251 driver but is
> > totally broken. First there is a disconnect hack for
> > monitor mode that was recently merged, it abuses mac80211
> > and causes corruption in IBSS mode, so I think should be
> > reverted. Then there are several cases of station-only
> > mac80211 functions called carelessly, what is also fixed.
>=20
> Ping.
> This driver is orphan and hardware carrying it is outdated, so
> acks / tested-bys are unlikely..

Now I'm testing these patches on wireless-testing git tree from=20
year 2010 compiled against patched maemo 2.6.28 kernel.

Reason for using these historical wireless-testing version is=20
that this version can be compiled against kernel which working=20
with default Maemo system in Nokia N900.

It looks like your patches fixed some kernel oops when iwconfig=20
changing mode to ad-hoc.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1491444.GnbF3doq8s
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlNtNHQACgkQi/DJPQPkQ1LC3gCfTzwXWuvoO5KqTb6i1/NhHHuW
Nj0An1ytIZXsGXzAds7IebMYb+PYjDbG
=zme/
-----END PGP SIGNATURE-----

--nextPart1491444.GnbF3doq8s--
