Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49761 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757996Ab0BROsu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 09:48:50 -0500
Subject: Re: [PATCH v3] mac80211: deprecate RX status noise
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <201002181541.45835.holgerschurig@gmail.com>
References: <1266437114.23447.0.camel@jlt3.sipsolutions.net>
	 <1266447118.12365.21.camel@mj>
	 <1266494831.6261.1.camel@jlt3.sipsolutions.net>
	 <201002181541.45835.holgerschurig@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LgxzbBFt7WsMrj5x289i"
Date: Thu, 18 Feb 2010 15:48:47 +0100
Message-ID: <1266504527.6261.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LgxzbBFt7WsMrj5x289i
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-02-18 at 15:41 +0100, Holger Schurig wrote:
> > Various hardware reports various bogus values, like iwlwifi for
> > example reporting the same noise value that it collected after
> > a beacon over and over again, or just reporting 127 when it had
> > no value.=20
>=20
> I'm not saying that I understand this completely, but for me it=20
> would make sense to disable iwlwifi's broken noise reporting=20
> only. No reason to disable it for everyone if some of them are=20
> broken.

Well it's kinda bound to be broken elsewhere too because we don't even
know how various devices gather the values. With iwlwifi at least we
know how it gets the value.

johannes

--=-LgxzbBFt7WsMrj5x289i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLfVNMAAoJEODzc/N7+QmakJgP/REs7ezihKknWitTWpy3aF3g
q9tGHyk3kzFWUUxpgLFXbCukL5eIKVFM2ZzB9lmijenOQn9Zxb+nq/EFEnlDT2PL
iHLigImOxHth4N+1vYcqtw7hE7PuVwDk5ZuK3QcBqITA1oZQHjgGPKEpZMQFIpyp
Zd0x0ZUPzvRQ2Nxu0Evbtc0iBFpLRzPouQKxwkI8wVXewmvzDaGtbY4GrGdDvIJc
+mLm9wO/5L+2Lns33HqyCIsfflKqk601hrGsnw4b+J8kl+SkRvWEIjxs03OD+V0d
z40sgDvz+54pMW+SV66R9gx2Gff/fIbxVJU0FWhNZWBkF7i99EFTSenP8ECFAJhg
y5bys8MGCHdzpiMZJdJ1mFy8eOXouBr2zL5wqxmghESQ7DbX6JMJlS4eAodFxSf5
R1HzLLjlE7JHDSfnVKcVSMdQzFogn42jO/JeHk8IIxXhI7n08+/e1pe27dpWlzFR
CuAQYYeYt+fO9LyCetHs7feCTuOZ8Oyltqv+aQVa2PfGewFX4hQq0Sscx66ZBu4s
pcu+UhN+LszQtoUo3U7Y/taOND89HfSItO8C220UjFGXesGU/+F75ccFlFy5D396
C+TCgdyN8SfnPYrQ42Z8bGGumU4Ot+zlPzSX2tqN9t2eDGHdnLwpRGtnOjMtpd+g
5FiVMHBRmB59H9v26X37
=N3Su
-----END PGP SIGNATURE-----

--=-LgxzbBFt7WsMrj5x289i--

