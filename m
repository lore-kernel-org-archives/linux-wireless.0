Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58763 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbYE3TRV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 15:17:21 -0400
Subject: Re: [PATCH] iwl4965: remove useless network and duplicate checking
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <1ba2fa240805220341g69f3acb0qf03594f541232337@mail.gmail.com> (sfid-20080522_124104_336537_5B472C77)
References: <1211446997.3698.47.camel@johannes.berg>
	 <1ba2fa240805220341g69f3acb0qf03594f541232337@mail.gmail.com>
	 (sfid-20080522_124104_336537_5B472C77)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yiJthK7cwOrNzZLOJOep"
Date: Fri, 30 May 2008 21:17:15 +0200
Message-Id: <1212175035.7238.8.camel@johannes.berg> (sfid-20080530_211724_936892_56DBA1D1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yiJthK7cwOrNzZLOJOep
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > The iwlwifi drivers go to great lengths to avoid passing packets to
> > mac80211 they think shouldn't go there, while mac80211 can (of course!)
> > handle them very well.
> >
> > Especially in the case of duplicate packets this is interesting
> > because it's such a performance hog (especially for IBSS networks)
> > while mac80211 does that work on the side without much effort.
> >
> > This patch removes all that and leaves only what is absolutely
> > necessary for the hardware.


> Looks good to me. let me just repost it rebased over our latest code.

ping? This one no longer applies.

johannes

--=-yiJthK7cwOrNzZLOJOep
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEBSuqVg1VMiehFYAQL77g/8C6mTb3nM+pww1ouloU4QopMhtHzBz7/0
nVi9Ojlwh+GVjZFSb0F7n8Hc9uWch9+AiKDHuvYL4WeQ1rjOYxorOMHyZ64+eBH8
U7OaMBWvvkjdZUts/LEU5VbKiBDgtUIGCDEdLlLXOQrQ/sApdwW6u54AW4yYV0dj
TVv4N7oe6J/KJMDv71/6lNw266Fz667imRiDpreGhs0wZgGI6B49rdOaByVBqUtl
/RqfB50NjnlfEyBNjeRgwqFGMj98N8QN0iw68muLyyzRQIgou+5yuAUtHdgthq9O
UI0SqwtY5Mxsxeqfvxu4A05xm2+SibUMUcUQ4rE1lJOK5rHCvmk2p2XukfkWBSmK
R5bErwaHf4gfOAl/6jTXE8sZazCfe1GXqu+WH8MyURq+C0ib81yPBZw0jaymui8D
Xd52/O2DiFlGOQnBcL71lQ29lSeY0mJIGrnDspntPF3TEpJFT05ajcGb34eIEkzj
wCanFFSynPWYk56mxRT950fM/PnOtuozSfFbPHLudoEokczwkg2VoAYhHH0wvkiF
G8KRTuLjtRH4fa5Aze9OaxcA46J0GlEPZNaQWZxF03ER2IOlsL9K1q2crnST1X00
SrvX6ajOHOIQSRb8XawOWzikm4n2zwo6KMyJcZME+W32lUAPSlbQIwMmJVynTX7S
0GTGqgs83cw=
=Q9Hk
-----END PGP SIGNATURE-----

--=-yiJthK7cwOrNzZLOJOep--

