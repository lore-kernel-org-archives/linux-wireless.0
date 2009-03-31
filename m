Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48431 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZCaSce (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 14:32:34 -0400
Subject: Re: [RFC/RFT v2] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <49D25EE4.6020202@lwfinger.net>
References: <1238349195.24972.5.camel@johannes.local>
	 (sfid-20090329_195345_745378_2F2074B3) <1238451390.5970.59.camel@johannes.local>
	 <49D25EE4.6020202@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-dUKLQme3aL7kQQ/nTetr"
Date: Tue, 31 Mar 2009 20:32:01 +0200
Message-Id: <1238524321.5970.115.camel@johannes.local> (sfid-20090331_203236_835539_4648256B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dUKLQme3aL7kQQ/nTetr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-31 at 13:20 -0500, Larry Finger wrote:

> I was alerted to this problem when I was unable to shut down or reboot no=
rmally.
> Those problems are fixed with the patch

Indeed, thanks. There's another, similar, bug in another function --
I've updated the patch on my website. I'm going to implement the
"initial state" thing now and then resend.

johannes

--=-dUKLQme3aL7kQQ/nTetr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0mGfAAoJEKVg1VMiehFYReEP+wTknAAvqMcmwJS6zZKF5+LA
fXHgkAmp7Jd0HD5ROQsmW5CIXWpTRyMRA+B2qxXxiZyg8LJrjE5RwdkUroLY5gfa
PU3t32RXF/7ldLDB4VTdrMJF0ftvnY//yjMDqpQ4nR98eZhS7cUO9Ra+jIGHGhA6
vh9vg0B5QuhzMlgVQtGXOJSR2G1lVyN2uAv4AqCFfellzRh4Ajtm5KbBK2Ex+6jk
jwxfyz8lLC8xEZ6Kc9dkZVIwasmSWnJNz5wI+b9QNG8I9E/ZbjEDXcVwraz9swaj
jVcD7hCDtBMKx7RQiYpVfmNUQajiy25JNBga3QD6UoPn/YyBTdWmcoBgoYE5rNad
IFmhw5FIuX5vhrXtjZ8/rvRD+5FlxlVC7DhNKEA3ICCy5NWjiKd58ulcKG6TBc8/
6vLHYGmCBZMFMb48uq8RKLvVB5AdZeKuPketv51FyO0U/vm2NoaPNHO6WiuHjSyg
LIZS6hJvbRlMSMTk5V/n3BGbGQhB7luZWwz4N07uRZxg1wpzAhFKUt5JsTwRhn3u
Dbd9N2OdpLM8w7uqUN9ALWqHNmWEpVd39OphQpCnKI/fKObGl0UJMu9X57d9yz0S
SdVQA38jbQa3BRc4/m2fuDu9tNabNsFD44pCbQWARMAQtfmRaRjjSLmhcUZdvoEX
gJc6VupOUD5ryvVuc7hG
=Dhkt
-----END PGP SIGNATURE-----

--=-dUKLQme3aL7kQQ/nTetr--

