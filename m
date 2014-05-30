Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43962 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378AbaE3QST (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 12:18:19 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so1389645wib.11
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 09:18:16 -0700 (PDT)
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Subject: Re: [PATCH 0/4] wl1251 IBSS fixes
Date: Fri, 30 May 2014 18:18:12 +0200
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Pavel Machek <pavel@ucw.cz>,
	David Gnedt <david.gnedt@davizone.at>, freemangordon@abv.bg
References: <1398125395-5579-1-git-send-email-notasas@gmail.com> <201405092203.00729@pali> <201405101428.45185@pali>
In-Reply-To: <201405101428.45185@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5030140.Y2qb0EOsWo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201405301818.13260@pali> (sfid-20140530_181822_510934_3F1398F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart5030140.Y2qb0EOsWo
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 10 May 2014 14:28:45 Pali Roh=C3=A1r wrote:
> On Friday 09 May 2014 22:03:00 Pali Roh=C3=A1r wrote:
> > On Friday 09 May 2014 02:21:21 Grazvydas Ignotas wrote:
> > > On Tue, Apr 22, 2014 at 3:09 AM, Grazvydas Ignotas
> >=20
> > <notasas@gmail.com> wrote:
> > > > IBSS mode is currently advertised by wl1251 driver but
> > > > is totally broken. First there is a disconnect hack for
> > > > monitor mode that was recently merged, it abuses
> > > > mac80211 and causes corruption in IBSS mode, so I think
> > > > should be reverted. Then there are several cases of
> > > > station-only mac80211 functions called carelessly, what
> > > > is also fixed.
> > >=20
> > > Ping.
> > > This driver is orphan and hardware carrying it is
> > > outdated, so acks / tested-bys are unlikely..
> >=20
> > Now I'm testing these patches on wireless-testing git tree
> > from year 2010 compiled against patched maemo 2.6.28 kernel.
> >=20
> > Reason for using these historical wireless-testing version
> > is that this version can be compiled against kernel which
> > working with default Maemo system in Nokia N900.
> >=20
> > It looks like your patches fixed some kernel oops when
> > iwconfig changing mode to ad-hoc.
>=20
> Looks like everything working fine except power save mode. In
> dmesg I see only these message:
>=20
> wl1251: ERROR Power save entry failed, giving up
>=20
> If you are OK with fact that I tested your patches with older
> kernel (not last upstream), you can add my Tested-by.
=20
Grazvydas: PING

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart5030140.Y2qb0EOsWo
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlOIr0UACgkQi/DJPQPkQ1Lu/ACdG8wZLkR6mxqPF1vvEl6JAplK
3AAAnjLfNwBQkikL4V9AcHvL6TeXZZAE
=eVu7
-----END PGP SIGNATURE-----

--nextPart5030140.Y2qb0EOsWo--
