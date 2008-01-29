Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42093 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764155AbYA2Rq2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 12:46:28 -0500
Subject: Re: [PATCH 1/1] iwlwifi: enable 802.11n in Kconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <12014391833639-git-send-email-tomas.winkler@intel.com> (sfid-20080127_130822_715208_9C6F4467)
References: <12014391833639-git-send-email-tomas.winkler@intel.com>
	 (sfid-20080127_130822_715208_9C6F4467)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fj0xkSQ49tdh6nJUONlI"
Date: Tue, 29 Jan 2008 17:15:41 +0100
Message-Id: <1201623341.4394.39.camel@johannes.berg> (sfid-20080129_174649_646878_642B9964)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fj0xkSQ49tdh6nJUONlI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sun, 2008-01-27 at 15:06 +0200, Tomas Winkler wrote:
> This patch removes 'IWL4965_HT: depends on n'  from iwlwifi's Kconfig
> 1. 11n is functional so no need to make it invisible in the configuration
> 2. Latest Johannes patch 'cfg80211 API for channels/bitrates, mac80211 an=
d
> driver conversion' broke compilation because this config option was
> invisible - patch fixing it will be provided later

Hah, and I actually had found code that I knew was going to break but
since I couldn't enable it I ignored it. I didn't know it was already
functional, I would have enabled it if I'd known.

johannes

--=-fj0xkSQ49tdh6nJUONlI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR59RLKVg1VMiehFYAQJcBw/+KzE7JPGmNGQZ4DwDqAHSNzMT3L79rgxD
gF/L0eM+1yYJq/mcGXi8ZZqmzaQk6rAAVoCdULABR/1rf0telVHJO5iVx5Z9AlnD
cF39rgm2loQ5p0MJ2S/CEtkknAyOoyMvqwRXqpPncQJ5UNFIAHnLEezGMEkJCMKn
ax6qUfNcpzkCEOahudRzSAsNgFmO++uIPddtLCmeWSgRYrSsaCWOOFZVScuAQUXd
2Mvsk2m+iovoIHn5WyBykOJnI0oXHX0FFXSUkWrCY2b6w0TouSiL2iKD2cIxn5oV
zM+goEyXZ4Vjd7ZlfQ8GsrbNnuZ4uns39KGW1h9uedSO+ZNjy15V5Eeq9CWPh/xx
EvnDNdJRgLaJ4ulRagOI/bIb2AhnD1h0WI2vYt2vxYVoS/9qRZYOoJrPOep3lQHV
wE+KrwVTMB0/TFufyDiZOu1xKSSCKX/0+HWttZml1NJWwvSaERN3DjeGV376itHG
K90ejrbT87Zd7IH9RiUh+Lb624+JjoeqQNyCnSaUz4+qUOI1JdAkm4UeknzhVMEr
4PhoyhXPuk7Wi7b57aju4zumrJfbotbrfrPmjscblRQV42NgxpSUwBUVtCxpbJK/
PKaLFPwFAgGp3RxRoH49dCHy2AcUrFRx8DBDkj5XIj2At0JWy/KwgHKAl5pxdnCP
30ZrS5/O5tQ=
=1jdf
-----END PGP SIGNATURE-----

--=-fj0xkSQ49tdh6nJUONlI--

