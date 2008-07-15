Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49875 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbYGOIPG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 04:15:06 -0400
Subject: Re: [PATCH 2/2] mac80211: make listen_interval be configurable by
	low level driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: Tomas Winkler <tomasw@gmail.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <87od4zd34j.fsf@nokia.com>
References: <1216038684-29725-1-git-send-email-tomas.winkler@intel.com>
	 <1216038684-29725-2-git-send-email-tomas.winkler@intel.com>
	 <1216039127.11189.15.camel@johannes.berg>
	 <1ba2fa240807140546w4f08e32l59ed88dfa1b86403@mail.gmail.com>
	 <87fxqcoaue.fsf@nokia.com>
	 <1ba2fa240807141434k5260e6b9q6468b450fccba3e7@mail.gmail.com>
	 <87od4zd34j.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BaSVkThe7vn9nXKoL7zX"
Date: Tue, 15 Jul 2008 10:15:00 +0200
Message-Id: <1216109700.23746.25.camel@johannes.berg> (sfid-20080715_101509_878841_2CC370E6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BaSVkThe7vn9nXKoL7zX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


>          sysfs?                 register_hw()
> user   ---------->   driver    -------------->  mac80211

> > This patch should go in and we can reconsider it when other HW
> > driver will implement PS so we can see the bigger picture.
>=20
> I guess it's a good compromise for now, but as long as we change it
> later.

I disagree. The whole idea of handing an essentially configuration-
dependent value from the driver to the stack is wrong.

johannes

--=-BaSVkThe7vn9nXKoL7zX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIfFyBAAoJEKVg1VMiehFYxykP/3g940Z8UCyHHZ3hi9RwoGto
DN6K5ajMhZx4jZcIIeqDew/yKzLWwTVTQ46AFtAVbuhqso4kztxkGh8Cx0J6OmAy
QdL/4+p4bhuHLgVLrMBNAcJk+W6HReutvilTYJvHg8V3tQ/dFDUWOvmRAq5xrfUE
AmlWhHBrt1AUFvEWTIpF268mlAmIJaxgXSDP0JtH/SXnyCX4zE1PYtmOgAM6buyJ
Oq/MDU0ZTqHkNmKqCaYQIaD7QBkRNPpMUBnE2z7Dyzic0bugg1O1IOtOxw9lG+83
Ko6YDi8E73SyYK+kVS0sGOpl8bH4BMw7MULwAyZeLkfDeBByopSthj0tLQrFE5Id
O5N0/DyLoAhKG2siugLqgcyp3BvUw3FMmKd7dTPTs5BEOJ7S8Z8SfzTAEewOooJU
I21ck0ph1/cJcUffMtmYS305I/qK/KKTLoa9e31ADNoGS8VwwYFeo1nA5nXKszRk
zQa4C23sztz72eBKm1r7GLuEoPBn8wcBszIiF/5Wb6fz1pW4UL8e2F9x6+ubk/8D
FcQREd6FpbOb1h4+iMk24k9sXArQe9hk6Ju848CdmPA/ftTc443tPjoHK/mn7Xhd
uqGmLnlzxqQYWvB1CLIamehpgjp/8ESpz/tFKJwk+gi7ZU1/mId7CiKVuCj9VAyU
ZJpEQxFJEt2Wy7c+24lC
=RDtQ
-----END PGP SIGNATURE-----

--=-BaSVkThe7vn9nXKoL7zX--

