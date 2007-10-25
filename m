Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53562 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbXJYNYG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 09:24:06 -0400
Subject: Re: [RFC] mac80211: no missing key complaint if frame may not be
	for us
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net
In-Reply-To: <20071024134855.GA3435@tuxdriver.com>
References: <1193175981828-git-send-email-linville@tuxdriver.com>
	 <1193216455.5715.2.camel@johannes.berg>
	 <20071024134855.GA3435@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4Jr+pC46pBOTx3FluYSS"
Date: Thu, 25 Oct 2007 15:25:01 +0200
Message-Id: <1193318701.6092.13.camel@johannes.berg> (sfid-20071025_142410_609677_C662014C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4Jr+pC46pBOTx3FluYSS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-24 at 09:48 -0400, John W. Linville wrote:

> I considered removing it, and that may be the best bet.  Still, I
> thought it might be worth yelling about it in at least some instances.

Yeah it did catch a TKIP bug Larry ran into at some point. Maybe it
should be a debug message that only shows up with debug enabled? I don't
think regular users can do anything about the message anyway, "what is
TKIP anyway?"

johannes

--=-4Jr+pC46pBOTx3FluYSS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyCZLKVg1VMiehFYAQIDfQ//bTZMcm1Zm9A/gLRwW48ymUB+vzEqrCwZ
yRX8pilL/QLLFq3vQnlRch+015wL4Em7XvhAS5z8sFNv5CfAfeZ8xrXH5c19OEtM
Ot1PDDx3wSWWcIu0JIsCNXOVPa1LnKgjGGBL3w0T1Om93bTX1e7GTi5FK0XYGYz5
12KYFaL7NOYavAB8SL9anyS9pKYnEvC4VqGeqLKf7ajpfjzKSFcaOV3uPphfVpPP
ZcTxW1WFeS/PwjBDqeWxIw9cHYLbVwX1sp6qqjzyPMV4Fua2Rxqjkg9+McnJN4+g
iTUiOGfDZqpEuswC9Pt8kpCLk4VPs9MRyWxhFUemFXn0MvJse63Cmil7einrN6ou
HWqwFGIUF1CksEm2GavNTdh+AKfeuF+xquBNKVl6jgAinCrdKkrkYNqe2K0z7vgx
qr5bzlYd6zb984gZUs8j/dShZoSSgEw+ZsfGn4N/eanqul6QOd7PpAjDTc8D58UB
ATCw92z0jWyKhRcL708th8QpR3U0MePUmQ9uHW63nqliY/j4jrjAMkrDBd74mL4M
QWh77A/O/Z9O6hqXbUAJiGXKb8VZ55WLdGoqDmCI889IxYzugwiQ+SqJyN8eYw9I
uW9brUVNN/Xq/LpLQK17sshNEEC3IVzO0a/xqH7eFnIoYZQKQHaRy1PHqg6235va
BQZP1WcqB4M=
=rO20
-----END PGP SIGNATURE-----

--=-4Jr+pC46pBOTx3FluYSS--

