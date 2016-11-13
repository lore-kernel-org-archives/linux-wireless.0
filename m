Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:46088 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933505AbcKMON5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 13 Nov 2016 09:13:57 -0500
Date: Sun, 13 Nov 2016 15:13:49 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: Problems getting mwifiex with sd8887 to work
Message-ID: <20161113141348.GA32086@katana> (sfid-20161113_151636_996861_D0EF7049)
References: <20161110175915.GB1585@katana>
 <507fff29bd2048c2b2295beb451943b5@SC-EXCH04.marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
In-Reply-To: <507fff29bd2048c2b2295beb451943b5@SC-EXCH04.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> 0x242 command failure is expected for sd8887, as It's not supported.

Is the same true for 0x10f?

mwifiex_sdio mmc2:0001:1: CMD_RESP: cmd 0x10f error, result=0x2

Otherwise I can connect to the network and run performance tests now.


--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYKHUcAAoJEBQN5MwUoCm2rhcQAIKMsKAWLsxxJApxjbPQPBam
5uLUo6gnNgwgkYs3eQ5sOmVojlZSTm8Wy24eloLl7gDtrsEv2nLbJyQj4IQR7BrH
xyJUwOdXGlANuhdNMhpQK/YoL92TMrXkg3RFO5+D7s7jVN2vDgWvSa1GQXUfclb1
jxHEC+8Tmpce8SjQ72QSLkO2VDpC9mp6vqO9GJP3d2LeGLg3FVUYlOSYIfA3lccZ
05dsVVRjG64Ti0F65X7Hc47ovXsskkcKL6TUG1IqzO7YtOyxA4VUYuXDVR3/0Ifm
msMEZRkbqBzGeSmqBlQ8VU+Hi9Buc3zsFq4CFrb/yxX9Qg2u8VqQrMTjIalIgyQZ
yDIQY+SdDTRjfNPP97Go0nhI7rKzi6N9XS4wyRBkcR0be4/ztQTed3HV2PIWGNgY
MQ/ZsdDSeHWl9iX97vm4YYEC5pjhwq4IwivT+h2JQd/tfkj9XlnbrcWt7QRt+hnf
Je7bnBEHyi6Laxuar2ld6W/ifZ0VnXfGLcqb1nXbwFG0M6OlKdmWfsQrVUvKrwpU
qOippd94LFAcIqshWRM+UR0LYgpgVD4cdDDg8e6rEQuHXiynnD8xi6JLkI1l3/IZ
YMGkHPESKxrDjKBPyJ1PeMf1xh4L+fK784J1FKg1gu84YTNsnkjPT0rqZXf8CGgJ
tjUxbFM/R52kI/XR3f2B
=ZEqV
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
