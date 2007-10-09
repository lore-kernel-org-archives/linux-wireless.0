Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54485 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbXJIREv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 13:04:51 -0400
Subject: Re: [Rt2400-devel] Mode selection in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: rt2400-devel@lists.sourceforge.net,
	Adam Baker <linux@baker-net.org.uk>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200710091627.44276.IvDoorn@gmail.com> (sfid-20071009_151132_712958_0EA613F1)
References: <200710052319.10600.linux@baker-net.org.uk>
	 <200710082308.38260.IvDoorn@gmail.com>
	 <1191921642.4013.13.camel@johannes.berg>
	 <200710091627.44276.IvDoorn@gmail.com>
	 (sfid-20071009_151132_712958_0EA613F1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PDp8mPzSXr/chrqMhtQ5"
Date: Tue, 09 Oct 2007 19:05:26 +0200
Message-Id: <1191949526.4013.34.camel@johannes.berg> (sfid-20071009_180458_431121_DFE9B0FB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PDp8mPzSXr/chrqMhtQ5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-09 at 16:27 +0200, Ivo van Doorn wrote:

> The IFS is also passed on as argument by mac80211 when it configures the
> TX rings. The EIFS register is something different, all other Ralink devi=
ces
> have only 1 value for the EIFS. I am not even sure how the device will re=
act
> when the same value is set for rt2500usb.

Ok but IFS definitely needs to be set. EIFS I'm not entirely sure about,
haven't looked at the timing diagrams for a long time.

> Note that the fact that the IFS is set twice for rt2500usb might suggest =
the
> documentation for the register is incorrect and perhaps the purpose of th=
e
> register is completely different.

Heh.

> I guess it requires some experimentation to see if initializing those
> 2 registers differently has any effect. (And if it doesn't, then rt2500us=
b doesn't
> require to know whether it is operating in B or G mode at all).

That won't be easy to tell, but the IFS is different afaik so there the
mode has an influence. But I think that this mode setting need not be
tied to the frequency table.

johannes

--=-PDp8mPzSXr/chrqMhtQ5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwu01aVg1VMiehFYAQISwQ//drKMhwcOo7OdzR5+wEXCcf48xX1dQZbP
NhCroQJY7o1ezMfTABhUIR/I0QfeunojLIpwUSLhyzUWCK2o9dOu3wFwqfBN42T5
9aBm2lVIKtQvcoJF4dC7kEI2iBGTD1c072KiB/zfQ0XK8A7AzdGfEQ+NyNblFY5w
NQ6R+eIq31FYz9oYYc5sSekAYFhseKx4kBmGXx+2zdoBHMQyUqctUBqH8X0ujP9W
BBKrjie+DfAKmdXG19R8Uy4+QtplV5BfFuEzYcvVn8pkBo5zcIqlZb9VC/VpZt8H
1VamgCZydD7HgHt8vvHuc11SUXUrkzT5P0i7gA9O8ifVKSYNJh3Qs1XPu4eveBJi
ykWIsvNLSj1xQ+oXIwYi0Qx2kJmk+gro3n8VDctPtVP2LJDX6q1w1ywkDaxAWPC/
LFXmojYwy2JnhF3AFU0lRky/R7bYn/yciXpLz0nyitoLMwYX7CZWWQ8F/wtWDUoU
Joq8J8u6wtg9i46Tno+5vWF/EhvskkCu1SV09QS0+bCq8N6em+LP4VqwfAjTNe92
ws6MbLNRdaHgO4OhA5P9wo5w/GfWDQT85iwa2ttqDloCJDH/YBHynuPvnSbxgx/0
Bbzwp1lEzVgdXP4TEaE3rX0KOESrAyuNyXvUCC5nPkGXhEqY1B2VmNxEIh7NMV20
OSSXb+vAK7Q=
=HX2U
-----END PGP SIGNATURE-----

--=-PDp8mPzSXr/chrqMhtQ5--

