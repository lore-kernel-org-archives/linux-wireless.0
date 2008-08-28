Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51497 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbYH1MXm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 08:23:42 -0400
Subject: Re: [PATCH 06/11] iwlwifi: fix apm_stop
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>, Zhu Yi <yi.zhu@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Mohamed Abbas <mohamed.abbas@intel.com>
In-Reply-To: <1ba2fa240808280421g642ddc62j7541837f874f79df@mail.gmail.com> (sfid-20080828_132132_415958_8B7C22C7)
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-6-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-7-git-send-email-yi.zhu@intel.com>
	 <1219926807.6064.17.camel@californication>
	 <1ba2fa240808280421g642ddc62j7541837f874f79df@mail.gmail.com>
	 (sfid-20080828_132132_415958_8B7C22C7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IsRBUGCUjgqLM9sV/mAu"
Date: Thu, 28 Aug 2008 14:23:02 +0200
Message-Id: <1219926182.25321.14.camel@johannes.berg> (sfid-20080828_142345_987008_6092C978)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IsRBUGCUjgqLM9sV/mAu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-28 at 14:21 +0300, Tomas Winkler wrote:
> On Thu, Aug 28, 2008 at 3:33 PM, Marcel Holtmann <marcel@holtmann.org> wr=
ote:
> > Hi Yi,
> >
> >> The patch fixes CSR_GP_CNTRL_REG_FLAG_INIT_DONE was set instead of
> >> cleared which disabled moving device to D0U state.
> >
> > when was this mistake introduced. Is it a regression compared to what w=
e
> > have in 2.6.26?
>=20
> Again. think of global warming.

If you're so concerned about global warming, why didn't you fix this,
umm, months ago? :)

Frankly, this sounds like a "quick, somebody help me come up with a good
argument" argument.

johannes

--=-IsRBUGCUjgqLM9sV/mAu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIbBAABAgAGBQJItpijAAoJEKVg1VMiehFY/0YP910EWb557y9wr3UqbTWBN7XJ
p53E08NN96kyWa4TxTxqvPSkI0OCGNDZgOrAnlJAMT9+5dQ9VTC5TLAwP3C5RJSd
RmpZruk/Quszr7C3/jE/YCbNm4YYejz30Ar9lfA34q7VwGI6gDgDL7H8Cx8ICgMm
7AufLRji5mCINrESjK4xNMoKVrohubklj2i0X1a9Z+5ED/WsMym/rzkTAHnID/P6
I4cF99iWEa3qXZXA5gA43eihPFRyCTUmsEoZDiRJ2vTJ8olQBeORumyMBP//kfuV
X1o4x0/mjl3RYq+nzAAhDNaYyMh5qLpOfiRZAOdSETVvGS9hJh27CsH1G4/aB3nv
lw+iLbhdfwqkTnXECM1BCzqDHTOf9X9Xzk3upWe6uoDuGzmKOIW60GvWVaIepmMX
W/Q3OMA3WO6KxzbeVysarK8EgjypVc2yPP71S9mTWX/E+uqu7SQrTKRKI5s7XCJs
s6h6Dr01YwOF8kHTFHwCLGtrX3mmY61rnmPSKUvD45pboeLvdmTAGX31NDKydTOw
8M8ZvYBlr8e8K33cWAdcmDN4SeFhZORJQmx8uT69AXQDM3xUwApG3zfTB/SMvi6J
tNpZe18e37nuVPkpVV+9PcQ1PzpAUAPlfCkefHBG+8VVVlNdlHsD483QBSon0kPe
ZL72xG1wSBABekjAOWE=
=qMy5
-----END PGP SIGNATURE-----

--=-IsRBUGCUjgqLM9sV/mAu--

