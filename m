Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:53549 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbYKYVB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 16:01:27 -0500
Received: by ey-out-2122.google.com with SMTP id 6so65329eyi.37
        for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2008 13:01:25 -0800 (PST)
From: Henning Rogge <hrogge@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: RFC Patch: Add signal strength to nl80211station info
Date: Tue, 25 Nov 2008 22:01:15 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <200811252131.30161.hrogge@googlemail.com> <1227646037.4613.46.camel@johannes.berg>
In-Reply-To: <1227646037.4613.46.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2921357.fljvdTknjm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200811252201.22704.hrogge@googlemail.com> (sfid-20081125_220133_172771_B36E7E9E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2921357.fljvdTknjm
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 25 November 2008 21:47:17 Johannes Berg wrote:
> On Tue, 2008-11-25 at 21:31 +0100, Henning Rogge wrote:
> > +	NL80211_STA_INFO_SIGNAL,
> > +	NL80211_STA_INFO_NOISE,
> > +	NL80211_STA_INFO_QUAL,
>
> Sorry, no, this WEXT junk is just too undefined to put it into nl80211.
It was an experiment... the question is, what kind of information about sig=
nal=20
strength or SNR would be good enough to make it available to userspace.

At the moment there is no way to get this information without a huge overhe=
ad=20
of cpu power (raw sockets + monitor mode + radiotap)

Henning

--nextPart2921357.fljvdTknjm
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkksZ6IACgkQcenvcwAcHWcMTgCeOG9j9kKlrEoLhY8EgkBRdDYs
4cMAn2Uq5TmzRruMABu/GZDSz6b55woP
=vnVc
-----END PGP SIGNATURE-----

--nextPart2921357.fljvdTknjm--
