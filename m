Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65453 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaEUJrN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 05:47:13 -0400
Received: by mail-wi0-f174.google.com with SMTP id r20so7380738wiv.7
        for <linux-wireless@vger.kernel.org>; Wed, 21 May 2014 02:47:10 -0700 (PDT)
Message-ID: <537C7603.6080701@gmail.com> (sfid-20140521_114717_702449_1EF91CF1)
Date: Wed, 21 May 2014 12:46:43 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi 2014-05-21
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="GVonl1I6VUEjU8MkFJttvKR5Sc383WoAj"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GVonl1I6VUEjU8MkFJttvKR5Sc383WoAj
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

A race has been discovered in the beacon filtering code. Since the fix is=
 too big for 3.15, I disable here the feature.

Please pull, thanks.

The following changes since commit b538b8ce76f69f7fa225bc0817bbb361b877ea=
23:

  iwlwifi: mvm: prevent sched scan while not idle (2014-05-13 15:05:32 +0=
300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git=
 for-john

for you to fetch changes up to 7bacc782270ff7db3b9f29fa5d24ad2ee1e8e81d:

  iwlwifi: mvm: disable beacon filtering (2014-05-21 12:45:34 +0300)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: mvm: disable beacon filtering

 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


--GVonl1I6VUEjU8MkFJttvKR5Sc383WoAj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTfHYVAAoJEC0Llv5uNjIBN+4QAJ6spCnWOBW8N1aelSD71o0P
fnI0eTok6LTfgY2KDhXcyorEQObSggC3mA+ZZaje41bcwh8x5UqwswqsutwnnxvP
F23jYBlGC/99Rzgn+N+9FrVOUGUhBYxTk2gVUfQMxEjuih2Z6Zp+Hud3v80t5P15
CZKd4AJAuVxMvkFfraAb4nenQE6BTryBD4z1bdbuUQEbEccWrKuCUehTqTQkIoLk
5RsA5zZHxX+JHUa26SKFq3pr82tjm4xoiHjlgfffRSCk5zxSQH5bsiVXsysq9LHS
o5MRaEDEai9kwyfVrtAzjIydAU5MqtDhxnoqi5Cbgv4efv0+kWX3uEqXJM611vb6
rfwVADi2sekS5vUHVBhVXF2rFImF2/GpXsDPtITjoQF4Nv+i/szvc463L8+oNZ0h
wsQ66NtExS0fWwPxjsntfEqa9BKuLSfhmORqtZzDvlz/vjf6oJAhu/qhPXBp0xvF
1Lo2kQJ3wn4HyqiSDMNj+4GFz0cBMIJd/CprS724O93X3m6Q7odO2NwXTNRCPuH2
M4kMXO/445NFEWlG76R0AjmF7M9sSG9jbJ+h8Y/lv8hYDRfVR7PrQ2EiZtq96X7V
ZH94ungj+DWOGxhBih4ll3ANjmnf4Su1LIzAB37yPak3kv6AbtPibCnxULIXZiya
YaoUy1oaF3Ll/stt3Yzm
=oimZ
-----END PGP SIGNATURE-----

--GVonl1I6VUEjU8MkFJttvKR5Sc383WoAj--
