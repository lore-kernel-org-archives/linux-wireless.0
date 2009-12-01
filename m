Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34734 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbZLAJvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 04:51:55 -0500
Subject: Re: [PATCH v3 4/5] mac80211: make station management completely
 depend on vif
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1259177274.32372.21.camel@johannes.local>
References: <20091125164614.427835023@sipsolutions.net>
	 <20091125164821.411882302@sipsolutions.net>
	 <1259177274.32372.21.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/dCgCBj9mk2+NT9z58mG"
Date: Tue, 01 Dec 2009 10:51:59 +0100
Message-ID: <1259661119.32171.71.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/dCgCBj9mk2+NT9z58mG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-11-25 at 20:27 +0100, Johannes Berg wrote:
...
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> v2: add missing sta_info_get()
> v3: diff against the right tree

FWIW, the wrong tree here was with the security fix included, so you'll
now want to pick up v2 instead again.

johannes

--=-/dCgCBj9mk2+NT9z58mG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLFOc8AAoJEODzc/N7+QmaKI4QAIoqw7E/UoP4i22JAXKv2dyG
8rHmD10NGGfNqmbs2OmUl8l5Wv8vKz8KptXvZ7HP3YZ6xsmv7J1Bbh9gEbQCO1sh
ooX23fvEVQusoLOZwUxyNVYs3jgm2c2iz0ddDVn0Z69SzIahZS4IFTXmUBtFJNiU
+cclQdUqcrY4fVwYvFQozYjPRZ0nA9GniMjJKGpjYczFwXxc4SjuOsZZ1PzYv010
YRx5t6RG9OpDsAKSiOYu2U3WcoCjPsldwd9R2JmjxFHa8LJd2MzqB1BhBylQRL3c
6rjQHr91Jzq1YfV4JrBufhWBIAqxq/KOqWlAYyqOehdG1NyU9llEtfsM+yr2fguA
es63AtKAS3sgkZ7Yrf+gMLfeP8XUs3/WbmIS6dq5pHCAZO4SuYTmybPPMrvnlsLi
LM6axUnlyKmgdDWPWPp2lBvkNyYZSowlN36ZKrZ71feWV93RmF7bie5QPs5hAnBE
jtzwFWA+XI7i7JezXIFD3P2KwNsve9srB4oLZRnEyO7pI5pUgXaHJ2E/7LCCXiz3
vqKBQX/EQgS1oFNjh/K70UkqxDpY9KpEQxU6F9kwVu0OQNvRahVOXZfeVDw6L/Rk
UDtwP3UO9OoU+ZpcinsLYaAR5ON4jK2Ha2OwdLRjryBusapAGLm0CDlQ8BXNlHMK
dH4dQW3irSymuFiFTLyz
=YLTW
-----END PGP SIGNATURE-----

--=-/dCgCBj9mk2+NT9z58mG--

