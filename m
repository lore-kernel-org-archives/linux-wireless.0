Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43958 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757564AbYGJNxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 09:53:05 -0400
Subject: Re: [PATCH 1/1] iwlwif: remove compilation warnings
	iwl_add_radiotap
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Bruno Randolf <br1@einfach.org>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240807100525u3697e2f2rcde945a765412eb5@mail.gmail.com> (sfid-20080710_142517_181700_F9521DE2)
References: <1215689322-25017-1-git-send-email-tomas.winkler@intel.com>
	 <200807101342.36920.br1@einfach.org>
	 <1ba2fa240807100525u3697e2f2rcde945a765412eb5@mail.gmail.com>
	 (sfid-20080710_142517_181700_F9521DE2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QoE7yfo9gErCOvBd8lRX"
Date: Thu, 10 Jul 2008 15:52:02 +0200
Message-Id: <1215697922.3483.18.camel@johannes.berg> (sfid-20080710_155327_660906_55323CE6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QoE7yfo9gErCOvBd8lRX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-07-10 at 15:25 +0300, Tomas Winkler wrote:

> > what about using the generic function to add the radiotap header from
> > mac80211? it should be flexible enough to handle all devices by now.

> Why not go ahead.

I always thought you were adding 11n stuff, but if that's not the case
(and we may make mac80211 do that at some point) then that'd be a nice
code removal.

johannes

--=-QoE7yfo9gErCOvBd8lRX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdhP/AAoJEKVg1VMiehFYi2sP/i/QgQZcmy3X0sVYgKFnBnBj
xrdENzL+P8gS0F/bIJyHsT9Uosuh+vSbefHp+/gkvsbtOmf4jY8Rqz5UihgiIdWd
Q8xf8PLHHz4FPrLRdku2jdh/6TwjvcFmfHW72DfBHFl0ULXBVUP8r6Jha9z5nb1m
tXKOxZg2QAnL82KNQD2ZqsyZrd82o0lTK+9JsbKNCHPieX4O5JD3oG1JT3bKR5oO
ldqG5trh9LLDmBlO0BLWs9Xnq122eFvSP52s5CYFaj9UgQrt24teuL6IvP8VP+4H
F/3xNilAnYh73vxXmuOG1hqSbPkC7Csl7b2P7gfQdJE2E7d8U2DpoBRW/IDNotsi
ghxoE2TSkVdkCBM1LTczwCj0wfZN3LvkVAmT068424eQZBe9zasoVJTOzUJ5jUeK
hBedjzM1qg8yCKfZRWXyOXkVdXFb+1im8TtJ61Fq9K2+9EojMsY5PeG+ZI6J3FpJ
aXEjSBf/SiO0MjS37TPNrUyWa3s38xOTSGQ/IGOZu8AP36AAbB2narf+Gmm0AIVD
I24qi+HOxpInoVVPfs9lT/meHDyyAVYAaO0crUDOoiM87lcj0pl5GCt4RfxRFKsr
u8VnbmB65hebEQppijI06zMRRNoy+LfhQ8/NEgCRFTywZsQG4DJZ244SQ059QABM
forLlH0syW2AnOLBYt8R
=rHWt
-----END PGP SIGNATURE-----

--=-QoE7yfo9gErCOvBd8lRX--

