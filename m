Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from storm.alittletooquiet.net ([67.23.28.199]:40270 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab1GKPE6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 11:04:58 -0400
Date: Mon, 11 Jul 2011 11:04:57 -0400
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
Message-ID: <20110711150457.GL28091@alittletooquiet.net> (sfid-20110711_170500_973428_3814418E)
References: <20110705172022.GB28091@alittletooquiet.net>
 <20110706023943.GA11178@vmraj-lnx.users.atheros.com>
 <CAD2nsn0HFgm6Puuzuy4gghdDvpb05WaQtETS4=mfQ63mFzo--Q@mail.gmail.com>
 <20110706182937.GE28091@alittletooquiet.net>
 <CAD2nsn3x5sfhTuzH66myCF0P2PyHoX+pqVkYgWC5ogssPdHsqw@mail.gmail.com>
 <CAD2nsn03zdg16O3xcAOGRunYm4NG5PqO=1ht4kx39fAXbSpV5A@mail.gmail.com>
 <CAD2nsn3krB2MZYewRtJpFikUu9079jXXMabz90z6Zc7kfAeELw@mail.gmail.com>
 <20110707225321.GG28091@alittletooquiet.net>
 <CAD2nsn2BH9vEjKWui8JuQRufiKgTtBCHyifXCi1OxLMRck1heQ@mail.gmail.com>
 <CAD2nsn0UC=dkM-vB7vsawyB-PzgTV=rGzLDRr_5fx3ZQqVJiuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7vAdt9JsdkkzRPKN"
In-Reply-To: <CAD2nsn0UC=dkM-vB7vsawyB-PzgTV=rGzLDRr_5fx3ZQqVJiuQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--7vAdt9JsdkkzRPKN
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi shafi,

On Mon, Jul 11, 2011 at 11:01:04AM +0530, Mohammed Shafi wrote:
> On Fri, Jul 8, 2011 at 6:54 PM, Mohammed Shafi <shafi.wireless@gmail.com>=
 wrote:
> > On Fri, Jul 8, 2011 at 4:23 AM, Forest Bond <forest@alittletooquiet.net=
> wrote:
> >> Hi shafi,
> >>
> >> On Thu, Jul 07, 2011 at 03:23:50AM -0400, Mohammed Shafi wrote:
> >>> attached a reverting patch for LED, did a basic test and looks fine.
> >>> need to investigate in this for backporting. =A0we have not tested in
> >>> 2.6.24 kernel
> >>
> >> Yes, this seems to fix things. =A0I can bring the interface up now and=
 get
> >> scanning results. =A0I will test further and let you know how things g=
o.
> >
> > let me quickly check if undefine CONFIG_MAC80211_LEDS in ath9k_htc in
> > latest wireless-testing and if i get a lock up or panic
>=20
> it did not help, got an idea its a locking issue in com pat, I don't
> know why its happening for the older kernel. made it working by
> commenting out few spinlocks,

Okay, in the meantime I am up and running with hostapd.  I have been testin=
g for
a few hours and have not seen problems, so this setup appears to be relativ=
ely
stable.

Of course I am happy to test any other patches you would like to try.

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.rapidrollout.com

--7vAdt9JsdkkzRPKN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk4bERkACgkQRO4fQQdv5AyuIwCfWnc9fycqtRe+fV2agqevKbWI
HkEAmgPly6YJjpnZ4WhNdBiyTDlme0eg
=8A/J
-----END PGP SIGNATURE-----

--7vAdt9JsdkkzRPKN--
