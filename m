Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from storm.alittletooquiet.net ([67.23.28.199]:41345 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab2DBR5q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 13:57:46 -0400
Date: Mon, 2 Apr 2012 13:57:45 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>
Subject: Re: [PATCH 1/2] rtl8192de: Clean up and fix 92D cut version
 constants and macros.
Message-ID: <20120402175745.GE20611@alittletooquiet.net> (sfid-20120402_195750_381877_D1D172F9)
References: <20120402142525.GA20611@alittletooquiet.net>
 <4F79E7B9.7060504@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eRtJSFbw+EEWtPj3"
In-Reply-To: <4F79E7B9.7060504@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--eRtJSFbw+EEWtPj3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Larry,

On Mon, Apr 02, 2012 at 12:54:01PM -0500, Larry Finger wrote:
> On 04/02/2012 09:25 AM, Forest Bond wrote:
> >From: Forest Bond<forest.bond@rapidrollout.com>
> >
> >The previous definitions included both {B,C,D,E}_CUT_VERSION and
> >CHIP_92D_{C,D}_CUT with conflicting values for the C and D cut versions,
> >and literal hex values were used in the IS_92D_{C,D,E}_CUT macros.  So
> >we clean all this up and in doing so enable cut-specific code paths for
> >cuts C and D, which would not have been executed because the
> >CHIP_92D_{C,D}_CUT constants were wrong and the cut version was thus
> >recorded incorrectly.
> >
> >Signed-off-by: Forest Bond<forest.bond@rapidrollout.com>
>=20
> This patch does not apply to the wireless-testing tree. That is the
> one you are supposed to use.
>=20
> Patch #2 also fails to apply. In addition, your mailer mangled a line.

Sorry for the trouble.  I'll resend a little later this afternoon.

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.rapidrollout.com

--eRtJSFbw+EEWtPj3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk956JkACgkQRO4fQQdv5Ax73QCePaoFzvXsL+NWvrySivLkSJcB
7YwAoL7RAaObpYya1x1F7+DRm+BWgQ6j
=nBIX
-----END PGP SIGNATURE-----

--eRtJSFbw+EEWtPj3--
