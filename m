Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51390 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbYJ2M5K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 08:57:10 -0400
Subject: Re: [PATCH] wireless: clean up sysfs code using %pM
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org
In-Reply-To: <20081029125251.GC24103@tuxdriver.com>
References: <1225198854.3598.6.camel@johannes.berg>
	 <20081028.220733.88410572.davem@davemloft.net>
	 <1225281291.5439.4.camel@johannes.berg>
	 <20081029125251.GC24103@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZfDThVwrO5GIO8k6ei7i"
Date: Wed, 29 Oct 2008 13:57:04 +0100
Message-Id: <1225285024.5439.14.camel@johannes.berg> (sfid-20081029_135715_901869_467CD704)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZfDThVwrO5GIO8k6ei7i
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-29 at 08:52 -0400, John W. Linville wrote:

> > > I'll let John get this one.
> >=20
> > Hmm. That means it won't get into 2.6.29 because John doesn't branch
> > from your next tree but rather from Linus's tree, and thus we can't use
> > %pM yet. I can resend then, doesn't matter much.
>=20
> Not quite true -- wireless-testing doesn't branch from net-next-2.6,
> but wireless-next-2.6 does.  Often that is a benefit for "just
> wireless" development, but sometimes not...

Ah, ok.

> I can push this through wireless-next-2.6 only (i.e. not in
> wireless-testing), Dave could take it directly, or it could just wait.
> Any preferences?

If you'd take it to wireless-next-2.6 only then... we haven't touched
this code in a long time and probably won't again soon so it won't
matter much if it's not in wireless-testing. That way I don't have to
keep track of it.

johannes

--=-ZfDThVwrO5GIO8k6ei7i
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCF2cAAoJEKVg1VMiehFYqa0P/0Xk7TSaEZUXA1pkPkDFzlnp
SaI/iWopGh+tecKp59wJ0lk56R3jRtH8ilg4I5lKEagC7vK/l9xXGnsZl9sxhSGF
1a3hIcE+wlABPghzDLDSnuL7HDtugZI/2kXedlvX+2jPFLUK9KlQgjKngc0zwxy6
OyHrT6PWQX8tSy369UQhViixcRBRB2yd5wzdxSpFvHHDggoZU7EjdYvubcNKzawz
L2TlwoZ4My5KPa5pOeD8W1a0mVMhU7rQdZQgW/jDY21FN3M6ACwp5YRITi6/PbMt
8wmhmjRFwQpHCMYdY4Ijec2Uu3K9VlQVqKIJIn+I1Lq2Bq3ABBBWgsi366/OtW81
BPcGeOvLcT//yOqwo2aZk0CwCP2hExyP9l+ERxWdDzkaDW81EPKQfJxnmymfnxmm
rt6RmVsValdJcNP3bwCEifKHMiG3OrrBYsbVgPvRj1OhgyA126i9ANBQs7PMb699
4rUi9n4yAMqVifMUbxTTAv4wyZCQPR6yqG9zgiBwEo1dNJoh4lBvOluQogKsUwJM
FuuKVSW1O8GYT9Yo9bTWHOCHEETPIU4ZFzKkdF/qhUdAQkvopWSm+NPalFdehzLD
SFJ6OCVg7c2Lm8TvfvAQmEy5NY3KBiMCKibzwWnOZfhFpJGcX6bq8RXNET8XE3g2
W+qZIS1E5Tz7LWzkDSxq
=3l6m
-----END PGP SIGNATURE-----

--=-ZfDThVwrO5GIO8k6ei7i--

