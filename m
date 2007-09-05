Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40446 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbXIEL1W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2007 07:27:22 -0400
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>
In-Reply-To: <20070905013804.GA388@mail.intel.com>
References: <1188875058.13078.428.camel@debian.sh.intel.com>
	 <1188914651.9942.25.camel@johannes.berg>
	 <20070905013804.GA388@mail.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-r4VkMCWjzR/RfOOaHXQI"
Date: Wed, 05 Sep 2007 13:28:46 +0200
Message-Id: <1188991726.9942.99.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-r4VkMCWjzR/RfOOaHXQI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-09-05 at 09:38 +0800, Zhu Yi wrote:

> For your other comments, I agree they are valid and we will address
> them. But I don't think any of them are a block issue for .24, right?

Actually, at least the crypto thing is an issue for you: it'll be a
support nightmare. Please do what I've been saying in every second mail
now: run this driver against the mac80211 in net-2.6.24. It *will*
trigger a WARN_ON() in the key handling code.

johannes

--=-r4VkMCWjzR/RfOOaHXQI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG3pLu/ETPhpq3jKURAoQVAKCSKtLsZeQdLL0QOaHvZL2UuafWNACfS5WJ
J9YoZs2YcKiJrT5nwsFAEg4=
=e/OX
-----END PGP SIGNATURE-----

--=-r4VkMCWjzR/RfOOaHXQI--

