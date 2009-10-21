Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59194 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbZJUBKq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 21:10:46 -0400
Subject: Re: Rate information in ad-hoc and mesh mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Charles Gordon <digigordo@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <86201b3f0910200710u36557bf8uf5bc014b32b14d33@mail.gmail.com>
References: <86201b3f0910200710u36557bf8uf5bc014b32b14d33@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-kdVUiU0oY1LkjEFfX720"
Date: Wed, 21 Oct 2009 10:10:33 +0900
Message-Id: <1256087434.4475.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kdVUiU0oY1LkjEFfX720
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-10-20 at 10:10 -0400, Charles Gordon wrote:
> I notice that the ieee80211_ioctl_giwrate function in wext.c only
> returns rate information for stations associated to an AP.  It does
> not return rate information for stations operating in ad-hoc mode or
> as a mesh point.  Is there a reason this function is not supported in
> those modes?  Is this a deliberate decision or just an oversight?

The former -- there's no single rate when you're talking to multiple
peers. "iw wlan0 station dump" would show you the information for each
station.

johannes

--=-kdVUiU0oY1LkjEFfX720
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK3l+GAAoJEODzc/N7+QmafjUQANFo4nHUuLbkm/NdhLRwxkzO
PAdeD6OXVekTe8gQ41gPeoTrbOStSYGMJBY+Ex7agJlCkv2ia5QqzwZ17amFVyw9
NT2bVQYoWF4bU+czW8QcjXGWRGMJoCZKjaMCCw7eyYqDi9ErdEiaOCfqiKvlSJDq
0v69+xUXIrqy/tY6GMPf6cWiOTuXPyGuGAgSr3k3SAMIOlFHt6a9Gf1d8+TeOGJb
86zKUGylwBeQ2UnyfQdhRYkQgIPmDwh/MVUwqX/W22T/y7ezlG5UidxMYbvjgUy+
aQIirUOSsx53cXuaUjrka1bdgdKQ0TijC+A/UnIDFrO2B0vjYXvxNWGnLo/OWRnS
zibtEeswi7PnmHHyy2OkC6oodRwt6/zNGul4aBu/oST1JQgKEUfq+eyyS7PcLxdW
0yBWueqQjsIysqqmQfkvJOaYeYEtWpCZO0POnZ4tRFq0KqgJkgpRQY5D93udVGZ7
NlMQxl1bO89iUL1JwFH64PKa5ex1AQ2CByTZRr6UY2BobTKVZ4gvbAbDPFI9lUYx
tBoBegc5OKtBW0jXI3dftnNVuDYRmqOVSHCuoxQCm90YcOMDQuCKHWSxamCaKTUS
mbqDT+XZIOvyJqnxTEZIdwH349Dy5YLt+UAf0fuOszqpIv6/vb/dNl6e4G79JD8E
PHCDf1XMv8rhIeL1rTqz
=esAu
-----END PGP SIGNATURE-----

--=-kdVUiU0oY1LkjEFfX720--

