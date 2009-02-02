Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:41797 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752804AbZBBTA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 14:00:28 -0500
Received: from c83-249-24-87.bredband.comhem.se ([83.249.24.87]:38732 helo=samir)
	by ch-smtp02.sth.basefarm.net with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <hans@sociologi.cjb.net>)
	id 1LU41x-0004Bv-8w
	for linux-wireless@vger.kernel.org; Mon, 02 Feb 2009 20:00:26 +0100
Received: from hans by samir with local (Exim 4.69)
	(envelope-from <hans@sociologi.cjb.net>)
	id 1LU44Q-0007Y6-0B
	for linux-wireless@vger.kernel.org; Mon, 02 Feb 2009 20:02:58 +0100
Date: Mon, 2 Feb 2009 20:02:57 +0100
From: Hans Ekbrand <hans@sociologi.cjb.net>
To: linux-wireless@vger.kernel.org
Subject: Re: USB 1.1, usb-dongle, NETGEAR WG111v2, timing problems in
	association
Message-ID: <20090202190255.GF24485@samir> (sfid-20090202_200033_376037_268F2A98)
References: <20090117204654.GB9079@amin> <4972B25B.7070306@lwfinger.net> <20090202155542.GE24485@samir> <498719F3.4070601@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zrag5V6pnZGjLKiw"
In-Reply-To: <498719F3.4070601@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Zrag5V6pnZGjLKiw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 02, 2009 at 10:06:11AM -0600, Larry Finger wrote:
> Hans Ekbrand wrote:
> > On Sat, Jan 17, 2009 at 10:38:51PM -0600, Larry Finger wrote:

[...]

> >> I just bought a WG111v2 on E-Bay last week. Once it arrives, I will be
> >> able to test the performance of this device.
> >=20
> > Have you had the possiblity to try it on USB 1.1 yet?
>=20
> Yes and it works.
>=20
> Once I got the device, I found and fixed two main problems in the
> driver for the RTL8187. The first keeps mac80211 from adjusting the
> wireless rate, and the second hurts the power setting for OFDM rates.
> Both of these are fixed in the latest wireless-testing and in
> compat-wireless.

Did it work on USB 1.1 even without your enhancements?

--=20
Hans Ekbrand (http://sociologi.cjb.net) <hans@sociologi.cjb.net>
GPG Fingerprint: 1408 C8D5 1E7D 4C9C C27E 014F 7C2C 872A 7050 614E

--Zrag5V6pnZGjLKiw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmHQ18ACgkQfCyHKnBQYU7YngCgkTRuCulYjrL6Som9biNdcgGI
BKwAn2PRF1hCKrMR08rHMOUdtFMEW6g8
=qqbO
-----END PGP SIGNATURE-----

--Zrag5V6pnZGjLKiw--
