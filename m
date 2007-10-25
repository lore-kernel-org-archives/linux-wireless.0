Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:57066 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752236AbXJYRg7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 13:36:59 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [patch 6/9] nl80211/cfg80211: station handling
Date: Thu, 25 Oct 2007 13:33:36 -0400
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <20071025093618.440937000@sipsolutions.net> <20071025093716.685606000@sipsolutions.net> <43e72e890710250846h5ae85efaqfb5b7b5d0d82e932@mail.gmail.com>
In-Reply-To: <43e72e890710250846h5ae85efaqfb5b7b5d0d82e932@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2208517.DnRiYMS5O0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200710251333.41410.flamingice@sourmilk.net> (sfid-20071025_183703_997575_DAA2FA78)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2208517.DnRiYMS5O0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 25 October 2007 11:46:03 you wrote:
> > + * @NL80211_ATTR_STA_SUPPORTED_RATES: supported rates, array of
> > supported + *     rates as defined by IEEE 802.11 7.3.2.2 but without t=
he
> > length + *     restriction (at most %NL80211_MAX_SUPP_RATES).
>
> Is this necessary? Shouldn't we just embrace the supported rates of
> the hardware? If cfg80211 is extended to have devices register their
> hardware capabilities then we can take it from there perhaps ?
>
This is for the supported rates of the sta we want to TX to. Rate control=20
needs to know what rates are valid for a particular sta.

=2DMichael Wu

--nextPart2208517.DnRiYMS5O0
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHINN1T3Oqt9AH4aERAkmwAJ9OsjnORhhabkdAgQvRLXjogV1TIgCfefYN
OEaiIKzzgwVnOhlCAI9g+Q8=
=f6qs
-----END PGP SIGNATURE-----

--nextPart2208517.DnRiYMS5O0--
