Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49949 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613AbXKZQ0W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 11:26:22 -0500
Subject: Re: [PATCH 15/15] iwlwifi: 802.11n add support to 8K A-MSDU Rx
	frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <11960864922274-git-send-email-ron.rindjunsky@intel.com>
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
	 <11960864922274-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PgcwQC2Z17sWv4iq165N"
Date: Mon, 26 Nov 2007 17:26:15 +0100
Message-Id: <1196094375.4149.289.camel@johannes.berg> (sfid-20071126_162649_078567_3676C4A3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PgcwQC2Z17sWv4iq165N
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Please notice - in order to work in 8K A-MSDU ucode support is needed,
> version 4.44.1.19 (soon to be published). 4K A-MSDU works in current ucod=
e
> version as well.

> +module_param_named(amsdu_size_8K, iwl4965_param_amsdu_size_8K, int, 0444=
);
> +MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size");

Can't you read the ucode version instead?

johannes

--=-PgcwQC2Z17sWv4iq165N
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0rzpqVg1VMiehFYAQLtBQ/+LoHgwzvvtxFAEVPOL+d+o9rlQin+tnZ6
kT/q28z/5fjWtA041PtqotPyikB8hWb/iGx3acsTE253sW0QM/Ch0gGdwYOSHw9r
prjdz3y4r6JDZUjFGOZSSA31YS2Eg7fyZciVY0bLQ0LcWdaGvLhSyHH/cg0IlzCS
pZnn6Pn4V4shNzzRCtwmh7RQw+rGHmcSajW40/cr2SufsxY+1C+q3s4t7Z0R258g
yg3DOh7rnoE56QiwZsUyThNZ/MPXQ3XYrfG2dK+YeY6CQxabNAOuafcBXkctPc86
HvVxXiozlsXyWgH1/ViG8NQOaKwDifJvwrxtu2/MnnSCd+CudlFifXntBlwRzYeU
mANzIAGVOPJdpUmsnMhI54njGW1BKFITVtlGUksfzHvaja281ZZ1ak5L4FCyra4C
RJTLDT3Lcdq2jWmVGTuU7wEzXX7m8S2RwT9g9+bH92XVBwqjqdYiCo1Ey81yt72E
zB45Ms3gVbixX7LTowBf07eyPzdGo0dDMYbLYjF1tvV9QrHM8RvdIZO7UHkKNsVb
hDIWnG+WWqODeOfT3OmMp9pmnAfX228PU8hgj3XCGV9ehjAwGbXinD19k1CKz28m
j3/OAj0+qyxvFeuKkVG9uvS/ZN40n4vRVlEBtinA9jYLvXc/QZvRrApzayXtM6Yr
Va6OFsaReOw=
=1/p4
-----END PGP SIGNATURE-----

--=-PgcwQC2Z17sWv4iq165N--

