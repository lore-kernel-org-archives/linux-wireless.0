Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41005 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbYIIGbF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 02:31:05 -0400
Subject: Re: HT action frame code
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, Ron Rindjunsky <rindjon@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240809081348n17a3b4c5o4d67e989dfd79030@mail.gmail.com> (sfid-20080908_224836_459694_C698F094)
References: <1220883730.31304.60.camel@johannes.berg>
	 <48C5868B.8060103@w1.fi>
	 <1ba2fa240809081348n17a3b4c5o4d67e989dfd79030@mail.gmail.com>
	 (sfid-20080908_224836_459694_C698F094)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LizrL9tK3QZvadMILCJ3"
Date: Tue, 09 Sep 2008 08:30:59 +0200
Message-Id: <1220941859.31304.98.camel@johannes.berg> (sfid-20080909_083109_992948_CA240E1F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LizrL9tK3QZvadMILCJ3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-08 at 23:48 +0300, Tomas Winkler wrote:
> On Mon, Sep 8, 2008 at 11:09 PM, Jouni Malinen <j@w1.fi> wrote:
> > Johannes Berg wrote:
> >>
> >> When we're an AP, shouldn't we also in some way honour the block-ack
> >> action frames? Or will that be done in hostapd, which then sets up
> >> block-ack via some unspecified way?
> >
> > The current design assumes that hostapd takes care of all management fr=
ames,
> > so eyes, these would need to go to hostapd for processing and then setu=
p
> > back to mac80211 through some new command..
> >
> Enable BA in AP mode is really trivial. It definitely worked in our AP pr=
oject.

Well but we aren't processing any requests from associated STAs, so
maybe you only had aggregation enabled when the local rate scaling
decided to?

johannes

--=-LizrL9tK3QZvadMILCJ3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxhgfAAoJEKVg1VMiehFYkVIP/ikzgeto6+Wzrc46xHxnUV8B
BYG2P4DE3SHVXvaFH6ojrlAJwxh5KZqncavB+V5PYl2Q6DHaOWqpJN1kx4SFZbZp
oK01MGtnED8Mx/aNjik2mOaeDIBtdLNHD5p5peCYG0lv6lhKLXWGk8ahq4FcDKtV
8dqmu/Nhf3KM/oG9hwQjAn6g85XFDeu9cADUKLVHmCJ5QpFlQ9IhJ6zg91Z+1TbF
lRfEML4WItnQB0bvu7NSU2/UIYoOloMYLYgkm9yVDscm8dXoEW2Ni9gwqXcf4HU4
SoXqz9V50yBedh0a08b7I7JsF0ONuBMFTpF1Bj62p/RRBbNVFMizrna9PQVIVdfc
enlyVRqKe8VeqTowKFp/isQiFUQ0uEod2hiEIVuvV02WKJdzwdcwnz9xb0O6/f8t
CgFIs6qR/rOzc7jI31ZYFHmltUaOlik2gEKwDRyfz16vY2l6/moU5ui+iK716sqb
rKBS7bl/6tfbGdVoi6HxLd7b7J81Z4XtPbAa48SbKbBIPzt4RW0fkMCEvPXQIkUf
70c5eHnNIDUNEm7fM/Xp+gGxT4Ur1iv56GbRk7y1NCKvQ90KynAJq/Bbmz7r0TuV
IdnC6JLRT201XepFCwMXHOJqvnhrYuFo4Jgoq+HBMMpq8HASURDh3xMhgckvQz7A
iA+ou7jBBDKFgvCHn2eD
=dV33
-----END PGP SIGNATURE-----

--=-LizrL9tK3QZvadMILCJ3--

