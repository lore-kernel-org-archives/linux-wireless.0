Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53833 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbYAJMOu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 07:14:50 -0500
Subject: channel utilisation short/long hdr?
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>, Michael Wu <flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-j8dQfI55OrjootqB8g8H"
Date: Thu, 10 Jan 2008 00:50:58 +0100
Message-Id: <1199922658.3861.40.camel@johannes.berg> (sfid-20080110_121456_299273_0F9305BD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-j8dQfI55OrjootqB8g8H
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

What's the meaning of these defines?

#define CHAN_UTIL_HDR_LONG (202 * CHAN_UTIL_PER_USEC)
#define CHAN_UTIL_HDR_SHORT (40 * CHAN_UTIL_PER_USEC)

I can't figure out what the values 202 and 40 are.

And probably related, what does it mean for a bitrate to be an "ERP
rate"? Does that just mean it's an OFDM bitrate?

johannes

--=-j8dQfI55OrjootqB8g8H
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4Vd4aVg1VMiehFYAQIZMA/5AfyIUVCttvY99h6Ewf/MqF6wHlP6D101
rly5DKzp1CnVb7KEt730n4FgynvcMtNwyDQUBzRlNzn1PNOnQUOFpiykyx72XqLx
OUMkW2w7ms2Bpe4C5E5cplQqDfGNM7VIfZGjYFaHgKFxpFcJeZlG4qIQEbAALRPE
vw1+FB1YDh2jbrbS9gYiRaUM7lBcZa14awHHRECizirvb6CuYlhX33WEzq1w/Vcf
+uKEAoNv0J/HQLYWnNlOGyoFjH/DGM6UPxHcJeNvCU8mhthT1KkbEMnVZSr3o4XC
inePloLygebgkw5kWWqDwW0MQdc5kYgdlF3lUnGdPCSUE0S0Jo29DBg8MHt/TW0s
y28oHK1WMb87+T46c18ytx8wr4o0dqzoEVnH5lUhRkJtoIyYfPskA8/ErNATELaY
ubvHYZnwCFsNzShF71LzYVBGeChnLvCrNEj0/CgFqgKY4lVwkzqr+WN+M1zkMjKD
Es0u0sMRa64IeClJZU13lJwGzcWBCtiao6iy2PVgPOsW7YmVcxFzds5BEe1V3fPi
40CbQRWyqdVix59bW0b814N5aOZXDNCzXZf0o67t6QZRWgz4ZPM/grLkANjWMKYT
AXdSBmxHCCR1RApbTH26bAIWkHGzb/2Un/iKoCqHxlW24vZETOAg8Wwp2MVcQd2g
aPSLnf9aEcQ=
=GVsd
-----END PGP SIGNATURE-----

--=-j8dQfI55OrjootqB8g8H--

