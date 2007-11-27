Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56249 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbXK0O6J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 09:58:09 -0500
Subject: Re: [PATCH (2.6.24) 0/3] last minute iwlwifi fixes
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>, Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240711270654r276657ch4e56e543a3c4a427@mail.gmail.com> (sfid-20071127_145443_304720_3148433D)
References: <20071126225416.467939000@sipsolutions.net>
	 <1ba2fa240711270654r276657ch4e56e543a3c4a427@mail.gmail.com>
	 (sfid-20071127_145443_304720_3148433D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qzU7Ezo39tP1HABOz42r"
Date: Tue, 27 Nov 2007 15:57:56 +0100
Message-Id: <1196175476.6058.25.camel@johannes.berg> (sfid-20071127_145811_951443_0F9DC168)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qzU7Ezo39tP1HABOz42r
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2007-11-27 at 16:54 +0200, Tomas Winkler wrote:
> In general it is possible to change the mac address and there was a
> patch for it if I remember correctly. It had some issues so I nacked
> it, it slipped from my attention after that. I'll try to dig the
> history.

Thanks. I didn't feel confident enough with the driver to make such a
change since I have no idea where it should/would be uploaded to the
hardware and whether maybe the ucode gets it from the eeprom too etc.

If you can get a patch that makes this work I'm all for it since the
mac80211 hack isn't too nice anyway.

johannes

--=-qzU7Ezo39tP1HABOz42r
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0wwc6Vg1VMiehFYAQKFyg//e2U6j+OaMiQzf7n4e65bry/a3Iwygzko
Rp4aaShqdnhCZ00Ut0vkuW3MkC6hbNW3+OTO0KUZ4nMOYoIM/iQMSw5U69gVamXh
Ct33We3cO7YjQ7I5YH3uEdVcRrTKdIXTK5qi6KDKauK/3HFWzrxlW8+d4AUzq+zb
UN8IflTPzQDSxdlbRRJ6fTqXFQ3AkBi8PrUXJ+e2decgDJG4eE9pIZEQSxnnPo9B
P6rxosEdjD8aVq6RqrCcaP7mqHEuQRNyO6Y5GpRAz5d6oLIko6X3tz6+DMfrXlm1
k8+EbZh/z96c4duH2HYf1nb1eAEs4DAK7ajjqE+q2E8KftWNMDzblpWyu2eiXQLI
pGxq3SQK7tsXDLqlsgVtTASdww51UUDBf1okGCMPnoDRBL5v9uoLL0mSDSoUpISc
BUgXHEWlUeZV+SOEzfYqajD7grzsV+UZVrCbQZRD9GhF/v9+qTxN3MwslBRWlvBA
ZwVWfRMpjEkymqes5v2Ni+k1eP1lar+zG2K57fvqMwyNgQwm8oTu80W9v8XYAKsr
4Fm7q7Xy1qSNm+/KD3QX5aIALEFryc7CDGZi8mPmQ48u/Tt/n9TVxgSdX1E7fHLs
Jnp5GsB9v/SluOGkPvzhi0uwNMNp2mFSGDda+KaQ6DTzVmr7afAUoYb/c0Rr8c6o
mpbPkc6gWyM=
=iVk3
-----END PGP SIGNATURE-----

--=-qzU7Ezo39tP1HABOz42r--

