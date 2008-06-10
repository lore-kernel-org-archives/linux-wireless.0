Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36365 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033AbYFJNMs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2008 09:12:48 -0400
Subject: Re: mac80211_hwsim - simulator of 802.11 radios for mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1213103378.3668.10.camel@johannes.berg> (sfid-20080610_151025_565793_E08CD049)
References: <20080610105058.GA6961@jm.kir.nu>
	 <1213096575.3668.6.camel@johannes.berg>  <20080610124724.GB6961@jm.kir.nu>
	 <1213103378.3668.10.camel@johannes.berg>
	 (sfid-20080610_151025_565793_E08CD049)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mqebivIOmOudQk8jz22R"
Date: Tue, 10 Jun 2008 15:12:10 +0200
Message-Id: <1213103530.3668.15.camel@johannes.berg> (sfid-20080610_151326_469232_2EA79F6F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mqebivIOmOudQk8jz22R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> The design I had come up with a long time ago allowed userspace to
> control each radio by having each _radio_ have a raw netdev like this
> and not doing forwarding in the kernel but relying on some userspace
> tool, but I guess that much more complicated.

I should mention that I have notes on that:
http://kernelnewbies.org/KernelProjects/Mac80211TestDriver

johannes

--=-mqebivIOmOudQk8jz22R
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJITn2mAAoJEKVg1VMiehFYTTUP/jZoeSNP/v2YKCh9eKkrlSlY
EMD3ZcHUW1kK5u3Vp/ei0GnkBp5OezoDPtA1gSwyzXFgKrtvwDoWAUKhqq7EyCZ2
lKjaCkdhfh4WiBHpfclpzLezdWJcBkVon3kDTKAxRlHcaWNl69kfwZAPMUzGK2SL
AomcC52pG1YESEULOXei6tfB5nw57cyh9Vbg4cuNzNLnQOdT5GhYtLmjljoGPP28
t9QOEk/Cz9wzSVkOcEEfkavy6T8nW2O/gbSpkvibEXglsZtBK3xtnZDwGqUhr1aA
sLOny9ZCK5z16TAetDOoFzV6zHr5EwpQ+dIqGHXjXxd6LT79gKz5gtOrct11/GdJ
DKUi8LVs7ZnK20ZaAMOOgCIa5c6EARjKausrrJqMVZkCa9ZVhiz2G0wrwXvtplni
aFuGPh3irI2mhpPXdGwg944PP2Q85rqMWZtAoDiv13VcqoL2J9wNtceWnWQYr8v9
qKIYt2xXikDr6aFc8eRwsvoyKY92xeN6fr7V3xK0nEGIxqZ2yF3nnp9J+qMrCoZe
FuDF0jaNMw7la9w453E6Aap3AqwtWC++0lpQwhusRv7YjyNd2+WjD7I13ybnMlqe
NUTwhsK+VETlFu1qk1pF2W+8bL9vuD9AExo1J9bcS0QLD/rfIQdbP7LIByS9UQTg
uwlJ+cPb4OCHFP+ir5G5
=OL4e
-----END PGP SIGNATURE-----

--=-mqebivIOmOudQk8jz22R--

