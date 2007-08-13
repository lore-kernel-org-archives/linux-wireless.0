Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42453 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969560AbXHMI7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 04:59:38 -0400
Received: from [131.234.209.34] (helo=[131.234.237.45])
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1IKVlw-0007Sh-LM
	for linux-wireless@vger.kernel.org; Mon, 13 Aug 2007 09:59:36 +0100
Subject: Re: [PATCH 3/3] mac80211: remove management interface
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <20070813074644.118092000@sipsolutions.net>
References: <20070813074504.416717000@sipsolutions.net>
	 <20070813074644.118092000@sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VArrRA9yGrNK+C1S2tdK"
Date: Mon, 13 Aug 2007 09:55:47 +0200
Message-Id: <1186991747.27916.46.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VArrRA9yGrNK+C1S2tdK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-13 at 09:45 +0200, Johannes Berg wrote:

>  * circumvent PAE/802.1X checks

OTOH, the RX code unconditionally lets EAPOL frames through so the TX
code could do that as well.

johannes

--=-VArrRA9yGrNK+C1S2tdK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwA6D/ETPhpq3jKURAs08AKCRnpMTZRK/AnUt3qdfgArZTOAN8QCgj8gY
NDskkeBbp/UA2f/yu8ZiRqM=
=J4hZ
-----END PGP SIGNATURE-----

--=-VArrRA9yGrNK+C1S2tdK--

