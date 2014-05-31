Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:52000 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382AbaEaNUE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 09:20:04 -0400
Received: by mail-pb0-f53.google.com with SMTP id md12so2649154pbc.26
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 06:20:04 -0700 (PDT)
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Subject: Re: [PATCH 0/4] wl1251 IBSS fixes
Date: Sat, 31 May 2014 15:20:00 +0200
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Pavel Machek <pavel@ucw.cz>,
	David Gnedt <david.gnedt@davizone.at>, freemangordon@abv.bg
References: <1398125395-5579-1-git-send-email-notasas@gmail.com> <201405301818.13260@pali> <CANOLnOPUrgcov5jaL-VaExk8db7P7O-RVBBm4BJq9rhBmEcjZw@mail.gmail.com>
In-Reply-To: <CANOLnOPUrgcov5jaL-VaExk8db7P7O-RVBBm4BJq9rhBmEcjZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1804769.q2hlhH2Pav";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201405311520.00427@pali> (sfid-20140531_152014_927773_6EEF0463)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1804769.q2hlhH2Pav
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 31 May 2014 15:15:20 Grazvydas Ignotas wrote:
> On Fri, May 30, 2014 at 7:18 PM, Pali Roh=C3=A1r=20
<pali.rohar@gmail.com> wrote:
> > On Saturday 10 May 2014 14:28:45 Pali Roh=C3=A1r wrote:
> >> On Friday 09 May 2014 22:03:00 Pali Roh=C3=A1r wrote:
> >> > On Friday 09 May 2014 02:21:21 Grazvydas Ignotas wrote:
> >> > > On Tue, Apr 22, 2014 at 3:09 AM, Grazvydas Ignotas
> >> >=20
> >> > <notasas@gmail.com> wrote:
> >> > > > IBSS mode is currently advertised by wl1251 driver
> >> > > > but is totally broken. First there is a disconnect
> >> > > > hack for monitor mode that was recently merged, it
> >> > > > abuses mac80211 and causes corruption in IBSS mode,
> >> > > > so I think should be reverted. Then there are
> >> > > > several cases of station-only mac80211 functions
> >> > > > called carelessly, what is also fixed.
> >> > >=20
> >> > > Ping.
> >> > > This driver is orphan and hardware carrying it is
> >> > > outdated, so acks / tested-bys are unlikely..
> >> >=20
> >> > Now I'm testing these patches on wireless-testing git
> >> > tree from year 2010 compiled against patched maemo
> >> > 2.6.28 kernel.
> >> >=20
> >> > Reason for using these historical wireless-testing
> >> > version is that this version can be compiled against
> >> > kernel which working with default Maemo system in Nokia
> >> > N900.
> >> >=20
> >> > It looks like your patches fixed some kernel oops when
> >> > iwconfig changing mode to ad-hoc.
> >>=20
> >> Looks like everything working fine except power save mode.
> >> In dmesg I see only these message:
> >>=20
> >> wl1251: ERROR Power save entry failed, giving up
> >>=20
> >> If you are OK with fact that I tested your patches with
> >> older kernel (not last upstream), you can add my
> >> Tested-by.
> >=20
> > Grazvydas: PING
>=20
> Sure I'm ok, patches seem to be already queued with your
> Tested-bys:
> https://git.kernel.org/cgit/linux/kernel/git/linville/wireles
> s-next.git/log/?h=3De5b02f649bb

OK.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1804769.q2hlhH2Pav
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlOJ1wAACgkQi/DJPQPkQ1IdwQCgu99dtnC5Mah022a1x0eQnd4f
ZLIAn1Fumlrh4rntaZJZJOeBZfLSjBBL
=QgAT
-----END PGP SIGNATURE-----

--nextPart1804769.q2hlhH2Pav--
