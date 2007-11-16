Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58814 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046AbXKPMBf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 07:01:35 -0500
Subject: Re: [PATCH] ath5k: consistent info and error logging
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <bruno@thinktube.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <1195200656-25847-1-git-send-email-bruno@thinktube.com> (sfid-20071116_081058_378650_986691A3)
References: <1195200656-25847-1-git-send-email-bruno@thinktube.com>
	 (sfid-20071116_081058_378650_986691A3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-01qnNshhBvB8u3EVj4D6"
Date: Fri, 16 Nov 2007 13:02:43 +0100
Message-Id: <1195214563.8147.118.camel@johannes.berg> (sfid-20071116_120139_497019_0541780D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-01qnNshhBvB8u3EVj4D6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable




> +#define AR5K_INFO(_sc, _fmt, ...)	\
> +	printk(KERN_INFO "ath5k %s: " _fmt, wiphy_name((_sc)->hw->wiphy), ##__V=
A_ARGS__)

Eww. Can't you make them static inlines?

johannes

--=-01qnNshhBvB8u3EVj4D6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARz2G4qVg1VMiehFYAQKCGw//SgW9ajk1K5k0d6lym9k6qPcywgwnDXgJ
xU1DgHqfncbsp3o5thFRmhAuyFhYPNJ6SIidhCJUOa+zb38asS+3ubsK3wwHpYDT
rE43cw13zy+b9KqbZVwSSz15yYyT1OntZGYHym811RtA1LmHKBvBqoAv+srG8Cvf
QupTV4YJQWov3YvjnK7XHXdZHuiuCg/d3Nlg66px6oES/FbP6H850R15VX+oIuME
z5xxTWeZh7xQsy8Xf4ICFzhs6g5aPfNO/mftIhBVhqt+AVe+hWvyVumD8Qalxjk0
sdgotfJXLhfrCaP8M2tQnHADyu27Y5Xn9PIfTnWDlra07eFhVOPobzykdYT7UQ14
97gdbkyZOtX6N7hekc7djC3T7Lmdn+Gt6c5LRNfB65KDVYujA5SyhcGh2T6FWYLb
E6OIrRD2iHTJtBBt8T5GjDWqIQKkSdQFjCouvcJKY/HJ9VooXfWsAOXbWsnHNKik
62Wi1ToHycVA9QPfXTNg461CuRkGMeZtDRuVv/RQhQbNBgzKZT3WQPCt9oJGE4rf
5zl8Bs0AWVYNv/7Na04oVttwNxWF1gG3FkPoPrrcOMcHE5KtmAUxDldliIvn6iqN
noOlsewtB5oj5oxd09bd8WVxtWlgWJn5pZ3yHiLY2cy/St8jpjMSEne3zfKgBmQF
LYmQevDngVw=
=uZAh
-----END PGP SIGNATURE-----

--=-01qnNshhBvB8u3EVj4D6--

