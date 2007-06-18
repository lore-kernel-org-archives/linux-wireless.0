Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41728 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbXFRLIZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2007 07:08:25 -0400
Subject: Re: [Take 2] mac80211 IEEE802.11e/WMM code cleanup
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Michael Wu <flamingice@sourmilk.net>, Zhu Yi <yi.zhu@intel.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	David Lamparter <lists@diac24.net>
In-Reply-To: <1182156096.5924.7.camel@johannes.berg>
References: <20070611085950.GA5540@mail.intel.com>
	 <200706140935.50779.flamingice@sourmilk.net>
	 <1181996855.9058.39.camel@johannes.berg>
	 <200706161129.13782.flamingice@sourmilk.net>
	 <1182019869.9058.57.camel@johannes.berg>
	 <1182094164.14209.18.camel@xo-28-0B-88.localdomain>
	 <1182156096.5924.7.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DcpACd2+Qeror/fbWJVZ"
Date: Mon, 18 Jun 2007 13:09:05 +0200
Message-Id: <1182164945.5924.22.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DcpACd2+Qeror/fbWJVZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-06-18 at 10:41 +0200, Johannes Berg wrote:

> I can understand that. I guess I'm still dreaming of some sort of ideal
> world where NM and wpa_supplicant use nl80211 to communicate so that it
> is easier to use a different userspace MLME maybe, or maybe just have
> another program like 'iw' work together with the whole lot easily as
> well.

Actually, I should qualify: I don't care much if NM relies on
wpa_supplicant, but more if using wpa_supplicant makes using 'iw'
impossible, and thus everybody is required to use wpa_cli and hence
wpa_supplicant ultimately becomes the only choice.

johannes

--=-DcpACd2+Qeror/fbWJVZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGdmfR/ETPhpq3jKURAox8AKCOZtYVvb1Tpy4hwHUoy5hi2/mGxQCfb+Cu
R21YCmdskVQ1aBsYMVJGBnQ=
=qy6a
-----END PGP SIGNATURE-----

--=-DcpACd2+Qeror/fbWJVZ--

