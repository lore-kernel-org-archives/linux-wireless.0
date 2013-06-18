Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:50339 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171Ab3FRPSJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 11:18:09 -0400
Date: Tue, 18 Jun 2013 17:18:06 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [PATCHv2 2/5] nl80211/cfg80211: add channel switch command
Message-ID: <20130618151806.GB27492@pandem0nium> (sfid-20130618_171833_610011_6FC0CB63)
References: <1371212124-26264-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1371212124-26264-3-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1371567030.8318.34.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
In-Reply-To: <1371567030.8318.34.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 18, 2013 at 04:50:30PM +0200, Johannes Berg wrote:
>=20
> > + * @NL80211_CMD_CHANNEL_SWITCH: Perform a channel switch by announcing=
 the
> > + *	the new channel information (Channel Switch Announcement - CSA)
> > + *	in the beacon for some time (as defined in the
> > + *	%NL80211_ATTR_CH_SWITCH_COUNT parameter) and then change to the
> > + *	new channel. Userspace provides the new channel information (using
> > + *	%NL80211_ATTR_WIPHY_FREQ and the attributes determining channel
> > + *	width). %NL80211_ATTR_CH_SWITCH_BLOCK_TX may be supplied to inform
> > + *	other station that transmission must be blocked until the channel
> > + *	switch is complete.
>=20
> We probably need a flag to indicate that the command is available, since
> mac80211 might implement it but not all drivers will?

Yeah ... shall we announce it as CMD() in nl80211_send_wiphy()? Or feature
flag?

Cheers,
	Simon

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlHAei4ACgkQrzg/fFk7axYPbgCfWllYw0SsKyqHR4tfIxML7Lc6
yVIAoJ6DnhAQNly0GDtjZmTV2rQBETzL
=Rxr0
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
