Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:61766 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaBXH2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Feb 2014 02:28:55 -0500
Received: by mail-wi0-f182.google.com with SMTP id f8so2670361wiw.9
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 23:28:53 -0800 (PST)
Message-ID: <530AF48F.8050802@gmail.com> (sfid-20140224_082903_068917_3425C930)
Date: Mon, 24 Feb 2014 09:28:15 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: [ANN] New firmware for Intel 7260 / 3160 - 22.24.8.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="pqfwKdO1dWm4jKtDgTwvV4T34IMrN36WF"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pqfwKdO1dWm4jKtDgTwvV4T34IMrN36WF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

we have released a new firmware for 7260 and 3160 WiFi Intel devices.
This firmware is supported starting 3.13 kernel.
We have a here quite a few bug fixes with a few new features.
Most of the improvements concern P2P client and GO modes.

The firmware for 7260 is available at [1] and for 3160 at [2].
I will send a pull request to linux-firmware.git soon.

The new firmware's version number is 22.24.8.0:

$ dmesg | grep loaded\ firmware
loaded firmware version 22.24.8.0 op_mode iwlmvm

[1] http://wireless.kernel.org/en/users/Drivers/iwlwifi?action=3DAttachFi=
le&do=3Dget&target=3Diwlwifi-7260-ucode-22.24.8.0.tgz
[2] http://wireless.kernel.org/en/users/Drivers/iwlwifi?action=3DAttachFi=
le&do=3Dget&target=3Diwlwifi-3160-ucode-22.24.8.0.tgz



--pqfwKdO1dWm4jKtDgTwvV4T34IMrN36WF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJTCvSpAAoJEC0Llv5uNjIBFw4P+gPEvxj1SADF2U9ebMpRrz64
y9wyGyQBPqC1vaAhXESwh6T/Jg5BwWTeeUL+zMhWMn3ROChjGRn63WWvtX/OOvMo
vYiAIDlJhsVUCOs192w+rqzDqN1LiAoAcVxZyE/MwTSNczbDySjoTGs+KeM+IPkj
2JpdyNADUjBD7R3VqGP7kRjJDbgmk8NpRAJ4KGYLDGCiJoYFHvLFk33U/hwr92Of
FinKraFoN5l59mu1btrTcn4awFuAHhejnjZItu1RwvwMhMf6PiOISZG/oVuB09Wk
NFIeYosV1HuN6vkBmnBmMiLuwKyUGKWn8emSMsuHvTHD9wIo0n5fbyzRkrYTY28H
FoZEx6Pu8jcv/RMvC/41MYXGx+5bczk3dzYCL+HsxxdINmpteruKP4zqyrmt9rRe
4tlEe131ZuEZMCKWXJijSm7Y18mnVbRSIDOmGkxruFJtnuj4Bwe8bkNM01iKPDdh
uU6zoSuDCeJ+nyxJQZhgnnxd50pn8EA3328qiQMhZRhILv7ttbTTUuTN+CIp9Mee
wRBey5LK3OXRGvGEXZK2ZCTtcDcCNFIJSMeDrnr682rcCL8TnrRDaljsH2j/CSw0
5r7a73dQ36Vu+FhuFoD5SGq1niLl4r/AlNh00Ebk7Ejb4Qg7lC/LEEiXDhZheayL
LBNiLIlioTX09AG03i0K
=lxhV
-----END PGP SIGNATURE-----

--pqfwKdO1dWm4jKtDgTwvV4T34IMrN36WF--
