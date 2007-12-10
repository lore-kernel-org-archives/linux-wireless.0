Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50646 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbXLJMPw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 07:15:52 -0500
Subject: Re: [RFC PATCH] introduce WEXT scan capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: David Miller <davem@davemloft.net>, jt@hpl.hp.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1197223174.9149.60.camel@localhost.localdomain> (sfid-20071209_180959_144382_2B68811A)
References: <20071206191150.GC5237@bougret.hpl.hp.com>
	 <1197022818.2603.20.camel@localhost.localdomain>
	 <20071207192756.GA15864@bougret.hpl.hp.com>
	 <20071207.180408.55119728.davem@davemloft.net>
	 <1197221706.9149.36.camel@localhost.localdomain>
	 <1197223174.9149.60.camel@localhost.localdomain>
	 (sfid-20071209_180959_144382_2B68811A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JwQJ52LA9vQjWd9wm5V7"
Date: Mon, 10 Dec 2007 13:15:27 +0100
Message-Id: <1197288928.6035.59.camel@johannes.berg> (sfid-20071210_121555_506551_10700975)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JwQJ52LA9vQjWd9wm5V7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Do either of those sound better to you than extending struct iw_range?

Because wext is stupidly defined, you can never extend any structures it
uses. Wext never passes in the length that userspace expects to passing
in longer structures than the fixed one userspace expects will always
overwrite something in userspace, possibly on the stack.

johannes

--=-JwQJ52LA9vQjWd9wm5V7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR10t3qVg1VMiehFYAQIdwg//UU3zSX2JlGdo7QOLIF67fltarDEDgmVF
3hAYU+T0HWw8xw6XqTrbdEK1jgwxyYFUyM3IWkDWnfF4UfHeSOLHlxxPys5ZHbWK
wKy/SfnuWg3shi+hcMV6n9CQVxgV1VOZl7TWxA1db0usKFiI4h6pLu8A6ilKrkmd
d5MsYLjPWFj5iM81xdVf4GDYwblqnLCgVW+Od5xJJ7u8LVq52M4AegCs1eZXgWHo
6xh69ZRL9ypcMWvkaVva54qI2sbD54T6BnlA8WjBXcNQhBZ3n6fJ7jTMRktjWFVd
8dSw9Z7f1YWjhv1XlQVEkCCUAzfdhzaDUHgCLe6efSpfEORu9hxFjN/lmfV6u5pZ
0uDiLBRvmRBbFsUe93Ll5gejJmDLDsozWOR5scxLztFlLZKz8VL77gAjaKCHXj3S
oTOkjHjrdHQV4vGTIAMix5bGDpqWMbutKKmZ+F1bVHIbf4pjUT5SLOGGTt/SiOfd
zmtuUBNECVWuVaeokdComOaRvEJo7JVe1N+pfb9yctXepjPAWXTwoBFIgk915hKq
ztb9HPcaI7ea1BHbwciqAaZItmP52FD0ZdChov9+C1tUib+M3gFPOMdo5qOXYm8G
SSNCpcR8Qk0z8MkEaFMu8cjxWEq9zPEVPVYg+u5hUcK3MgJSZ1BUQw6hPrvqJpSu
mLiLkVz22U0=
=RdzR
-----END PGP SIGNATURE-----

--=-JwQJ52LA9vQjWd9wm5V7--

