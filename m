Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50135 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbZHGVuZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 17:50:25 -0400
Subject: Re: [RFC 0/4] orinoco: use cfg80211 for key manipulation
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave <kilroyd@googlemail.com>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
In-Reply-To: <4A7C9ED0.8000600@gmail.com>
References: <1249504372-17063-1-git-send-email-kilroyd@googlemail.com>
	 <4A7C91B8.2010106@gmail.com>
	 <1249680231.26088.42.camel@localhost.localdomain>
	 <4A7C9ED0.8000600@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-hZDqkXVhTHLKgSYguB9s"
Date: Fri, 07 Aug 2009 23:50:21 +0200
Message-Id: <1249681821.7194.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hZDqkXVhTHLKgSYguB9s
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-07 at 22:38 +0100, Dave wrote:

> Just tried wpa_supplicant in nl80211 mode. In that case, it's stuck in
> scanning (presumably ignoring my ap_scan setting). It's not seeing my AP
> (because it's hidden?), and so doesn't proceed. And I can't seem to get
> it to do an active scan for my AP.

(just quickly skimmed this thread, will reply in more detail tomorrow if
there's still a need)

You can put scan_ssid=3D1 into a network block to make it scan for the
SSID.

johannes

--=-hZDqkXVhTHLKgSYguB9s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKfKGaAAoJEODzc/N7+QmavKoP/ikesuH4b84Wfk95owcP51SR
RPoNtZhHH4drVKkhdK3H0bk1Yt/k8H+jJiO+GOtYwtFfnV52bfrqaEyKCkdCcVjl
qEhq+NXVwmcHrOdGfYEDUU9N/FVq8yIihT0MkexRUU81bO3SJ5V9FoNHKPWpezz2
5+YtBf+acI+BccFFbkmJKU5YhCSAurcWEK8nbzpOlgosIjQ5/I1UE3aPq3Ga2U69
WxkdBNBi8omTYywV7RzQRvNHY4pl7hie1jByCA6BNVvWxaS1EW1L4seskEM+4kfk
blG+L4zkwEheYz37rE+CBpS7rR3wDZs6BOp9SzJWwreounAZ31U2qsq7o936AH1C
J9hdFevStxINJDKbkz+qzbdPjlInNdcGsmmYnSRMNPByuGks5SRNmgOcVqzgPtX+
3D0yQMCryKkT/Gth3v2b5gte4y4aaCAvFVynZBUbTe/VlB4OUnsFlQCwPfYnehAh
896qjDeSOHXXB8q2l0WXCc9gH+aKHkXbATMxX+PZszjIx2OYV+d3KD7pFs8tGDMW
Esm5s19Xf47zG8dxfVPWSLUZl1nPeUV42BDpBmf65Q3Qq3V1XQMO8490HQm85PQN
lCZnAfZtlbeVlsKNLscHIxGBy/l31pDA26p09LBzv+tDTSdPknujVI9EHK0Te0tN
w0OXqb7XPYf+oJEucPPn
=WEBy
-----END PGP SIGNATURE-----

--=-hZDqkXVhTHLKgSYguB9s--

