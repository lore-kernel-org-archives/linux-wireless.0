Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38162 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab0AYNlM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 08:41:12 -0500
Subject: Re: [RFC] mac80211: wait for beacon before associating
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4B5D9BDC.8030307@openwrt.org>
References: <1264423044.23766.39.camel@johannes.local>
	 <4B5D9BDC.8030307@openwrt.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AWf12UBOc7hB0PUl1iuj"
Date: Mon, 25 Jan 2010 14:41:08 +0100
Message-ID: <1264426868.23766.41.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AWf12UBOc7hB0PUl1iuj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-01-25 at 14:25 +0100, Felix Fietkau wrote:

> I think if this is required only for powersave,

I don't think it necessarily is. The particular case where the problem
surfaced now is power saving, but who knows what it may be used for.

I kinda agree that 112.5% timeout is too small, but I don't think we
should introduce too much variance into the process.

johannes

--=-AWf12UBOc7hB0PUl1iuj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLXZ9xAAoJEODzc/N7+QmanNwP/3yfFt3Ntye9pQp8prtFqlai
A8+NkcIraAs6e1puSCCsftgvIHirCNtYCA+/X+Y4Cfj6e3OZx8jtnMHeMrQ3g+Jn
oacc+Bk/R6lxoDvQNYiq+6huk2n4Ybo8iMbnOoR/9Z+i3jPf565p6f9PGW92mIyD
Zdu/kKCRHywURIMejaho9XIL2RG0hzqlNRXwjuKRo52lxIN7I9sRuKSJGsCga9ou
Ex93on6CmADFSVoYF0LG5hxI9cM0gKPDm2s2EjkNEbOk4rxeuE8FrqG9V8B0q1d+
MWfsSaCl0x27c2N2R+IS83cQ2PxSybZsqMB72H719PYFx9VZkdkbo3l/FdFQ2Glq
bjk1F4Vwh7Vw0pEYtt+XGaF3yq7Ms6EivMS9iCwAS7LiIR7eMR0pweHedmMD+UzJ
JbS8r41LXUBKDO0a9iFlNdZhYac+dllF6WY92m9oBhMLYjyqwOw5qJxu7/ZSNRjq
aWkno8w++IhPswxlcRjsDE6PyjD6Sto+pn2CZXeUW6tKVHXR8hWytXK3hz8QFqiA
CVrpl8kTGDcN9WxJmA5uTxUvCSSEY129oQFEhV33zZQkpEjdr/n78ZIk7RMMaYOo
9y+aK62baDo+bqGUxwaZNWJzyoFMYwSKP5jGC7JBumeL/6IS9ByKmoETb52gDXqD
f3GfYme2Amc7+YrtH1wo
=ii3Y
-----END PGP SIGNATURE-----

--=-AWf12UBOc7hB0PUl1iuj--

