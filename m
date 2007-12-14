Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35021 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932213AbXLNMSI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2007 07:18:08 -0500
Subject: Re: [FYI] hostapd with mac80211 progress
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Tomas Winkler <tomasw@gmail.com>, hostap@shmoo.com,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <20071214033807.GV5698@jm.kir.nu>
References: <1197512614.6558.224.camel@johannes.berg>
	 <1ba2fa240712130635n44838ac4s5bb606e5dc27fdeb@mail.gmail.com>
	 <1197567363.8313.31.camel@johannes.berg>  <20071214033807.GV5698@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MAGniyPX5tlqQ9FAwgEs"
Date: Fri, 14 Dec 2007 13:16:23 +0100
Message-Id: <1197634583.16079.40.camel@johannes.berg> (sfid-20071214_121822_910657_BBA930C2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MAGniyPX5tlqQ9FAwgEs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I'm fine with patches that are either specific to driver_devicescape.c
> or are clearly not breaking other driver wrappers (or core hostapd
> functionality) as long as they are somehow in sync with a commonly used
> Linux kernel tree. At some point, I would like to limit this to proper
> kernel releases, but for the time being, any development tree should be
> fine taken into account the current state of the AP support.

Great. I think all the remaining patches I have are specific to
driver_nl80211.c (I think I sent you the rename patch, didn't I?) I'll
send them to you as appropriate, I think the beaconing/station and eapol
stuff is pretty well fleshed out right now.

johannes

--=-MAGniyPX5tlqQ9FAwgEs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2J0FKVg1VMiehFYAQKUTA/+LNL/Dv1k9j8UKzIGoMrfQfhEyGgUFKP4
sl2FeaPU77ld3wqzaaVd6oqP099Ir0+HGmRYi1qY7PGxUbZcQyj5T/cnuuphTpyD
F7pH6RalFrSL5sFPQNTSjKsqhEPpE1c+qiWMLEFftu8We+kyTmkM9n1Csyc4XViA
SHRGIA6UFEmVYzbYVMcNz3YrjQjqxBYu6pKlJJmppGqkkHpVkxnKOZtzUewvQjeh
DVNw/ArENLAJ7s3tiAP34S7huIsQJUU1vrnM1qH2L+xTOrLSR4zYMHCp0/ev8jc8
Lscihf7anOPYda+3DaFEO8DW9ovrweoeqhbD+WEtOFbcSbeR/WCfts3TU53fz6hz
Mc8nldKQI9HFQ+/oynj+VUpB3+qD8gaYyoJV4JZSQGmpWRbUWb17MdG1XTc1bojo
hFu2YxxCgu0keunlUYO6ey3RmAIxHjVjAai27N8yXZsUrG5lJ0AWfVtVX3C8ELyi
TksGcXU/gz6AyHRdiCkCQG39g6shC0DDozPDMQZzvAEnRFTkAv51Vjf+kUIqXcFW
H85JbOLBvB8PEExTQnzeVYzIgkw7oDD9FqLlaOcXrzXhC9vzBUqbbQss3roZbqZw
16Ux6VAWRAwJOdXhxV5PlazieMSLbmI8M9xBEyiTPvfbVTMbznY7KeEpn9dE/GjH
18+lqCQjn7A=
=266g
-----END PGP SIGNATURE-----

--=-MAGniyPX5tlqQ9FAwgEs--

