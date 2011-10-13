Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from H144.C72.B0.tor.eicat.ca ([72.0.72.144]:52987 "EHLO
	marcos.anarcat.ath.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab1JMCbK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 22:31:10 -0400
From: Antoine =?utf-8?Q?Beaupr=C3=A9?= <anarcat@koumbit.org>
To: Ben Hutchings <ben@decadent.org.uk>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	645055@bugs.debian.org
Subject: Re: Bug#645055: realtek 8188CE ad-hoc mode not supported
In-Reply-To: <1318472723.4024.208.camel@deadeye>
References: <20111012052940.17383.59248.reportbug@localhost> <1318424918.4024.180.camel@deadeye> <87pqi2s0cg.fsf@marcos.anarcat.ath.cx> <20111012160135.GK3366@decadent.org.uk> <1318461858.4024.197.camel@deadeye> <4E964896.5050004@lwfinger.net> <1318472723.4024.208.camel@deadeye>
Date: Wed, 12 Oct 2011 22:31:04 -0400
Message-ID: <87sjmxr5av.fsf@marcos.anarcat.ath.cx> (sfid-20111013_043113_656851_EA724E81)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Oct 2011 03:25:17 +0100, Ben Hutchings <ben@decadent.org.uk> wro=
te:
> > but the=20
> > iw interface changes the mode for an existing interface when using rtl8=
192ce.
> >=20
> > BTW, I added a new iface because I did not want to interrupt my
> > internat connection.
>=20
> Hmm.  Maybe the change_interface operation is only needed to change
> type/mode while the interface is up.
>=20
> Antoine, did you bring the interface down before setting its mode?

Crap. No, I didn't. And now it works if I bring it down first. Oh well,
I guess I just made a lot of noise for nothing, this bug can be closed,
thank you!

A.

=2D-=20
Travail, du latin Tri Palium trois pieux, instrument de torture.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOlk1oAAoJEHkhUlJ7dZIefL8P/RChjuTc96SCUUn1o1nWorcR
sQfMKzU8aAQpUt6en95IbnpaHkR/uKOKjtbAFzBV2nfDEWFwROF4r/ea8Y1cpkUm
/D7RdB1C2uQGvnmxsRzIA2/LiyGlodqomamgDvxYTnoG8NnaWKQ8L15L7o379SL7
NY+H+UqaBHecncsFSB405xjjFPn0kiqSOHhCOv/sZh0v38okJ3U2RL3/McemzHVP
TQahn91S1PGIEKZqqN1McmoSGmxUfrlPYbwzNomVb9ruuh9YvQt/jsAmEdR7fFol
ToW5jGe5NcQnOJHGIKT6M6+d4A9ErcjwqwJF/1JeFZ1dlQWuYVzkAhR2PL3iTqd2
yrL723of6JFqwxNqc3NEWuRgSDwbvtUvcuP7OEsiyIkGImL7A0FgUEofyH/boPvV
ECWFz7BLLBQSdbKCIl4UGCHwcEuhggQFpPdtE/XBBHa20Lo1VWQvekjIjfZx1iFs
IZrmvRedpy5n5PbfThICOfTDNMYDDsYIlD9aL2FTj3cXzrs3GJvjM9iO30E3LSf4
g+Gw+TBYskMFU13JyGDfR995vYl/NNnycLBay7XpbWxk200bpy4FIcmDvU3wKpwj
4JUBi1qfX8oe4kFZwkgFN/GQF8UBWUqsDk14SaWdrY/KXj7nHDaQStvz72AwQzG+
2gqJsVg+VxHg+0kDOysO
=9Xg3
-----END PGP SIGNATURE-----
--=-=-=--
