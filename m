Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45086 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbYHASGR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 14:06:17 -0400
Subject: Re: [PATCH 1/1] mac80211: add direct probe before association
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080801173044.GB14974@tuxdriver.com>
References: <1216076865-9826-1-git-send-email-tomas.winkler@intel.com>
	 <20080801173044.GB14974@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SBncwUa7CCDPWX8lT1F8"
Date: Fri, 01 Aug 2008 20:06:04 +0200
Message-Id: <1217613965.8621.48.camel@johannes.berg> (sfid-20080801_200619_716099_D3BF8471)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SBncwUa7CCDPWX8lT1F8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-08-01 at 13:30 -0400, John W. Linville wrote:
> On Tue, Jul 15, 2008 at 02:07:45AM +0300, Tomas Winkler wrote:
> > This patch adds a direct probe request as first step in the association
> > flow. Motivation of this step is to make sure that the bss information
> > we have is up to date, since last scan could have been done a while ago=
.
> > beacons do not fully answer this need as there are potential difference=
s
> > between them and probe responses (e.g. WMM parameter element)
> >=20
> > Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>=20
> Does this fix a bug?  Seems likely...

Could, if the AP changes something since we've last scanned, and we
probably want to do this anyway.

johannes

--=-SBncwUa7CCDPWX8lT1F8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIk1CJAAoJEKVg1VMiehFYlzQQAIIfo+h/OW6DDtZGcuIglKNT
juLN3XmDiEsBsRv7dI6HNSXOgodx22zZJkN5F5ifJ+kuUaOiutSbVgUH+fa6G5Sw
9puduFHHAWtsIa2Tx9Dot150oe9Ier9Il9HhoYPtW87fLkZ/E5qZndMCPXsQy4r/
0TS0aTcM641mv39TRpDDws9ITM3AIrhAe8pkkt4XuRKkNTsagrmM0pWtSeiMHnEo
9kthIaqfHU0DE/w3J4YbsEDvya57Vf4Kbkv81ymb5sxNNjncRVd3tBI9wioQ2HOG
kmqK1amJlnRpetHJkNXK9/aQ1PCiM+HTLf+KLGWA1PDKo3KL6pcXr0hpzu8e+nfv
hW+LVvuefufQLhP9ItzwCwu/bTQMVt073iH+IFooe3qiqP8melibvOji3TrIfzDt
QG1/8EKiZoOI6F0m6EZL+bTsVIeVokcIIy/Oow4wd902YtY116hjS7csYYt+3fzE
3QmZC6oJ/ihtHtV4dkNb7DeB2yslCrtSGmI5HjW4SJPdcD2q3d1YnHlsSrtbr8oA
GXGqdrLZCHYLqmV1hWiP41jRZihCp7MIm8WatViOHsq2spntLfPeMgWRT6IEZ0rv
ZdDfW2P1XUwN2G+hc87Hnw/ckyRiDBPwowEwTJ39fpfmCjsiota61m4lsFRg3HFK
25s/Wkpip7mNh8Uwdjhn
=vtet
-----END PGP SIGNATURE-----

--=-SBncwUa7CCDPWX8lT1F8--

