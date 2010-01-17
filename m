Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58814 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab0AQT5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 14:57:23 -0500
Subject: Re: [PATCH 1/2] cfg80211: add a callback for querying the
 operating frequency and export it through nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4B536B05.6070301@openwrt.org>
References: <4B536B05.6070301@openwrt.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oD5wWVqUzvVwqKp+nZ01"
Date: Sun, 17 Jan 2010 20:57:16 +0100
Message-ID: <1263758236.28067.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oD5wWVqUzvVwqKp+nZ01
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-01-17 at 20:54 +0100, Felix Fietkau wrote:

> +	int	(*get_channel)(struct wiphy *wiphy,
> +			       struct ieee80211_channel **chan,
> +			       enum nl80211_channel_type *channel_type);

Can you do that per netdev, please? We'll eventually get into having to
support different channels on different netdevs.

johannes

--=-oD5wWVqUzvVwqKp+nZ01
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLU2uWAAoJEODzc/N7+QmaN0wP/07ahsWWTVbjhdAlXWsPbiZx
9oifMhNkSQOmqld5NUeacH7pjvjH59SSkKyxLxwhFZDcVzJ9uihEKbBBCI8S5c9F
BNzY83p84mRc7oakvnfpxmugau1iWCmpL2pX6iR2hR4vGiTl8Ily9y047NWmw/Rq
rFjAC5GccH29zgxWvhwdUcnBJlgvrVE04sAhNM7NL8wZXFs8T5sPzfxPhRBOJFJu
B+Ac9grPTzhuDkJ7aEuAUifgwPkpdarJTLXWbs5MzTc+wLFT2Qq3MItb6Ic5ZILU
bCvCPUE+nrKmRufLJu/FKieiiJI8PgPVlogNBaqsP1tajgYkxTXW7UtBaSizAlOU
5847XuR/kTIb+M/6yvTq0COuNq/MKsAXUHwCy7IuQS3FdYy5A6OGgkInqR1LDNDx
eU91GczOzoE2TveB9cw3BZO4DeBGA3N7dJUR8OzS0i1mvtkKw+LjiHMzcJPDM8Ek
TeAaYgrFU5nQ2sT+KN2QNVNqsrxjnBny/4pAMRbexNFQ5X7NN7FRJZVWyerm2yNh
f5DvS3yMscG7cabNZxoF8x7HQWu/qfxmzQxUcoIlInN+AwQIZYLqK/NOJALFlToL
Vng1PXkHtyi/2YWncifikUkmzPyT/dAoScRcx3h3f/L/WP5fp3WDbmEMlnzZJKAJ
xnfeqynhu+/G30brZH8M
=5fvR
-----END PGP SIGNATURE-----

--=-oD5wWVqUzvVwqKp+nZ01--

