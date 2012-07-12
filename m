Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from storm.alittletooquiet.net ([67.23.28.199]:51347 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314Ab2GLBcR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 21:32:17 -0400
Date: Wed, 11 Jul 2012 21:32:16 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Anyone using rtl8192de with 2.4GHz 802.11g?
Message-ID: <20120712013216.GB14850@alittletooquiet.net> (sfid-20120712_033235_194191_13A1285A)
References: <20120712002149.GA14850@alittletooquiet.net>
 <4FFE211C.3020506@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
In-Reply-To: <4FFE211C.3020506@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Larry,

Thanks for the quick reply.

On Wed, Jul 11, 2012 at 07:58:04PM -0500, Larry Finger wrote:
> On 07/11/2012 07:21 PM, Forest Bond wrote:
> >Hi,
> >
> >The rtl8192de driver is working fine for me at 5GHz, but I am having tro=
uble
> >getting scan results for 2.4GHz 802.11g networks.  I have been doing a l=
ot of
> >debugging but am not making much progress.  I suspect the 802.11 b/g/n p=
hy is
> >not being initialized correctly, but I'm pretty far outside my domain on=
 this
> >one.
> >
> >Is anyone successfully using this driver with a 2.4GHz 802.11g network?
>=20
> I have several different models - some work better than others. What
> is the PCI ID for yours?

This is the one I have:

02:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. Device [=
10ec:8193]
02:00.1 Network controller [0280]: Realtek Semiconductor Co., Ltd. Device [=
10ec:8193] (rev 01)

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.rapidrollout.com

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk/+KSAACgkQRO4fQQdv5AztEgCgtuyYaXIhU2csChGv5PdzEBhI
YQUAoNUVOFM5cC3ziPE7ru6w/SVYn5Xv
=65MN
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
