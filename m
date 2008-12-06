Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:4723 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288AbYLFPql (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2008 10:46:41 -0500
Received: by ug-out-1314.google.com with SMTP id 39so252150ugf.37
        for <linux-wireless@vger.kernel.org>; Sat, 06 Dec 2008 07:46:39 -0800 (PST)
From: Henning Rogge <hrogge@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
Date: Sat, 6 Dec 2008 16:46:30 +0100
Cc: Henning Rogge <rogge@fgan.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
References: <200811252131.30161.hrogge@googlemail.com> <1228575081.16752.8.camel@johannes.berg> <200812061603.21930.hrogge@googlemail.com>
In-Reply-To: <200812061603.21930.hrogge@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7730836.AxCZfb3EPf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200812061646.36044.hrogge@googlemail.com> (sfid-20081206_164648_599748_99FAED92)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart7730836.AxCZfb3EPf
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 06 December 2008 16:03:16 Henning Rogge wrote:
> > I'd rename _TOTAL to _LEGACY and remove the calculation for MCS rates,
> > that way it's obviously clear what you're getting in userland.
Okay, after reading your mail a second time I understood you...=20

I think with removing the total bitrate for 802.11n we will just make the=20
userspace interface more complex. You will have to look at four different=20
things (flags, MCS, guard interval, legacy) just to get the bitrate, which=
=20
will be the typical information the user wants to know. Is there anything=20
nl80211 will gain if we don't put this value inside for all 802.11 ? We can=
not=20
drop it because of 802.11abg, so why not fill it with useful data ?

Henning

--nextPart7730836.AxCZfb3EPf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkk6nlwACgkQcenvcwAcHWdNawCfQRbEsfgX0Dn2FRQ4cEsqwVFl
gtwAnjQyFZRgPeKfBfMSXBIXNpVvmfpw
=nasq
-----END PGP SIGNATURE-----

--nextPart7730836.AxCZfb3EPf--
