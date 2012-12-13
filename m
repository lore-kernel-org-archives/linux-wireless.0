Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:52743 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab2LMJvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 04:51:43 -0500
Date: Thu, 13 Dec 2012 10:51:34 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Srinivasan B <srinivasanb@posedge.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: 802.11h DFS support
Message-ID: <20121213095134.GA26314@pandem0nium> (sfid-20121213_105147_877785_1ADC78A5)
References: <50C89C8B.6040301@posedge.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
In-Reply-To: <50C89C8B.6040301@posedge.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Srinivasan,

On Wed, Dec 12, 2012 at 08:32:35PM +0530, Srinivasan B wrote:
> Hi,
>         I was looking for the DFS support in
> mac80211/cfg80211/nl80211/hostapd and observed that the latest
> wireless-testing kernel & hostapd.git does not include support for
> 802.11h.

that's correct.
>=20
>         I also referred few patches submitted by Victor Goldenshtein
> which had support for entire DFS operation basing wireless-testing
> kernel. As per my understanding these patches are presently getting
> modified to support new channel-context modifications.
>=20
>         Could someone confirm if I am right at my understanding.

Yup. Actually I picked up Victors patchset and doing the channel context
rework right now, and plan to send a revised patchset for nl80211/mac80211
soon.=20

"Entire" DFS operation is not entirely correct. There will still be quite
a few bits missing:

 * driver support - some drivers like ath9k have something prepared, but
   it still needs to be integrated
 * ETSI/FCC support has to be verified for the different drivers
 * testing, of course

Cheers,
	Simon

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDJpSYACgkQrzg/fFk7axaeDQCfXRp6B5EiCaYeAKxxU9J83NuT
ZZsAmwZh+gTxed05Ao5GycqviO3l98ER
=sdfR
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
