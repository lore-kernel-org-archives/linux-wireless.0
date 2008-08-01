Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52078 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbYHAJzn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 05:55:43 -0400
Subject: Re: 2.6.27-rc1-next-20080731 assoc problems
From: Johannes Berg <johannes@sipsolutions.net>
To: Jasper Bryant-Greene <jasper@amiton.co.nz>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1217583811.8621.0.camel@johannes.berg> (sfid-20080801_114346_689518_342C9D16)
References: <1217558895.3103.10.camel@luna.unix.geek.nz>
	 (sfid-20080801_045427_652694_B19B078D)  <1217583811.8621.0.camel@johannes.berg>
	 (sfid-20080801_114346_689518_342C9D16)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gARFwF7O6cv1pBdYm3in"
Date: Fri, 01 Aug 2008 11:55:38 +0200
Message-Id: <1217584538.8621.2.camel@johannes.berg> (sfid-20080801_115549_364625_424731BA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gARFwF7O6cv1pBdYm3in
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-08-01 at 11:43 +0200, Johannes Berg wrote:
> On Fri, 2008-08-01 at 14:48 +1200, Jasper Bryant-Greene wrote:
> > iwl4965, Netgear WNR854T 802.11n AP
> >=20
> > I seem to be getting these problems from time to time since moving from
> > 2.6.26 to 2.6.27-rc1-next-20080731:
>=20
> > [  457.511978] wlan0: AP denied association (code=3D1)
>=20
> > Is it really my AP, as the messages suggest?
>=20
> Yes, and it doesn't even tell you why, 1 is WLAN_REASON_UNSPECIFIED

Sorry, it's a status code, not reason, but that just means it's
WLAN_STATUS_UNSPECIFIED_FAILURE

johannes

--=-gARFwF7O6cv1pBdYm3in
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIkt2WAAoJEKVg1VMiehFYpgoP/RA3rMRRK9HxPiAh8AqUAiSq
mmJ4UbmrBIjPvL/zPfWCubj9s8EeMIWqmNRmcs4ZTXBqu9HXZhhJfwIsCExvVFnJ
NfowC1xK38/8mLZzXH7OTF9rhJa43dTV7+l40+YwrolrYLVKgLjXCnVw7+fdZPmd
Ak6NxIcywWGbJrRZ3eT8+fOYZb6PdFSbJSLSHkCJ1s0JaPeI25r+KhxjFX7WVAxF
usyQH1O5iDI2FKd66qGbqdb/K9fRBTNH/5DY5TjWTKNnlJmLp9hnObl6ayr99PoE
TUAK3a6Nzf74zDQR7L00qqHXxc3Wivfe0NCoATQisScTdJLn0i8Q9KRf/tKldCQH
IpD2As9oB9uIALVO4X355LrV/e2WaM0R0WJbeVVfsAa5/RXdkKrqPM2lM/dZv4W/
icwwQqm1YDx/GVBIqStlS2cgh8ndoKL/fymv8d5xXSPb5jCWb+tmJy+guNdLhZat
ZTlDio2HNUfrDLzCcFi7BswqIPbk7iC7C/v4FuoM30DKqGggucelvf3g8cibF5EZ
+Qyhe0atWTN0TavirJhrO5U2UKMtUXfnw7YLInMmeDWbpeF01Ht//Oo+bXcia6MY
EheKjy/MToCDk9EbfqNpEfVZFKYmm3OTPOjW4LbC7CPBWtX2kRFSfWlfebBfbAE/
huBB2A9TrDt2cecgwqUW
=J/RL
-----END PGP SIGNATURE-----

--=-gARFwF7O6cv1pBdYm3in--

