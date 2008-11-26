Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:31153 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbYKZQRf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 11:17:35 -0500
Received: by nf-out-0910.google.com with SMTP id d3so297361nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 08:17:33 -0800 (PST)
From: Henning Rogge <hrogge@googlemail.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
Subject: Re: RFC Patch: Add signal strength to nl80211station info
Date: Wed, 26 Nov 2008 17:17:23 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200811252131.30161.hrogge@googlemail.com> <1227646037.4613.46.camel@johannes.berg> <EA31B699-C803-460C-8D90-9E946CC97A33@linux.intel.com>
In-Reply-To: <EA31B699-C803-460C-8D90-9E946CC97A33@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6204339.uXbYelB3JS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200811261717.30452.hrogge@googlemail.com> (sfid-20081126_171740_770350_5AAF4846)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart6204339.uXbYelB3JS
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 26 November 2008 06:21:40 Marcel Holtmann wrote:
> Hi Johannes,
>
> >> +	NL80211_STA_INFO_SIGNAL,
> >> +	NL80211_STA_INFO_NOISE,
> >> +	NL80211_STA_INFO_QUAL,
> >
> > Sorry, no, this WEXT junk is just too undefined to put it into
> > nl80211.
>
> I know that WEXT were pretty bad in describing what to expect from
> these values and every driver did whatever it thought it would be
> best. Can we not just try to define how these values should be filled
> in and then either mark drivers as broken or try to fix them? Just an
> idea.
That would be a great thing... it's not that I really need the noise level =
(or=20
the quality value), I was just testing how easy I can push values through=20
nl80211 into userspace. The layer 1/2 data I'm looking for is signalstrengt=
h=20
and transmission rate for each adhoc communication partner. And I still thi=
nk=20
the mac80211 stack is missing some easy way to get them at the moment.

Henning

--nextPart6204339.uXbYelB3JS
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkktdpoACgkQcenvcwAcHWdyqACcDzz8Qn8dJ1V7UQrjIkH/py8W
QEAAnjK39SoJ4fzmEEJUxcmcTE519QZQ
=gSc0
-----END PGP SIGNATURE-----

--nextPart6204339.uXbYelB3JS--
