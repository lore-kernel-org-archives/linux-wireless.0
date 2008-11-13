Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49331 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbYKMXDv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 18:03:51 -0500
Subject: Re: ath5k master (AP) mode
From: Johannes Berg <johannes@sipsolutions.net>
To: RUMI Szabolcs <rumi_ml@rtfm.hu>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <20081113235928.3ed79ff6.rumi_ml@rtfm.hu> (sfid-20081113_235941_810109_7B5C345C)
References: <20081112224810.8d4ca179.rumi_ml@rtfm.hu>
	 <1226530010.15173.0.camel@dv> <20081113004632.d8d821c5.rumi_ml@rtfm.hu>
	 <20081113181155.c556bde1.rumi_ml@rtfm.hu>
	 <1226598550.5839.3.camel@johannes.berg>
	 <20081113235928.3ed79ff6.rumi_ml@rtfm.hu>
	 (sfid-20081113_235941_810109_7B5C345C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jc7kV3igamMU3tkXv4Lw"
Date: Fri, 14 Nov 2008 00:03:15 +0100
Message-Id: <1226617395.4196.3.camel@johannes.berg> (sfid-20081114_000358_507274_E73B762E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jc7kV3igamMU3tkXv4Lw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-13 at 23:59 +0100, RUMI Szabolcs wrote:
> On Thu, 13 Nov 2008 18:49:10 +0100
> Johannes Berg <johannes@sipsolutions.net> wrote:
>=20
> > > I have compiled a kernel from wireless-testing git of today (2.6.28-r=
c4-wl)
> > > then recompiled and tested hostapd-0.6.5 against that,
> >=20
> > look, you need hostapd from git
>=20
> If you look a bit further down in that email, I've also tried
> exactly that afterwards but unfortunately it made no difference.
>=20
> BTW I've made a diff -rduN between hostapd-0.6.5 and todays -git
> but haven't spotted anything relevant to my problem anyway.

ath5k is at fault; I think there were patches but I know nothing about
ath5k

        hw->wiphy->interface_modes =3D
                BIT(NL80211_IFTYPE_STATION) |
                BIT(NL80211_IFTYPE_ADHOC) |
                BIT(NL80211_IFTYPE_MESH_POINT);


johannes

--=-jc7kV3igamMU3tkXv4Lw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJHLIvAAoJEKVg1VMiehFYJ+EP/iZIrU9fo/qbWjyyVHp5RCrL
KcvLttOg4lXQRfnYIz5OLTt83mR2sqizq4tMKjJacGARiDQiqmnPq+5IEWwVCben
yKLMWDlT/NqpZFv/rkLtYBzHBdQjJR5JO4pV+l/wiEUAkTF5sYTSrx7kF47OKiWh
+trGEh2m39DyNjehQ0pRr4xH5nbOeCTrQEHFj5HRzP802SdmpEXpKc8DO/pZFYzg
PncS8rBBhiCovQIPxYQCUJApg+YneKcN6a8Iu9K966geCFmwfjKU5X0DGFwoQ8p0
7PL2lbys0duwYeWNj0nCrPFqWSVZaxDLcK2sZwYKavp5haLeWXnyMtJDMc7hSYSK
tOXFMTpukPFy/YWx8ltjBLafGGN0TUlMMWpaHLIsWJbWKr82Zt218R/TmqeGo2T1
Qi3OSSyLXEgpLrJXXLmOKxkYOZ18tuhCvoA/X4Ro+vHwq/z+Nz9N0cB95REVBlFS
U+eZqfH6modyMW2E1glq0yeAXKZPliQAHnpTDaICYHPt1Cuv4aQ+HOc6uVN9Mbaq
GA+shvLtsWx45SMJlH/JcMwcvKtKEZdA54x/TIfhXaARcSUSAbXsLqnBPHQB+Ofl
8LGBl0xxY6BOjjW0psmK7Tt1cyD0Sosw7aq5IvqNwaEPSm4grmK90NV77a6odV/F
YunPPA0Irn2LK+aG/toF
=qByB
-----END PGP SIGNATURE-----

--=-jc7kV3igamMU3tkXv4Lw--

