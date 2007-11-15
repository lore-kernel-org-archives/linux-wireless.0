Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35949 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757577AbXKOSKh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 13:10:37 -0500
Subject: Re: [PATCH 0/15] mac80211/iwlwifi (#everything): integrate
	IEEE802.11n support
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindzonski <ron.rindjunsky@intel.com>
Cc: Guy Cohen <guy.cohen@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net,
	tomas.winkler@intel.com
In-Reply-To: <c85cb4470711151006j765831f9w2fb941317153712c@mail.gmail.com> (sfid-20071115_180606_230180_C23E38C1)
References: <11950541913679-git-send-email-ron.rindjunsky@intel.com>
	 <1195056662.4091.29.camel@johannes.berg>
	 <247d6d340711150233h7988220fifb0d34170d16a979@mail.gmail.com>
	 <1195142683.13846.62.camel@johannes.berg>
	 <c85cb4470711151006j765831f9w2fb941317153712c@mail.gmail.com>
	 (sfid-20071115_180606_230180_C23E38C1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dpVn9OLCnVyidDvg/X5O"
Date: Thu, 15 Nov 2007 19:11:57 +0100
Message-Id: <1195150317.8147.7.camel@johannes.berg> (sfid-20071115_181040_689193_5B556D86)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dpVn9OLCnVyidDvg/X5O
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I would have to mention at this point that A-MSDU deaggregation is
> obligatory according to the 802.11n, so excluding it would be a spec
> violation.

Right. But does that really matter for purposes of getting the code into
a development tree? What we're aiming for here is getting the code out
of your hands so that it won't conflict with other stuff that's work in
progress, rather than aiming for spec compliance (which is something I'd
aim for when merging this stuff up into Linus's tree)

> What I will do is to put some out-of-band effort here, fixing the
> rx_h_data infrastructure, so it will be able to support rx_h_amsdu as
> well, thus eliminating the EAPOL bug.
> I hope that this fix will be ready soon in order to enable the merge,
> and then i will move on to next steps.

Thanks much!

johannes

--=-dpVn9OLCnVyidDvg/X5O
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzyL7KVg1VMiehFYAQIPIQ//XnVzrWF87ZEEhL8UNT+QjVsJoSVuBgWy
y1AVu+jU+L/MqSa7omVU9JX7UgwRHVk3YN1R2Xc8NFnhB3jJhItiZTbgpELm7oKD
XB7WLZWcy77ppyXA/QObXNZrSumC0nv1g6X5E3z7HABW3g4B88+2fCBJM+1FOt69
xa+pHjCnOABHlcPffzLpVTXYAS2w+H7LZvLsl2UGxcskvwJ2oeyBt81nBCTX2cHb
oAg7IMou64lrg+A2JRSMG8817o38VaiycxvBRIVxK+f7IosmUaOZe3sFrUZ9We8c
+jw8BdQp3+S66UuC/F3jB9R0s0f8jq0G2+v83/AaqtYX6GDrOFRyezKiFEdirDKZ
i/kJtxjZxSDK/JTjR8b9vrLsiQrTrSfaum/H3XgOjc2eORk5IYjNF/rZkJoVsQUH
ZP7UhCHnl2KH4V5IzXDul2/5A1VLgOU+H5PlhyUvO/aiuHEMI9Gi6F//kEFs9z4A
Wx6BIvxgNbBep1qzBpL5ItRCP+sEES7LfcueiARLM7SN1dMVlB1OnmBWIC3DoOFf
AjzYR/iCpY3hIGTeav+h1wByv2Z2UpSWNN366fYmBm/7fzSnAYDyv6OpGZpSZTzY
QYqKAXjp5+yD+DP1UH3Asms0+7Bhade25Cl5qg//0lxCzoUhCoooSmgwKRWlbwpQ
cjhzKzCd9Xs=
=a+nw
-----END PGP SIGNATURE-----

--=-dpVn9OLCnVyidDvg/X5O--

