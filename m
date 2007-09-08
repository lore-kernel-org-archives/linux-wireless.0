Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46257 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbXIHHke (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Sep 2007 03:40:34 -0400
Subject: Re: iwlwifi sparse warnings with __CHECK_ENDIAN__
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <1ba2fa240709080037p44516f1eu7040bd4424a29f8c@mail.gmail.com>
References: <1189100027.28781.104.camel@johannes.berg>
	 <1ba2fa240709080037p44516f1eu7040bd4424a29f8c@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Nwr8vw77ucnMHRf4IFQ/"
Date: Sat, 08 Sep 2007 09:41:51 +0200
Message-Id: <1189237311.4506.6.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Nwr8vw77ucnMHRf4IFQ/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-09-08 at 10:37 +0300, Tomas Winkler wrote:
> I'm not sure that you are running latest iwlwifi.

I have the latest wireless-dev.

> There is only one warning with __CHECK_ENDIAN__ which I don't know how
> to solve cleanly.
> Yet the code is correct and it is even running on a  PPC machine.

Ok. Like I said to Michael, I just happened to run it to see something
else and figured I'd post it.

johannes

--=-Nwr8vw77ucnMHRf4IFQ/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG4lI//ETPhpq3jKURAm+oAJ4yO35LymB8JVyiKp27qhAO2XbSkQCfcvzk
52Kx9yuL2xixnWQlSAxJGzA=
=WsSa
-----END PGP SIGNATURE-----

--=-Nwr8vw77ucnMHRf4IFQ/--

