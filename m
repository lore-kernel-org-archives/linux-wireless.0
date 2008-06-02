Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38544 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315AbYFBRJV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 13:09:21 -0400
Subject: Re: [PATCH 2/2] mac80211: removing shadowed sband
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240806021004j5dd5cd80o9bbd58b9f50272a0@mail.gmail.com> (sfid-20080602_190436_711663_00393982)
References: <1212421452-5635-1-git-send-email-tomas.winkler@intel.com>
	 <1212421452-5635-2-git-send-email-tomas.winkler@intel.com>
	 <1212425690.20021.2.camel@johannes.berg>
	 <1ba2fa240806021004j5dd5cd80o9bbd58b9f50272a0@mail.gmail.com>
	 (sfid-20080602_190436_711663_00393982)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hagk8QxTH8liNScw0q72"
Date: Mon, 02 Jun 2008 19:08:27 +0200
Message-Id: <1212426507.20021.4.camel@johannes.berg> (sfid-20080602_190926_176637_D4451869)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hagk8QxTH8liNScw0q72
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-06-02 at 20:04 +0300, Tomas Winkler wrote:
> On Mon, Jun 2, 2008 at 7:54 PM, Johannes Berg <johannes@sipsolutions.net>=
 wrote:
> > On Mon, 2008-06-02 at 18:44 +0300, Tomas Winkler wrote:
> >> This patch removes doubly defined sband variable
> >
> >>       if ((info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) ||
> >>           (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)) {
> >> -             struct ieee80211_supported_band *sband;
> >>               struct ieee80211_rate *rate;
> >>               s8 baserate =3D -1;
> >>               int idx;
> >
> > I guess we can remove the double assignment too since it's the same as
> > already done. I must have added that when doing the mechanical tx rate
> > idx changes. :/
> >
> Good point. I also did only mechanical fix for the compiler warning ;)

Heh :) Was that sparse, or do you actually get compiler warnings?
Anyhow, here's my Acked-by: Johannes Berg <johannes@sipsolutions.net>,
feel free to add to the patches right away.

johannes

--=-hagk8QxTH8liNScw0q72
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEQpCaVg1VMiehFYAQLo7Q/+IOtWIBz75SAnZ479YqnRv8x3UQY/WOoF
WkEL4/MHOGt8gQglUbDFbnaXt5nRLuxpkUYMyuB5hIgeur9mZH4TQmDcYZb/0FDF
woq6Z3jp+RrTmoMcY5zNg1c0mpMH8xtscDxvkEaonZMGNSip8D/rG2AHbL8lTQMu
Tm1xtyBdtEmmS7BgcBjDfzqz0aoNBEcAGaeB8EdUWs6MmM0HMZsRTWdQfjliaGjq
nFMCZsrYh9JbkEeB2Bse2vJKcduCb4BWhpDljR39n/vuK7N7J8I7bk1uTNXuX2PH
HMBvB1nKDRJuVzRt6/BURt0QQRuJG+rGR5rtjOSvL+QD9DNmWHYnk99npVGE2PYw
5e1gjwQx59TuzzWaBlgccynyaX5IPw+LnMDtW9TAneblIVCSTQmm86W0oPFx+ygf
UCsopCIB0RexxmoDokStsy67I1QeYkLAyBDWeoEpuGZyshH8rMYF+B1VUKNAJvFB
NcHIKriXnSKTRmQMDBpSTpaebgkTE5hEgJnAT7fClOXleEvLcsUif6YSFvbvbGck
heL0w3vNIBz9xlgtlNGBAbu8VTI/+7FAxeab1SK9mVg7Kv+E5MjqCrh2+GOEqjur
7agenbFBtOsiz0r6c/eOGL+pQfNGFb31+h7R9EFRfvb7w6ER9ItTLaRRvbSoP+Cn
j4WpnxuXw60=
=VOYr
-----END PGP SIGNATURE-----

--=-hagk8QxTH8liNScw0q72--

