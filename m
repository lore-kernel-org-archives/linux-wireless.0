Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.witbe.net ([81.88.96.48]:44784 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138Ab3GWPvj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jul 2013 11:51:39 -0400
Date: Tue, 23 Jul 2013 17:49:04 +0200
From: Paul Rolland (=?UTF-8?B?44Od44O844Or44O744Ot44Op44Oz?=)
	<rol@witbe.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Richard Genoud <richard.genoud@gmail.com>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	rol@witbe.net
Subject: Re: rtl8192cu: slow path warning
Message-ID: <20130723174904.00d6fab4@tux.DEF.witbe.net> (sfid-20130723_175154_221713_49C3039E)
In-Reply-To: <51EE9BB6.8000501@lwfinger.net>
References: <20130611123814.GA9854@lnx-rg>
	<20130626142241.GA13107@lnx-rg>
	<51CB0E9C.50408@lwfinger.net>
	<CACQ1gAh+WjQZHo+_afZpzcwt1=KPM8VMBOe=YCHN_LEZu+jPNQ@mail.gmail.com>
	<20130723142907.53103aab@tux.DEF.witbe.net>
	<51EE9BB6.8000501@lwfinger.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AagHTG=sZ422WoRYeybo2nQ"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/AagHTG=sZ422WoRYeybo2nQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello Larry,

On Tue, 23 Jul 2013 10:05:26 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> The reason that patch is not in mainline is that it takes time. If you
> want to have it, you can get the official patch from=20
> http://marc.info/?l=3Dlinux-wireless&m=3D137242880222442&w=3D2, or you ne=
ed to=20
> implement kernels from the wireless-testing git tree, where it was added
> on June 28 as commit bcfb879. My original patch included the following
> note for John Linville:
>=20
> "Ideally, this patch should be pushed to the 3.10 stream; however, at
> this late time that is not possible. Please push it for 3.11 and the Cc
> to stable will get it into 3.10.X."
>=20
> As you see, it was marked with a Cc for Stable, and it will be propagated
> to 3.10 when it gets incorporated by Linus. I think I have done all that
> I can do for now.
>=20
> If you want to lobby Linus to get stuff accepted faster, that is your=20
> prerogative; however, I could not recommend that action, and I certainly
> will never do anything like that.

Neither will I... I was just wondering and asking, nothing else, as I'm
also facing this warning.=20

I'm glad to see the link you sent is presenting a patch that is the same as
the one I prepared. I'm going to use that while waiting for the patch to
hit mainline !

Thanks for replying,=20
Best,
Paul


--Sig_/AagHTG=sZ422WoRYeybo2nQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEUEARECAAYFAlHupfEACgkQZP464AVDf+CdpACWIJ2aZ7LfcAW9oFqtoH9Tv3y0
GACgmrpBsLaQR+9fyV+gnu6ujzjtHDY=
=4B0j
-----END PGP SIGNATURE-----

--Sig_/AagHTG=sZ422WoRYeybo2nQ--
