Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:43054 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3GIP3m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 11:29:42 -0400
Date: Tue, 9 Jul 2013 17:29:38 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv6 00/18] Add support for 5 and 10 MHz channels
Message-ID: <20130709152938.GA22583@pandem0nium> (sfid-20130709_172945_738635_B454CF76)
References: <1373295366-12823-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1373382510.8241.2.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
In-Reply-To: <1373382510.8241.2.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 09, 2013 at 05:08:30PM +0200, Johannes Berg wrote:
> On Mon, 2013-07-08 at 16:55 +0200, Simon Wunderlich wrote:
> > This patchset adds support for 5 and 10 MHz in nl80211/cfg80211/mac80211
> > and enables support in ath5k and ath9k, which already support this feat=
ure
> > on the driver side. 5 and 10 MHz wide channels might be useful for:
> >=20
> >  * long shot links, as the transmissions are more robust
> >  * future support for 802.11y which allows some 5 and 10 MHz channels in
> >    3.6 GHz range
> >  * future support for 802.11p which uses 10 MHz in 5.9 GHz range
> >  * ... and more "special" applications.
> >=20
> > This patchset enables 5 and 10 MHz channels only for OFDM, and without
> > HT/MIMO/aggregation (for now). Support may be added later.
>=20
> I've applied patches 1-10, not going to take the ath patches.

Thanks! I'll ask John to merge them when pulls mac80211-next, you might want
to mention that in your pull request too.

Thanks again,
	Simon

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlHcLGIACgkQrzg/fFk7axbzyQCgsbmNd4fGViaQyw3vmy984tBe
nhMAoIJsP8jB8jSKCcREAn/G6Nt/9ZSq
=luMr
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
