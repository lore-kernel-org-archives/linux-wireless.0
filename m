Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52381 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbXJEOYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2007 10:24:19 -0400
Subject: Re: mac80211: What is get_sequence_counter?
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200710051606.06382.mb@bu3sch.de> (sfid-20071005_150650_055031_29813997)
References: <200710051556.27401.mb@bu3sch.de>
	 <1191593004.7367.32.camel@johannes.berg>  <200710051606.06382.mb@bu3sch.de>
	 (sfid-20071005_150650_055031_29813997)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bf6gmXsnBb4dAh74u2Ht"
Date: Fri, 05 Oct 2007 16:24:45 +0200
Message-Id: <1191594285.7367.34.camel@johannes.berg> (sfid-20071005_152424_375994_C956559A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bf6gmXsnBb4dAh74u2Ht
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-05 at 16:06 +0200, Michael Buesch wrote:

> Ah, ok. It sounded to me like it's supposed to fetch the
> seq_ctrl counter (data header), if the device does frame sequence
> counting in hw.

Ah ok, yeah, it's badly named.

> Can you please rename that to something like
> get_tkip_ivs() or
> get_tkip_counters()
> or something like that?

Sure, I'll add that to the patch that uses it.

johannes

--=-bf6gmXsnBb4dAh74u2Ht
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwZJK6Vg1VMiehFYAQIXjQ//XQv5ABog8PruDZyV/TTFMakbt5R+VWjZ
WmE0RiPgwVOb2r3aD740bP3D2cM/hfvalmSJBv7QZxuNrkBuWbkz3MspIqFCzBgX
dZ8EUfkNBSzHo/8/6PnibEA2XVMp8aA3lvDGvHfQU2d1aVn4MQUbxrNtbn4eJXOI
1qMJgNL7I3vqaDytzeOY3uMslwRMqtgk52xf6KwspIl0MvilAujvRAk/9xdg6auL
MqoSzCR6uSGTIw8T/jIX7GhL9CllSeP6JJJ/zJfULtSWjLux2/3UTMCV97axhSaw
sCs9Iir4PHUZGG7R6bohynjl+ipKuVncLPs6nQ/GwmzvVHW6DpWecwNf//E5D82J
TZbtwISjKNssUAYcUmUZfLTutGAZHqVsl2kPQZMxD3WmA6V1ELUjj/DxkVfqQRzw
UfmDa4/AlnXtylsIqOYj/9QUw8esj+QbhPObQLFxY1JWV4aMQcN4Zw5gesXONcfS
3BXDxUMxZfz9SoLsKPw00430otazSuhqckZ24Iqyi6ikFKjHpQxzElvNg176I2DB
gKp09nffCjhD9gRLGIbxK3ReTkwzCNUM+RJegX1bjVPqSxPLCZPo21eyAWftC9EU
f7hD/fy5vn27c+mEPWI0I7ocUC7nrK0HSXhOgBPWYk41Pil2iGEg2w4XSANHXzSy
r3e7H7T/AHk=
=19fk
-----END PGP SIGNATURE-----

--=-bf6gmXsnBb4dAh74u2Ht--

