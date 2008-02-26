Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43610 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943AbYBZPjx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 10:39:53 -0500
Subject: Re: mac80211: sta info locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>
In-Reply-To: <1ba2fa240802251630n151a0accn4a1f814e6479e7c@mail.gmail.com> (sfid-20080226_003046_253410_E0EA15F0)
References: <1203677069.26341.52.camel@johannes.berg>
	 <1203693409.7082.30.camel@johannes.berg>
	 <20080222155704.GD3067@tuxdriver.com>
	 <1203972413.13162.163.camel@johannes.berg>
	 <1ba2fa240802251450x4ee13b94yb93e64fd9ebfcec8@mail.gmail.com>
	 <1203980105.13162.182.camel@johannes.berg>
	 <1ba2fa240802251512k15b40d65oee774acebdb953e0@mail.gmail.com>
	 <1203981812.13162.187.camel@johannes.berg>
	 <1ba2fa240802251541r218d5f22j5b3490d20ab508e3@mail.gmail.com>
	 <1203983284.13162.196.camel@johannes.berg>
	 <1ba2fa240802251630n151a0accn4a1f814e6479e7c@mail.gmail.com>
	 (sfid-20080226_003046_253410_E0EA15F0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ymtI21mZ3kbQEExPjiA/"
Date: Tue, 26 Feb 2008 10:59:09 +0100
Message-Id: <1204019949.13162.219.camel@johannes.berg> (sfid-20080226_154005_300831_8C0E7690)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ymtI21mZ3kbQEExPjiA/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Number of antennas is not the same as number of chains.  Also 4965 has
> 3 antennas but only 2 chains.   We have some fixes in that context
> coming this week.

Hah, ok, I thought it was the same. Does it do diversity then? I guess I
need to catch up and finally actually read the 11n draft.

johannes

--=-ymtI21mZ3kbQEExPjiA/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8Pi7KVg1VMiehFYAQIh6hAAq6oAByN05yM/ufLIwTRvH6gTJYsxmBSx
+mwlRr269idBtOb45yex6QOkdTiO76V4N5BICoJHz/sBHzgIu4EvLpcO+f8XFXNY
Wrp7H4b4LTfnrSJfqLvE8FVwLZZmFY97b5wJ7W+qTN4GIE3XZidLI5OJTxEISMc9
6vGo87DVxzhpNifJpYBYHywX3n0KPysDYN+72bPyCSiCUKVXjuJ2LG7X7szezBUW
7nELD633dA55bAO5oWTBzpqftrmLwWe7mCzKyQe2VQSsG2Q86RdqKCn/4yHYx27/
evslfApdQvB2Vv7oneLppSae4EAbPNgeH1AdFv+AXtSImxu/e4Bl+L9KG4sJv6wm
05AtjdsvmrZ1c/GCugQdZK16GIyIAp+MqQizZG+MRYjeO8Wu37l/C1Mmdv3omJrn
lToGOcgCJiEtxST6JVltj4KD3Qypa1xkL/jLXxvXiWKO0BgNMyIGfkulBypbIfuk
igF64JKOkPVrOW1Pe3NwjY4WUJNqv3b7QFT1szrpJeL/vGQZYQmvD5IzJjSHXlpd
zAz88FkQVwVOriW7q48f5JUQckUrc0i18BUQWeyak4zDOWJnE2mZt3etAnG7JqZE
5/wAisBdK8OuWJNa4m009YjLsRQTSm7Aidf5eXuwG6JoX5jYh0lpPyNFYHEVIJTC
Hj8Xhwx20co=
=nOoP
-----END PGP SIGNATURE-----

--=-ymtI21mZ3kbQEExPjiA/--

