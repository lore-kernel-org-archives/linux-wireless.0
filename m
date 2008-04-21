Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58673 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752830AbYDUPNU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 11:13:20 -0400
Subject: Re: [ipw3945-devel] iwl3945: Disabled channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Brian Morrison <bdm@fenrir.org.uk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <480CAC55.1000704@fenrir.org.uk> (sfid-20080421_170234_346603_44E35F3C)
References: <fuhkfp$mnk$1@ger.gmane.org>  <480C5AFF.5020005@fenrir.org.uk>
	 (sfid-20080421_101455_395583_495A4EE6) <1208785818.26186.101.camel@johannes.berg>
	 <480CA260.70506@fenrir.org.uk>
	 (sfid-20080421_162006_486515_D95FEC5E) <1208788898.26186.105.camel@johannes.berg>
	 <480CAC55.1000704@fenrir.org.uk> (sfid-20080421_170234_346603_44E35F3C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sMv7IHl6IT+QWtm4Tas1"
Date: Mon, 21 Apr 2008 17:12:44 +0200
Message-Id: <1208790764.26186.115.camel@johannes.berg> (sfid-20080421_171411_208050_7EDA7DC9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sMv7IHl6IT+QWtm4Tas1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[Can you please not drop CCs all the time? thanks]

> That makes it all very difficult, I think that an EU domain is OK=20
> provided that there is also a Spanish domain. Or maybe the EU domain=20
> should actually be named ETSI (which was my original preference, it was=20
> John Linville that said EU hence why I used it).

I think we had ETSI in some of the original proposals and I think that
makes much more sense.

> I'll have to see if I can work out what the allowable domains are for=20
> the Ralink RT2500 drivers, under Windows for instance. I know that are=20
> are considerable number of choices, certainly more than US/EU/JP. That=20
> might provide a good clue.

I'm not sure we care that much, we have a huge list somewhere (look for
softmac work in this area from Larry Finger)

> Does anyone know how the EEPROM contents are supposed to work for the=20
> Intel hardware? How they are queried and compared with kernel and=20
> userspace programs?

The EEPROM is queried once and that's all the channels you saw in your
iw dev wlan0 info output, then userspace restricts it further. The
hardware also assumes you never move out of the country you bought it
in.

johannes

--=-sMv7IHl6IT+QWtm4Tas1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAyu66Vg1VMiehFYAQILSA//fam42+wxfX5AkXM2T9wwXRMP6Y3uVsmZ
I5j/HMe/4cNdoAFPNOJjSGT5D9boqxNrmNs2z+uurcoaHLyTxlrxoRgH5yhEtrJT
yXkluAxrKTcArytQKr6DSx40X8HCRNay84s7Lv0x9nsfOGYo8SX2TvOaEt/vmrzj
nfl38flxtPAiVhQ4ELUQcDLn8AwqCjSnTBW/5fQNn6PqoNfeYe5WqEeykX4aJnEv
LBK2Zz5qm7+enxGJvISFSFXmnb1fPbHvJsPYbCt1QPx8m1v3jmLT6o7NQZBaij4l
He2hTJ/FyYA8HAz1Q0LVE+nFesdnwijioTif/rD1vsL7Blmdmnq5X6ifseEEJAiU
coTjXYtGGk/fkP2+Hi9YOXRn4EO78DSOW43pOYkQUojVo3QgavcZ/6UIAJ8Nvh50
md5pfOw6dqsnbLqWZ5/G6WFeKDTP7oKcMMaoAYdDMbgeFj6hdMtMpGTWh8NNnvVH
YpVdepM1YhRk9GCx+xYo3Q8ct8Pj1uFfL4ig+oGAFCJ4fgJjWKJgO9Hs91m4q/Wm
03RxcpkB9oaqb00MKMZBiNbyt+us4ekE5S9OcD3+W3SGJDUPsmI3UYbJmo1N8WNM
i1wMFAK6d6itL3JKvKDp9Rs6FiFDcno5F3Blg9vfK7OZ7Ko3KApL6KR0MIzuu/5y
3SFOIFnUQN4=
=5CJ3
-----END PGP SIGNATURE-----

--=-sMv7IHl6IT+QWtm4Tas1--

