Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47779 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbYEVSfs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 14:35:48 -0400
Subject: Re: [PATCH] mac80211: do not alter injected seq numbers
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: JMF <tolas_feup@hotmail.com>,
	Alejandro Grijalba =?ISO-8859-1?Q?Mart=EDnez?=
	<sud@latinsud.com>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <69e28c910805221121v1a34901co35ec41bff41bd1ec@mail.gmail.com> (sfid-20080522_202122_300727_51A7210B)
References: <47FAB829.9010304@latinsud.com>
	 <200804081025.39645.mb@bu3sch.de> <loom.20080522T171937-155@post.gmane.org>
	 <69e28c910805221115g6290e5e9nef4444efca07aea@mail.gmail.com>
	 <69e28c910805221121v1a34901co35ec41bff41bd1ec@mail.gmail.com>
	 (sfid-20080522_202122_300727_51A7210B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-W3YQ6xc5OcmIDJyCUToH"
Date: Thu, 22 May 2008 20:34:38 +0200
Message-Id: <1211481278.3698.58.camel@johannes.berg> (sfid-20080522_203551_264258_B2DE99BC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-W3YQ6xc5OcmIDJyCUToH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> >> This does not work, since we use injection for other types of
> >>  frames. For example management frames from hostapd. We don't want
> >>  (and can't) make hostapd keep track of sequence numbers.
> >> You'll have to contact radiotap people and add a flag for this.
> >>  This would also solve the hardware counter problem then.

> The flag is IEEE80211_TX_INJECTED. Here is a new patch, for the
> current wireless-testing:

Reorder the two blocks and you have your answer. NO.

johannes

--=-W3YQ6xc5OcmIDJyCUToH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDW8vaVg1VMiehFYAQL5VBAAqCJOI/1Uw8A5pRH5iLQL+bQo8N1+CzV3
pf1JjJLNEnw3fwLh+82H/Y8rkGgRrD/Pd8yp4Tb2s1zk8OGhodF1b+j/llUSwnAy
llocvKv9qGw6YIiKtLtY1Tcql2YsTYMYfNX1uVhC8r6AqqjKbmQbIXHFbF6ds6lA
XQ7cHMm0Y1Rol0/4kdX/Pux2kGP70Biibh+mqOra57FaMA8Q+VgH5PoaYf4UlTWt
eSQws/dFSRA7jJu97egqbs4j2dEJL7DrMZpvkXFR1pl5GhPF5YnR4LwglJo4eqtP
WpOiAbdXII3JjLo6OazIIZPHDiQ22ay0EJVqJ8dgszKv0TAuo4X4nvltGr52D+9m
lPsEiUV5zMTWPH2MK5nsECgjp4azffsGSEkm5NRNxIQNYPzFsPRN07HLmhew3JiW
hqoqoo3feMvpTBxJg31jHpLNBJqx3nBd5rQTSIvm9hltdUtelUmd39nnwb35Ta5B
AJWFbNGIA2ZdN5j6N7IMZNLk0cMstGac66DOd7H9yvBCv1KawPzbS+yU504GHeSb
U62QG/1aazZ5MKyPan+D465diExiCvuuDD/uoSSYwhJ8OlFzLuKUk7PbOQmZSqpa
jSF/oXGAJYx33/SoiBn2kshNwDDOvdUFxWoPUFnKM8yHEFd70qMImAudhN6afLbx
pY5JSjm/pGc=
=kXjB
-----END PGP SIGNATURE-----

--=-W3YQ6xc5OcmIDJyCUToH--

