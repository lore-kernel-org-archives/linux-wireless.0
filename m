Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from storm.alittletooquiet.net ([67.23.28.199]:45103 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbZFHRxR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 13:53:17 -0400
Date: Mon, 8 Jun 2009 13:45:35 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Olivier Blin <blino@mandriva.com>
Cc: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	Greg KH <greg@kroah.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
Message-ID: <20090608174534.GD25718@alittletooquiet.net>
References: <20090414105200.GE25746@storm.local.network> <69e28c910906010935n28f69921xd589a945e982ca1@mail.gmail.com> <20090601165207.GA12481@alittletooquiet.net> <m3prdeac1t.fsf@dynamo.mandriva.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o71xDhNo7p97+qVi"
In-Reply-To: <m3prdeac1t.fsf@dynamo.mandriva.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--o71xDhNo7p97+qVi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Olivier,

On Mon, Jun 08, 2009 at 07:08:14PM +0200, Olivier Blin wrote:
> By the way, are you sure about the hook below about wpactl.c in commit
> 8f2c32b86b3ac16ba4c93bf0c2b766089644d9d1 ?
>=20
> If I do the same in vt6656, it is freezing the kernel, or causing random
> crashes. Removing the netdev priv assignation makes the driver ok.
> I don't think the wpa priv was really useful, but I fail to see where it
> was used, and why it caused the hang.
>=20
> Don't you have the same issue with vt6655?

I'm embarrassed to say that I haven't actually tested this change on real
hardware yet.  I've been trying to make changes that do not introduce any
difference in functionality, but that fix the compile errors resulting from
changing kernel APIs.

Let me restate that I'm not really a kernel hacker, so much of my work is
best-effort material.  TBH, I don't really understand the wpadev stuff, so =
it's
not clear to me why wpadev->priv can be removed.  If you have insight here =
that
I lack, I'd love to hear it.

I should be able to get some real hardware to test on sometime this week.

> BTW, I have some patches to send for vt6656, what is the proper place to
> submit them since vt6656 is not in staging for now?

I have a similar set of patches for vt6656 mostly prepared that I was going=
 to
submit to Greg.  Hopefully I can do that soon.  I suspect your patches are
roughly the same; if they look anything like the vt6655 patches, they proba=
bly
are.

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--o71xDhNo7p97+qVi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFKLU4+RO4fQQdv5AwRAusZAKDSbNZ66/ntZFIvR841LV3b+qPl8ACfc28m
O0rSdD2WdfCU7I0RSddHhWI=
=tXjL
-----END PGP SIGNATURE-----

--o71xDhNo7p97+qVi--
