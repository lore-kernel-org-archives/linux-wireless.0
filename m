Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:51172 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab3HPIik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 04:38:40 -0400
Date: Fri, 16 Aug 2013 10:38:35 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH-resend 0/9] ath5k/ath9k: respin/resend 5/10 MHz and CSA
 patches
Message-ID: <20130816083835.GA8785@pandem0nium> (sfid-20130816_103930_160333_7CDF1A29)
References: <1376460098-26648-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <20130815200404.GH2133@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
In-Reply-To: <20130815200404.GH2133@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 15, 2013 at 04:04:04PM -0400, John W. Linville wrote:
> On Wed, Aug 14, 2013 at 08:01:29AM +0200, Simon Wunderlich wrote:
> > This series contains the rebased patches for 5/10 MHz and channel switch
> > announcement for ath5k/ath9k as sent in their respective series earlier=
=2E No
> > modification was made. Since Johannes picked the nl/cfg/mac80211 parts
> > only, these patches are still missing in the tree. John reported some
> > trouble building with these patches, but I couldn't see any problems he=
re.
> >=20
> > The series is based on wireless-testing of todays master. Please tell
> > me if there are any problems (including compiler errors and kernel conf=
ig)
> > so I can rework if neccesary.
>=20
>   CC      drivers/net/wireless/ath/ath9k/rc.o
> drivers/net/wireless/ath/ath9k/rc.c: In function =E2=80=98ath_rate_update=
=E2=80=99:
> drivers/net/wireless/ath/ath9k/rc.c:1333:3: error: invalid type argument =
of =E2=80=98->=E2=80=99 (have =E2=80=98struct cfg80211_chan_def=E2=80=99)
> make[2]: *** [drivers/net/wireless/ath/ath9k/rc.o] Error 1
>=20

Ah - I missed the ath9k rate control configuration ... thought I had it on.
Thanks a lot, I'll send a replacement patch for this one in a minute.

	Simon

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlIN5QsACgkQrzg/fFk7axYGLgCg5ciXbiJk+2CMbQ/JpDqEdDBd
4QcAoNoIt4ej7WxoEEzu7gZK09azUaEc
=36dc
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
