Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37797 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbYIPLHS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 07:07:18 -0400
Subject: Re: [RFC] Implement basic background scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <hschaa@suse.de>
Cc: Kalle Valo <kalle.valo@nokia.com>, linux-wireless@vger.kernel.org
In-Reply-To: <200809161120.09728.hschaa@suse.de>
References: <200809151416.07552.hschaa@suse.de> <877i9czdjd.fsf@nokia.com>
	 <b2d017be9e6908538faef3d96845500c.squirrel@secure.sipsolutions.net>
	 <200809161120.09728.hschaa@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uhQOpwr2nuLVwlEwts+D"
Date: Tue, 16 Sep 2008 13:06:36 +0200
Message-Id: <1221563196.8916.21.camel@johannes.berg> (sfid-20080916_130723_782603_0E78F827)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uhQOpwr2nuLVwlEwts+D
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-16 at 11:20 +0200, Helmut Schaa wrote:

> Ok, would you accept a hardware flag that indicates if a card is able to
> do background scanning? And if the flag is not set we could just use a=20
> software background scan as fallback?

No, I'd think that it the scan offload is incapable of doing background
scanning then it's useless and shouldn't be used.

johannes

--=-uhQOpwr2nuLVwlEwts+D
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIz5M5AAoJEKVg1VMiehFYv28QAKHHowPXmMkogoVj0Q9kTtYb
VYl0+89k+Qv65Qbvv0cOx3OK7dYPwsbGtj/hCf7yUER3cQPs6rruLFZTeMbXjpeG
vPtZ/5E8RUFy59C/M+t37KTkZFB9OUPdns01Woo/cD+QVu9HOV9K+7KI+zacxvtb
Vh5qEBSUks5Hcx7bacL7Ntpau2ydw4nETSyaAA6HSEm3i8Lchm8Im6vFURe7k0oQ
+7sPrGdkMuL3dIYMJsyFt+H/En/COe+FdQHEH9s+ldV8cP90YoG3rMwjBN1whZRj
fgPxiKjt9W51bwyqvVOjEi8KKTtQPkArTXjEdRFUmZkOFzgXqRqu5dSiA1XLLyso
G3Yid6R13SXdJBaOlBIhZrmp/BADmdVZX31tCdxVHknnfdAg5OAwdCH05Hlj29GU
KPwqeOuo3aMsYAmxVC3fsN5rY4Rqiml2KLpgDV3nV6TOhVEc+STGPOfv9I6l1UKQ
8hyZKdOZwFlh8aDk76U870VsZIBPw14QUZkk02RA1FKzHi/3j7OC9M460IZgN95q
ZvAZYGyPWexsQpoTFyz9xdhB6ZaL4oyEtuHbQ8QzeNXCJdtZ+ufHowrnrFj7v07p
oQ6/ifk1eAU2flEixHo+blTy/NJNPFvRsOVhOP5SX9zZvEl+k10b4bQDThw/8aNQ
GDNbyz0P0DZxgKEaF8n8
=Yi9u
-----END PGP SIGNATURE-----

--=-uhQOpwr2nuLVwlEwts+D--

