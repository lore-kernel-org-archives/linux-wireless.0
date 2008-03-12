Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53479 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYCLOcs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 10:32:48 -0400
Subject: Re: [PATCH] PS3: gelic: ignore scan info from zero SSID beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Masakazu Mokuno <mokuno@sm.sony.co.jp>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, cbe-oss-dev@ozlabs.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Stefan Assmann <sassmann@suse.de>
In-Reply-To: <1205329351.32049.8.camel@localhost.localdomain>
References: <20080312102148.0B08.40F06B3A@sm.sony.co.jp>
	 <1205310310.6387.56.camel@johannes.berg>
	 <20080312182438.0B1F.40F06B3A@sm.sony.co.jp>
	 <1205329351.32049.8.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9W97beiP99GOcA2OHURW"
Date: Wed, 12 Mar 2008 15:31:28 +0100
Message-Id: <1205332288.6387.58.camel@johannes.berg> (sfid-20080312_143256_070309_3580CC5E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9W97beiP99GOcA2OHURW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > >           Cell 02 - Address: 00:0A:79:A5:D2:E2
> > >                     ESSID:""
> > >                     Channel:0
> > >                     Encryption key:on
> > >                     Mode:Master
> > >                     Signal level=3D100/100 =20
>=20
> Ewww.  You're 100% correct; we certainly shouldn't be sending a scan
> result like this to userspace.  Therefore:

I agree. Can you, however, tell whether the firmware has been fixed and
only skip these for broken firmware?

johannes

--=-9W97beiP99GOcA2OHURW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9fpP6Vg1VMiehFYAQK9ig/+ICwAed1c+9oes0tlhenkeQRFMPfsm/QX
5P8askZRLd9MUdIAHHRBH2ugrBRYoaGqqXhpdqPItHMnpF2hthVu44N7ULbRrYY7
Qt9VNcu6QbIqnkJIdjnCQD+FocNer20GitmeKzNR3+Lf9p8MRb4mIw5gssoD7scG
l+vv+ImcHtM5ltFhNXO545qCosvl64u/b25bnt0BJ7RiutlzqpEyZP1s90Aq7ibu
8FeCBBB+6tAlLu+XJnztcqXYM6uHCR8yqZp1MMr1vG9k6/VoCExDDkmxmoQbQu4I
ChPT4Lg+uBNgWzJCwEEld1WiUue+7CksX8BKG+zn+LeTaWcystxygfVDvz4csVq3
SbxqiOvA3EJ8tcFsqsmgFWhBDG0a9Y3lpRl6ipmRsP/5KSOQTfb1MoNbJYn4xjWu
svYNSW+/Z2Pw+GssEyFg89RCDn9hyp72FZ8wmqaj+2PSI5rykQFVYbYfepbt5PBZ
Lbya55QnoK+UDbNIUaaXmfj0c3kp88K/GIYcYn5JU1baDCJ7AWRoWoSpildYAc5b
3KGs/85W4vy0oGpuC/9yrFru0rI3tWucfW3bKrHVuzjkJQBzNmUMuMvElks+Fezf
Re/PnXU5A6+t2r9bJnComTSX+KX+EXL7YMSY33mRVE4I81mb+QsRwNYFvWCSRPDN
Uo1LUnBzaQ4=
=VDaT
-----END PGP SIGNATURE-----

--=-9W97beiP99GOcA2OHURW--

