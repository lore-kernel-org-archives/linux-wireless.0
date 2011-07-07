Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from storm.alittletooquiet.net ([67.23.28.199]:46216 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab1GGWxW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2011 18:53:22 -0400
Date: Thu, 7 Jul 2011 18:53:21 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath9k_htc fails to initialize TL-WN721N with compat-wireless
 3.0-rc4-1
Message-ID: <20110707225321.GG28091@alittletooquiet.net> (sfid-20110708_005325_691359_FC8F3C0E)
References: <CAD2nsn0-FQuo7bT3nb3jJLDe1XwbMw4J-Gr8qFkY5zzY1O-vxg@mail.gmail.com>
 <20110705143029.GA28091@alittletooquiet.net>
 <CAD2nsn1r7cW7KZ2W_z+SURHRpaTvuC_bd42yN9S+y9JrYMkS4w@mail.gmail.com>
 <20110705172022.GB28091@alittletooquiet.net>
 <20110706023943.GA11178@vmraj-lnx.users.atheros.com>
 <CAD2nsn0HFgm6Puuzuy4gghdDvpb05WaQtETS4=mfQ63mFzo--Q@mail.gmail.com>
 <20110706182937.GE28091@alittletooquiet.net>
 <CAD2nsn3x5sfhTuzH66myCF0P2PyHoX+pqVkYgWC5ogssPdHsqw@mail.gmail.com>
 <CAD2nsn03zdg16O3xcAOGRunYm4NG5PqO=1ht4kx39fAXbSpV5A@mail.gmail.com>
 <CAD2nsn3krB2MZYewRtJpFikUu9079jXXMabz90z6Zc7kfAeELw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6lXr1rPCNTf1w0X8"
In-Reply-To: <CAD2nsn3krB2MZYewRtJpFikUu9079jXXMabz90z6Zc7kfAeELw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--6lXr1rPCNTf1w0X8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi shafi,

On Thu, Jul 07, 2011 at 03:23:50AM -0400, Mohammed Shafi wrote:
> attached a reverting patch for LED, did a basic test and looks fine.
> need to investigate in this for backporting.  we have not tested in
> 2.6.24 kernel

Yes, this seems to fix things.  I can bring the interface up now and get
scanning results.  I will test further and let you know how things go.

Thanks again for your help.

-Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.rapidrollout.com

--6lXr1rPCNTf1w0X8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk4WOOEACgkQRO4fQQdv5AxHWgCcCMFdHTo389d6SW9Kp4MF8Ux2
MiEAoL6TIP+qdzRTqGspgOQI5JQeAMk9
=HFBX
-----END PGP SIGNATURE-----

--6lXr1rPCNTf1w0X8--
