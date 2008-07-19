Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37795 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475AbYGSOrY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 10:47:24 -0400
Message-ID: <4881F971.6060100@hauke-m.de> (sfid-20080719_164737_216917_7384D3A1)
Date: Sat, 19 Jul 2008 16:25:53 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: tomas.winkler@intel.com
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: wireless testing doesn't build without CONFIG_IWLWIFI_DEBUG
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD6C7732F8FFF7E2585CE4CAB"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD6C7732F8FFF7E2585CE4CAB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

While compiling wireless-testing I get the following error message:

drivers/net/wireless/iwlwifi/iwl-led.c: In function
'iwl_led_brightness_set':
drivers/net/wireless/iwlwifi/iwl-led.c:198: error: 'led_type_str'
undeclared (first use in this function)
drivers/net/wireless/iwlwifi/iwl-led.c:198: error: (Each undeclared
identifier is reported only once
drivers/net/wireless/iwlwifi/iwl-led.c:198: error: for each function it
appears in.)

It seams that commit b345fdd0551d986f4f8038b449932a0e610dc251 introduced
this error.

I turned of all debugging.

-- Hauke Mehrtens


--------------enigD6C7732F8FFF7E2585CE4CAB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIVAwUBSIH5eoZ0px9YPRMyAQJ/iw/+OlOJHmruI6fgtZu8il2pKHvLm3DKFBEG
OHYSxp++GDYFIwnhs7g+E2RsIbF3XItev/89Zv6WhbdClkZhXCFJKEB/+zJm0N/G
AYdSbNWFduOMVzTx4gS6eAC1uxGLGdjNySJUKcYT9v8yKikptr9fu1uBB2Yvwlyq
K6Q/0CnsCPtUzZ0eltSMUPjjQfloKK+rCJ/X2hJDfXfHwz0VX8rX8ajX/zw1U9Av
CkgeKV/kEuPxGmdsiCsBpME0eUrq4HD0vZ0dUyMo/Jzefpto7CXoyaDUiFBQxV91
LghZhXHduBLg2Sq7BfVhudOplldlu7ShtNRb8x6HF9bN5F0ukyqk5xSHs5izncyM
e6/AjxftDp8laQitzFEI1WBjJwCNqL9azwpaFA0nz28emgi0XACsyy6d2tbyKVXx
bO/kDCzOUw9JQGMXLOk+8XgpmWvnVoRtS3zbPua6FoSpvq1vPB4OxGi3U4pGGrwp
tC7UuZ/sHTdwve2/rmut9wzRBy66BlS72E6UyNEZnVhN+Ea7VA/iVllCR/uXvKEE
EnWyu3IpC9Y62CMdMdmpXOHbM+yY5nhH615biypoYLypiHlmXpXILSm7hCHVk9ny
sBGSiXaXPkNIyzdI2SID3csJ+qAQC4avCC1QjAteS14c/9V+wVXHpqw6PncKoO73
MVsRuVJn868=
=gfOZ
-----END PGP SIGNATURE-----

--------------enigD6C7732F8FFF7E2585CE4CAB--
