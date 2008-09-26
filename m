Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45621 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbYIZTQg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 15:16:36 -0400
Subject: Re: [PATCH] mac80211: fixups for "make master iface not wireless"
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <45e8e6c40809261040k2aa053bap178bbfc55d66d31f@mail.gmail.com> (sfid-20080926_194029_125476_4B54BF2A)
References: <1222419687-7106-1-git-send-email-lrodriguez@atheros.com>
	 <1222428894.10563.115.camel@johannes.berg>
	 <45e8e6c40809261037x40f6642bq1340bb0ee1e8f13b@mail.gmail.com>
	 <45e8e6c40809261040k2aa053bap178bbfc55d66d31f@mail.gmail.com>
	 (sfid-20080926_194029_125476_4B54BF2A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CQfF+hvCah+Gsfx5dvHq"
Date: Fri, 26 Sep 2008 21:16:31 +0200
Message-Id: <1222456591.3798.15.camel@johannes.berg> (sfid-20080926_211640_350487_7DB74EEC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CQfF+hvCah+Gsfx5dvHq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-26 at 10:40 -0700, Andrey Yurovsky wrote:
> Ah, I see now that I can add interface on the non-master intefaces
> (ex: wlan0), so that's probably the intention.  Thanks,

Indeed, you can add them as "siblings" (to other interfaces) or to the
parent "phy" device with iw:

	dev <devname> interface add <name> type <type> [mesh_id <meshid>]
	phy <phyname> interface add <name> type <type> [mesh_id <meshid>]

johannes

--=-CQfF+hvCah+Gsfx5dvHq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI3TUMAAoJEKVg1VMiehFYZmYQAJqO8n8bs0If96JALCxjUw7Y
KA9FxzZlgIrthr0Ko1i3+DxvTJpZlCOmxGQYZSSYTLITcNQrKlORaboGgYZnu+Fs
2h2Jys/zT1FqW8TYRI/8DtTXuxONbBpmmQKtdrSQdszYPSOGS3z2oqKNzL+4xJjc
Fgcnzhs8hkhfQfvVylIopf3eHRED39PUXTNJjlJOpZ49TAlfSsFp4/2fqjhjThoE
ichpYFMqU9RexMD8UPQAvlZQI0hfx8ZoY47qdCMB0cnhtsZR4KGb3QsazCVLJlyU
fGMGpKkRIdn3lg3x79//hHn9LNB/ewf8GvON0inetAOjoqZzOz2tGGTlIIt4Loms
XUa8njlhjsw+6n2IwDDkXZmJSOcqRHgViKCbPfF3Hh3VF+uEaxfW62xRTggl8qdP
YAmlL42qOof6vL1qY8bzh0YwRPlJr8bdXy0Nd1ZncSGhoqMVdWAGftzMhkjNbaIK
iHWXhPomfbjbboDWO1nzmjJrZdGg4r7HLmgfto63UT2K0xs0vcosUFYXmVcqRRtI
hsjFdb73ZGZ12Bjwphf5EwIZrBPuISE3zcNlu7vRHR5POIq33PpebFE7ASUbUrXO
JfMZFKNk8Kw/+GWcxwnCJOonzvntO8/oXjjZKHRJHeCDlQmNj4vGq1y6/16xJNQj
/JDqbsdTcUpIrmtMSsUB
=42+R
-----END PGP SIGNATURE-----

--=-CQfF+hvCah+Gsfx5dvHq--

