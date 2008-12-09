Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50507 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280AbYLIQvm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 11:51:42 -0500
Subject: Re: [PATCH 1/2] mac80211: add suspend/resume callbacks
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, mabbaswireless@gmail.com
In-Reply-To: <20081209161636.M22933@bobcopeland.com>
References: <1227415286-30179-2-git-send-email-me@bobcopeland.com>
	 (sfid-20081123_054218_217354_D63E2DF4) <1227431953.3599.37.camel@johannes.berg>
	 <20081209152908.M73523@bobcopeland.com>
	 <1228838346.1029.10.camel@johannes.berg>
	 <20081209161636.M22933@bobcopeland.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JYH1Ex5JVZ524r5VJ9SJ"
Date: Tue, 09 Dec 2008 17:50:54 +0100
Message-Id: <1228841454.1029.14.camel@johannes.berg> (sfid-20081209_175146_626529_BFBDD1C1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JYH1Ex5JVZ524r5VJ9SJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-09 at 11:29 -0500, Bob Copeland wrote:

> > > +		if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN &&
> > > +		    sdata->vif.type =3D=3D NL80211_IFTYPE_MONITOR &&
> > > +		    netif_running(sdata->dev)) {
> >=20
> > But shouldn't that be !=3D _AP_VLAN && !=3D _MONITOR && running?
>=20
> Oops, of course it should; that if() started life as continue. =20
> But that would just mean a missed call to remove_interface()...=20
> in the driver, which for ath5k just clears the mac, so I don't=20
> know why it would affect the running state of the interface.

Ok, no, it shouldn't affect the running state.

johannes

--=-JYH1Ex5JVZ524r5VJ9SJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPqHqAAoJEKVg1VMiehFYmMAP/2BJWO4q1vAvlrtdgwCYJQdh
+ydyL8wyZWcPC0jFsaKuL9jZj2B0EkxpAwnpYDKD9wA6teDi7WeCldCvTXUJOBtl
OVFmuykbZa3+EF0EUfjimOIGwPJ7Omt3AFeCIHgSF6k9lsPw39UkdNZesiGFRy6C
tGXCCcMeo/6/xu7TbJMwOD5c8U3axvv1lO+WCQyCPAUckcZAL40NfUsBJZnKmXN3
a4QKvNrlKECzmnX8RbMcmx4UD/R2e1yCvwul0kxnTHVq89zxFmK6b82wjUlfNGiS
hiIOCFsRni8SaO0ZQxn/Xu9kmuJXHppaFau4nNyZFoII3qCfxF2AJgT77zy7+cJr
cRDIcEGhXHV7jUlufLc3iPUYbgzj+90W++nzbS1VVKd1HZY00Un1ohdm0je4ttro
gEtXD3v50ulENayvHy82q1MpjStbicz8KIvAFGXy9J7QWXSUVK+P2HL4MLM6c9N4
smyyjVj+weyCA0JtPGaM2yPLryAg1OYlqz10OMVnmTCi1LAlErCPe8GjCLYZiJS3
oTHDiJRZCVVecZzXehBvgXzXm0e0myVzV2u/6AlGDX2TXHepGCGThPdjNqFrBg1q
a0rAL84MnqN8iSsV7mNa7gWanbdxD6ygbF6uzw5P0vRlmu5xhebkOPMMcSJ3rEOS
75TMWh3EkoO0k4NA3iu5
=J0te
-----END PGP SIGNATURE-----

--=-JYH1Ex5JVZ524r5VJ9SJ--

