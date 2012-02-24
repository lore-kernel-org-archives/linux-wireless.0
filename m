Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52582 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab2BXPzX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 10:55:23 -0500
Date: Fri, 24 Feb 2012 13:55:15 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2012-02-24
Message-ID: <20120224155515.GA28741@joana> (sfid-20120224_165528_469674_DBE68A8E)
References: <20120224124202.GA9908@x220>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
In-Reply-To: <20120224124202.GA9908@x220>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

* Johan Hedberg <johan.hedberg@gmail.com> [2012-02-24 14:42:02 +0200]:

> Hi John,
>=20
> Here's a pull request for the work done in the bluetooth-next tree for
> the past month or so. It's quite a big request but the vast majority of
> changes are related to the new Bluetooth Management interface and
> doesn't touch existing functionality or interfaces. We decided to
> finally enable this interface by default (the enable_mgmt module option
> is gone) which is why we spent a good amount of time fine-tuning it so
> we have an as stable API as possible (this also contributed to the large
> amount of commits in the request).
>=20
> Other than the mgmt stuff there are further fixes left over from the
> move from tasklets to workqueues (related to locking, GFP_KERNEL vs.
> GFP_ATOMIC, etc). There are also fixes to Enhanced L2CAP code which
> revealed itself to be more buggy than expected at the last Bluetooth
> UnplugFest testing event.
>=20
> Johan
>=20
> ---
>=20
> The following changes since commit ca994a36f585432458ead9133fcfe05440edbb=
7b:
>=20
>   Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/=
linville/wireless (2012-02-15 16:24:37 -0500)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/jh/bluetooth-next.git for=
-john
>=20
> for you to fetch changes up to 28b8df77449faa03b573638e089a855f8d25e0ed:
>=20
>   Bluetooth: Fix init request completion with AMP controllers (2012-02-24=
 14:02:21 +0200)

Acked-by: Gustavo F. Padovan <padovan@profusion.mobi>

Sorry about this big pull, for the next merge window we will be back the to
almost weekly pull requests. If this is going to cause any problem for you
tell us. Thanks for pulling!

	Gustavo

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPR7LjAAoJEPs3PUX4s20oeSQQAI4N4A6JmcIscN1tKpZDUQK7
0K/mQcExdfIDHcq0rjD1OtuwOl3E6V3KXFZAOI9qbTLDy+fT8WZPJaH3rO5IdyET
gON9ogtu3rrvHFuOR+/Asz8GtuohaL0xPiK6AN/eDyYY9YEAKxk24j5rK/1bfDHv
3C/nyQxi86qNQ0UvZenhVDsWAE5PcFoPzpU49BcLaETreiPDz73JQXhMmQteCsq/
7faHoRq0ZCRNdAlnnDOViNxJxnHR5DfHYywVaonsOke5+pG2z/bsj+3xx7ADa6EP
Paku/UfAxfHGxgo3SzMP2q8IcTg4lK1fD0P/PA+xedCG7UEIhv4kj1iOxweTQuvG
jZXrorSmZtUZUzLYRS4CUw7Is2JlSpLvKDdZWb3BnqMGkvmkV5KisCEKekRiFnCA
xf1e3NGI1kIPrGY+J5dyaPLcnIpHHBTKzsXKe9kUp5Ae9DlCYkABi9mmUHH/vzE1
rq6dnc51bTtzomkXL4EwgkUnX0Bf4WyORyRoSyHYMmVLMVz9vj7pEvX1vLMWQFmh
ihvrIwncsjxwhbmxwYSVCyxDYNWmu4uMmVedsA75I8yeZjV+VcOYsDSCtzPATU/A
wNdL0yWekQsTTHdNZxNojQ6e58Rv7gaUV2qg5lf/geOKtu5bnIgWzy1x59ITSW2l
sRh47wTeNvGgUnaciUIl
=Z3VL
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
