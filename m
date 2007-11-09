Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43416 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbXKIUSP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 15:18:15 -0500
Subject: Re: [PATCH 03/14] mac80211: adding 802.11n HT framework definitions
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, flamingice@sourmilk.net
In-Reply-To: <11945953312367-git-send-email-ron.rindjunsky@intel.com>
References: <1194595326527-git-send-email-ron.rindjunsky@intel.com>
	 <11945953311871-git-send-email-ron.rindjunsky@intel.com>
	 <11945953312850-git-send-email-ron.rindjunsky@intel.com>
	 <11945953312367-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eh+Z/8sOg6j9ggj/K/Il"
Date: Fri, 09 Nov 2007 17:23:47 +0100
Message-Id: <1194625427.4793.117.camel@johannes.berg> (sfid-20071109_201820_826771_98FF71E1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eh+Z/8sOg6j9ggj/K/Il
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Quick question:

>  enum ieee80211_conf_flags {
>  	IEEE80211_CONF_SHORT_SLOT_TIME	=3D 1<<0,
>  	IEEE80211_CONF_RADIOTAP		=3D 1<<1,
> +#ifdef CONFIG_MAC80211_HT
> +	IEEE80211_CONF_SUPPORT_HT_MODE	=3D 1<<2,
> +#endif /* CONFIG_MAC80211_HT */

Why is this a configuration item? Does the PHY save power if you run it
only in 802.11a/b/g modes rather than N?

Also, I don't think we should have the ifdef there.
=20
johannes

--=-eh+Z/8sOg6j9ggj/K/Il
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzSJkqVg1VMiehFYAQIHpA/+JFYcVw+VwLERaZvXTWWVZr/a0VQSp+DD
XQr8JbkTa3uy7PZVWTGLjJLwS9/5FIhOuii60z4KyfnEDFC6PZz2cph0V/eL0Yc/
PjTbwyJ7j6kEdez1URak97i5OtoIFjPu3bC86FrB79MIBYJWeUkK8Zw2DiM6MpSL
uLIMbAoKDpjhZ7yTO8aS42xiJZgiNy7qoLQvgaj7jUorIFmioDzlrbeWxjF3y/0z
Gmjq31MoerGaGRo9ZbIACd4TqXbiamN0YQKZh1rMpFvQGEqDYjDSYPoaL71ohu73
znblccIlIRk4P+F6a7Xsx0etTMNpPPEta7ELBuv3RgkTtj9YBoWIFyuGdiKyR0uX
efG//h+UgrR2VWjE5+m5DR0hG6ce95Kqt2t2FbTOF7YWRXBzjOSMeXSuVu9fg6U2
y2SncgBr8IwGnpvt+7Fdx/ZluBg52amqNSPCgwn7xHjiFS10QwwCcetsxDI4CFPm
GTXRpD0aDS48YXBgE6BzOdGBtYSuv5e8542jbwFcORcgvJzDEkylNjx1dtqFzAtH
gVqU/Qr9WnSsW2YydL1kUYY0FJ4AI1cMiem7EDM/oEkjsEueLorLUkCzfRNpDm5z
t2HnRD25CLkaNb0jCB5qYyMsWWLo9cWFC4LASw9hpzsKD0x5piUi/6pFcyFC7WSg
FYxj1GAowr8=
=BASB
-----END PGP SIGNATURE-----

--=-eh+Z/8sOg6j9ggj/K/Il--

