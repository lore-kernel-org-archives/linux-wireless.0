Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:62730 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754549AbXKLDYf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2007 22:24:35 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: Re: [PATCH 01/14] mac80211: adding MAC80211_HT config variable
Date: Sun, 11 Nov 2007 22:24:03 -0500
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com
References: <1194595326527-git-send-email-ron.rindjunsky@intel.com> <11945953311871-git-send-email-ron.rindjunsky@intel.com>
In-Reply-To: <11945953311871-git-send-email-ron.rindjunsky@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10303048.Q9AIgPVnpy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200711112224.08807.flamingice@sourmilk.net> (sfid-20071112_032440_089005_0FC6A46D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart10303048.Q9AIgPVnpy
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 09 November 2007 03:01:53 Ron Rindjunsky wrote:
> This patch adds MAC80211_HT and MAC80211_HT_DEBUG config variables
> to separate HT features
>
Nah. We don't need more ifdefs. Just leave the code on all the time. The=20
overhead when it's not being used should be minimal and if it's not.. that=
=20
needs to be fixed anyway.

Also there doesn't appear to be MAC80211_HT_DEBUG in this patch, though I'd=
 be=20
okay with that.

=2DMichael Wu

--nextPart10303048.Q9AIgPVnpy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHN8dYT3Oqt9AH4aERAmWwAKDQhI3L4m4NNVEhlTivc9wx9dQ14wCfdb3O
z4hlDeig2J4OSgljeZ5/7hY=
=5/dU
-----END PGP SIGNATURE-----

--nextPart10303048.Q9AIgPVnpy--
