Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56607 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375AbYC0MvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 08:51:16 -0400
Subject: Re: [PATCH] mac80211: use hardware flags for signal/noise units
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <bruno@thinktube.com>
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net, jbenc@suse.cz
In-Reply-To: <20080326123042.11233.80949.stgit@localhost> (sfid-20080326_123158_363276_E441A5BA)
References: <20080326123042.11233.80949.stgit@localhost>
	 (sfid-20080326_123158_363276_E441A5BA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6jF9bSP1QyCp/FGmNrPC"
Date: Thu, 27 Mar 2008 13:47:43 +0100
Message-Id: <1206622063.22530.25.camel@johannes.berg> (sfid-20080327_125215_173072_0CD7CF6D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6jF9bSP1QyCp/FGmNrPC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Wed, 2008-03-26 at 21:30 +0900, Bruno Randolf wrote:
> trying to clean up the signal/noise mess. the previous code in mac80211 d=
id
> not have much definition of what units of signal and noise were provided =
and
> used weird implicit mechanisms from the wireless extensions.
>=20
> introduce hardware capability flags to let the hardware specify if it can
> provide signal and noise level values and which units it can provide:
>=20
>   IEEE80211_HW_SIGNAL_UNSPEC - unspecified, unknown, hw specific
>   IEEE80211_HW_SIGNAL_DB     - dB difference to unspecified reference poi=
nt
>   IEEE80211_HW_SIGNAL_DBM    - dBm, difference to 1mW
>=20
>   IEEE80211_HW_NOISE_DBM     - dBm, difference to 1mW
>=20
> also clean up the misleading and confusing names which were used for sign=
al,
> noise and qual before.

I have to admit to not particularly caring about these things, so if
you're willing to accept responsibility for all breakage I'm ok with the
patch going in :)

johannes

--=-6jF9bSP1QyCp/FGmNrPC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+uXbqVg1VMiehFYAQIoBQ/8C+lJHNTzS2PmM4bnkv7w2RrkVTI9Y1+b
0iMTfEiX2HelnZPv0hlaQxUd/2enSAy5IGZ7CjF5CqjwwfSlwVBzJO5P/7LRFWdT
cN0YnPlrhE2T0LLRBFJ8IRE4jd4AQZ+7kJ7RWGFXK3/aqDNcPxsfcOLjTXVoxR38
Vcd0zGUowLQDS1ErXFcYi8dCWdUxfAizJJdKVnhNkAFd/T+3y59obJJSIVjRNJqu
p+lziCJpjymgsJUm94fFqvxPcmy3jwIy2vfKkzeQDf3u74iGLzNV/KsLWp2gIN85
Aa3qB19xzF3wt9Er2uTiqlmtmPGsT34tdNN8WOPiRKWaEzGnr9GmvymXv25y1Nzo
WjvTpXAMuWQ7/WzTCrQmvt2ANdfWG405UXl4i3FBwhUce34Tul+mDP5XxW2oYlmm
P/KKXevOn/QytjXdXYm7egbwJXkVyK2Mb9OhGVLDl5CY+6sn82ktcB3y07W+ZQP7
0Mm3jFmPMU9l/SXm9QjSO9tbsUHjmlu5aD4gzyZQ1E10LYVrHFfirGyE5HETQqiX
znrTA+5npM5lGufFnRIsBdmvfjfzitmMS25ck3JPcDrVmY/7x8kKQlnfgnODmQYz
AyNV5mdWk/vamy51dqPjtymnBFS88AbjiuaLiwdMFClfKRM9g6ZKK0nH0gi7Z47h
VQ+cpWx8kEo=
=DHBA
-----END PGP SIGNATURE-----

--=-6jF9bSP1QyCp/FGmNrPC--

