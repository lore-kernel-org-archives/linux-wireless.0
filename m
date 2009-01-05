Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41426 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbZAEWJR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 17:09:17 -0500
Subject: Re: Problem with rtl8187
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <496283F7.7010902@lwfinger.net>
References: <496273D4.6020600@lwfinger.net>
	 <1231189302.3697.25.camel@johannes>  <4962775B.2040205@lwfinger.net>
	 <1231190634.3697.32.camel@johannes>  <496283F7.7010902@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wQZ/g3yiIRrj7DFhf/oV"
Date: Mon, 05 Jan 2009 23:09:36 +0100
Message-Id: <1231193376.3697.44.camel@johannes> (sfid-20090105_230921_594466_69058A06)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wQZ/g3yiIRrj7DFhf/oV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-05 at 16:04 -0600, Larry Finger wrote:

> Thanks. That took care of the WARN_ON message and the SLUB debug messages=
;

Ok, good. Want to adopt that patch and formally submit it, or want me
to?

> however, the device will not scan until it has been powered down. I'm sti=
ll
> looking for something there.

That's a bit odd, but I'm not sure I know how to help you. I've seen
things like that with ar9170 too though, if I rmmod/modprobe then I need
to unplug it to make it work again.

> Are there any other mac80211 routines that should be fed other than error=
 codes?

I don't think so, no.

johannesNone that I'm aware of, no.

--=-wQZ/g3yiIRrj7DFhf/oV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJYoUdAAoJEKVg1VMiehFY9oEQAKWH8CjkqvhK+e49jP782Rg7
CcMIdvagNnCDmx3jjEUO7diQ9GAjnglisDFLvxZ1WVyz6vIJO7BJYC+yHMBtQDi3
SNJi+/rF0h9GMrg0pcOQq+9lKo8qiQ6GVOVBsTFrG5ut33+LIu2CYe+5Dc5RLyXr
UT3Cl/fQGo/0sQPUx/zcYGdJ8RZaiMNqvrPnAfP3L0Uog5r4Co3NWp7TBPXFD456
WyUMVf/aebwZUeFz/wVLquFYSrV1gb6pc1yJb/VPofEu3uqZAydvWJZg5zaWZ1/8
KYpxzdS8Bq8IS3tys6E3AZ5V4h3JI/rwOCE2HXm48LXVqa9RuuXQiGKCn6Nd5tpw
2RUotibpbeP21OL7xFqwU4dJTKThagv6OEsqX3bsAD5EZ52hvreDYVq7aW+QsciD
flwkIYaIgKXBNmp/dDsVVDvlCrCmVKoLtH6ROP8d+kGbP6T41LpBYhal+QSPzkyx
HO1rTn3Si4nAHj5XyrN9eTyzHlLVytz3v/m6VboI6oARNVcfUOYr+4+gsmpnrhLz
XkNc6lvnva9yZOfDfeJ2DbIKelX6w6+gd5DRHfxCIzrmowbqd9z4PdxZ0xU3uE23
ny7vqaRufEnWvEmYQqThK0izloKLdAT7bzEHBl/9kir9SYYifRIUBO4db54Pf48E
4rBo6GxM3UZkerrmRrdQ
=xVva
-----END PGP SIGNATURE-----

--=-wQZ/g3yiIRrj7DFhf/oV--

