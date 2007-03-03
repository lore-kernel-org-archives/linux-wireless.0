Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39822 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbXCCL2p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2007 06:28:45 -0500
Received: from [84.135.251.95] (helo=[10.0.0.4])
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.63)
	(envelope-from <johannes@sipsolutions.net>)
	id 1HNSKm-0005em-Pc
	for linux-wireless@vger.kernel.org; Sat, 03 Mar 2007 11:23:29 +0000
Subject: Re: question: /sys/class/net/*/wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1172920691.4966.6.camel@johannes.berg>
References: <1172920691.4966.6.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2tdnMOYuoh3CgNuEfRQ9"
Date: Sat, 03 Mar 2007 12:27:37 +0100
Message-Id: <1172921257.4966.12.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2tdnMOYuoh3CgNuEfRQ9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

And related to that issue, /proc/net/wireless.

Seeing that /sys/class/net/*/wireless has been around forever and offers
the same information (actually, /proc/net/wireless tries to post-process
quality values?? we can do that in sysfs too) I opt for killing it to
minimize support requirements for cfg80211.

Unless somebody objects I intend to send a feature removal schedule
patch soon.

johannes

--=-2tdnMOYuoh3CgNuEfRQ9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF6Vup/ETPhpq3jKURAgYHAJ93BBzP50hYM2KgU+9Gfa/95fiGewCfa7TS
OgokVJfD0mr55tSW2RDPvjw=
=0G+p
-----END PGP SIGNATURE-----

--=-2tdnMOYuoh3CgNuEfRQ9--

