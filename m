Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60747 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbYCLOzK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 10:55:10 -0400
Subject: Re: [PATCH 4/5] mac80211: remove Hi16, Lo16 helpers
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1204968188.23455.40.camel@brick> (sfid-20080308_092338_480606_A4DDBE10)
References: <1204968188.23455.40.camel@brick>
	 (sfid-20080308_092338_480606_A4DDBE10)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Sm0iZQ2QrCp2RkDPXNQx"
Date: Wed, 12 Mar 2008 15:54:47 +0100
Message-Id: <1205333687.15910.10.camel@johannes.berg> (sfid-20080312_145518_158873_E6908331)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Sm0iZQ2QrCp2RkDPXNQx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sat, 2008-03-08 at 01:23 -0800, Harvey Harrison wrote:
> They were only used in one place, just open-code it there.

This depends on the previous patches removing a few uses, right?

johannes

--=-Sm0iZQ2QrCp2RkDPXNQx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9futqVg1VMiehFYAQIbtQ/+NTuHzBSYwqRPW1FTuqZiR2HZcskGg5Gu
6p2r7PfQkzZ10mB7Xgm+mL1jn2MmiXtnDkqcw09BbyVWw3Tw6DMPqLf3AJllspCv
jMJquRwaipkLTVcU0w7++qByYCFajq+uLr0NVe9fz3j9J+wRxh55tNXjNkRpAdjS
LhnrTkTo4QPPKh/OUsP5JhtBmrLATBbeR3lWcBwQOtnw3vAt4zKX+0LH2QXE7N9U
b/OS1ql7iM4WdMULlLIdxce3HEWUM//jNvhLn92rt+f8/Lz3Ab6Q6qEdj6Pu+XNg
3OPDrVoCZSv5/+JPByxvad1rWL3yao6ARzQryIxvayGKK0qfzXOIzLTqRBNKgXjv
qYUNM3gcSpbxAaOaWdyKs+FmhvUu/tZAPmvrA4ovjT+4O/iPMiBa3SSQrE4A44ra
qXWACfW9cdqcMWABPupFiNdSOVBZy4rz+CMXepve5egdCHIq9DUZCZofyU4/Lttz
319Ik3Hd1At9Ng+YrM6YrPt+Qgtigphq5qeCeR9rWhzYgB5aRISLoWvbnprK5JSg
d4VPJllfw4q0BORE3Qe/VgfTr2AGZ888/UZClCW5jOTA2Qg1/OK6EbX9sSVDzjb4
+jJ4Vv5Wk58X/mHZirvoFDIvwkeGTqQ6BQIslwyW8RdFjLyjRq4LFtFcEKE8yZmC
DMp4X7pS0Wg=
=nrsf
-----END PGP SIGNATURE-----

--=-Sm0iZQ2QrCp2RkDPXNQx--

