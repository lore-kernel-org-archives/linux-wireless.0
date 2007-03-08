Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48898 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbXCHRnX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 12:43:23 -0500
Subject: Re: sparse using insane amounts of memory
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org, linux-sparse@vger.kernel.org
In-Reply-To: <1173375270.15842.24.camel@dv>
References: <1173319356.3546.54.camel@johannes.berg>
	 <1173371608.21465.12.camel@dv>  <1173372315.3248.19.camel@johannes.berg>
	 <1173375270.15842.24.camel@dv>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1L5dBuRR18RsTJcX4AER"
Date: Thu, 08 Mar 2007 18:43:11 +0100
Message-Id: <1173375791.3248.37.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1L5dBuRR18RsTJcX4AER
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-08 at 12:34 -0500, Pavel Roskin wrote:

> FIELDS32 expands to some monstrosities.  Look for rt2x00_bbp_write in
> the dump.  Also behold the amount of parentheses in LOWEST_BIT32.
> That's almost certainly the culprit.

And I even had CONFIG_RT2X00_DEBUG enabled so it's worse that the
regular case.

johannes

--=-1L5dBuRR18RsTJcX4AER
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF8Esv/ETPhpq3jKURAkQEAJ9PUdX5enuFa5B+i2O8cK/9xQ9X9wCfZLeo
qbc0+FWnNkvRPovwP62d5ew=
=g7NP
-----END PGP SIGNATURE-----

--=-1L5dBuRR18RsTJcX4AER--

