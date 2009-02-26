Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36008 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbZBZQvZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2009 11:51:25 -0500
Subject: Re: pull request: wireless-next-2.6 2009-02-23
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
In-Reply-To: <20090226161340.GA4430@tuxdriver.com>
References: <20090223192659.GB3553@tuxdriver.com>
	 <1235457113.4455.89.camel@johannes.local>
	 <20090224.235510.30497146.davem@davemloft.net>
	 <1235637360.29050.16.camel@johannes.local>
	 <20090226161340.GA4430@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RUEAbgC57+vrXkf8xh9R"
Date: Thu, 26 Feb 2009 08:47:34 -0800
Message-Id: <1235666854.4099.0.camel@johannes.local> (sfid-20090226_175129_532389_F60708AC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RUEAbgC57+vrXkf8xh9R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-26 at 11:13 -0500, John W. Linville wrote:

> > Now I just have to get around to fixing it, it's proving to be harder
> > than I thought, and I don't have much time right now.
>=20
> I suppose I could just drop that one.  IIRC there was another patch
> from you that depended upon that one as well?

Yes, that's true, but then we'll be back at the wext vs. nl80211
deadlock problem...

johannes

--=-RUEAbgC57+vrXkf8xh9R
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJpsejAAoJEKVg1VMiehFYGJ4P/RYU/PhoIwaX0D6QyrHY5500
/JXlj2/yv9E4zRMV6ItydsS/ipNBkNDATUsREWZEGsYLL29m4RYKlTDTuk61XHI0
9wl1mvhK7H8kMpnVarPHtRCerB+PbDFx7Pawkx8Y3dhQStOJfBZMBCUKrjJljN/Y
BWsqsGuh/Poz33mrFCTN2LAk4AQxomonIQ2TLrjLfgaAVwMgzdU8pZr4o4N4o59N
oSOSADtzLba59Vr/fPcdPNMYfRKU4qy+PxbWde8JV7cO7fdi7GNxjD2uBCoY5e04
oX5ek81WJT6xwheaixqPtYxeFsFnBLLRHY4DINeaxjE8TJKmNpgWnoOgqTM+2J45
O3CNvJzfDK1xosdt5TkF6X+Li4fFMfX892JZx8W6Mc+8Jn8YR9HLSV2pJlE+KMSE
PQLUxPI9GGfCNba1afVkOgsWSY+ADLwdFL1paoyfFDWfNUnxAcEBGMnjYm71x0Ru
pveNUC0w0tMbET0ppoIvHsJb8sdC6bzHFD7Mgs8A2PVX64WW7tHOborvl4KCQTT0
TpW4sNOOA/dfe/1F1PtiPeslVc2u5bbgJabW9SutRMP0Fwf1TvVqBV9pKeHYWwoW
ShAK7wWCish9bVK/FMDgf8alVECsiybLsl7I3iZTJKDuRlgFdeJMnLv7RrCQ9ETS
3KU7GEaq27NfdGDV8Pht
=0e2K
-----END PGP SIGNATURE-----

--=-RUEAbgC57+vrXkf8xh9R--

