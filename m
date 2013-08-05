Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:45364 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab3HEKBO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 06:01:14 -0400
Date: Mon, 5 Aug 2013 12:01:07 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: pull-request: mac80211-next 2013-07-26
Message-ID: <20130805100107.GA24729@pandem0nium> (sfid-20130805_120117_905068_DBE37A7A)
References: <1374827740.8248.15.camel@jlt4.sipsolutions.net>
 <20130801192723.GD13922@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
In-Reply-To: <20130801192723.GD13922@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey John,

since you have pulled the patches from Johannes, could you please also pick=
 up
the ath9k/ath5k patches for the 5/10 MHz feature? Johannes included the nl/=
mac80211
parts of the patchset only, leaving the ath5k/ath9k parts unmerged.

It has been sent to this mailing list, the coverletter mail was:

> Subject: [PATCHv6 00/18] Add support for 5 and 10 MHz channels
> Date: Mon,  8 Jul 2013 16:55:48 +0200
> Message-Id: <1373295366-12823-1-git-send-email-siwu@hrz.tu-chemnitz.de>

It includes 5 ath9k and 3 ath5k patches.

If there are any troubles, I can repost of course.

Thanks,
	Simon


On Thu, Aug 01, 2013 at 03:27:24PM -0400, John W. Linville wrote:
> On Fri, Jul 26, 2013 at 10:35:40AM +0200, Johannes Berg wrote:
> > John,
> >=20
> > This is a more traditional pull request without patches since they've
> > all been to the list :-) First set of updates for mac80211-next.
> >=20
> > The biggest change here is probably the initial 5/10 MHz support for
> > IBSS, the remaining patches are smaller features and some cleanups.
> >=20
> > Let me know if there's any problem.
> >=20
> > johannes
> >=20
> >=20
> > The following changes since commit ad81f0545ef01ea651886dddac4bef6cec93=
0092:
> >=20
> >   Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)
> >=20
> > are available in the git repository at:
> >=20
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git=
 for-john
> >=20
> > for you to fetch changes up to c82b5a74cc739385db6e4275fe504a0e9469bf01:
> >=20
> >   mac80211: make active monitor injection work w/ HW queue (2013-07-16 =
09:58:19 +0300)
>=20
> Pulling now...
>=20
> --=20
> John W. Linville		Someday the world will need a hero, and you
> linville@tuxdriver.com			might be all we have.  Be ready.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlH/d+MACgkQrzg/fFk7axbEQwCgx7IeByCxndiglDsOaTJ4rpbV
BbwAoKfHJn8x7Y807UsOe685mhL7Uscy
=Imf0
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
