Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33332 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbYBOMwM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 07:52:12 -0500
Subject: Re: DS params only in 2GHz band?
From: Johannes Berg <johannes@sipsolutions.net>
To: bruno randolf <bruno@thinktube.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200802151916.07629.bruno@thinktube.com>
References: <200802151916.07629.bruno@thinktube.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QQhfIe8w55dkAuke1KBz"
Date: Fri, 15 Feb 2008 13:51:34 +0100
Message-Id: <1203079894.8931.184.camel@johannes.berg> (sfid-20080215_125218_469359_170FBE8B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QQhfIe8w55dkAuke1KBz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > +               if (bss->band =3D=3D IEEE80211_BAND_2GHZ) {
> > +                       pos =3D skb_put(skb, 2 + 1);
> > +                       *pos++ =3D WLAN_EID_DS_PARAMS;
> > +                       *pos++ =3D 1;
> > +                       *pos++ =3D ieee80211_frequency_to_channel(bss->=
freq);
> > +               }
> >
> >                 pos =3D skb_put(skb, 2 + 2);
> >                 *pos++ =3D WLAN_EID_IBSS_PARAMS;
>=20
> what's the reason you changed the beacons to include DS params only in th=
e=20
> 2GHz band?

IEEE 802.11 7.3.2.4:

The DS Parameter Set element contains information to allow channel
number identification for STAs using a DSSS PHY.

johannes

--=-QQhfIe8w55dkAuke1KBz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7WK1aVg1VMiehFYAQI52g/8CZx8F1WLogBRmMqA0BSSw1BDNbX14yqA
Lwi9taHl7IXdnj9LJaUkDo5p1PWjP+X3dE8JFsto/UDd2lp29cfh2U4ssSCI3rIf
yBPSTyk/Tk+ZxUZQUIRhamXIX+AZI0AahE+HgSCBz6QW6seBFeZzM5EpBxV+0Mp7
ia0gLDLL9Zceore7/wPvVjgMiWXkGwij3n7XGGNOySNz4B+EkTSlsSWvxUp+tyA7
FSA5wqoCWDbu7Iww45iJ6Xha69PlmmC8dIBlYBh9m/GbQVD/rWoLLouoZDEEvMGk
OmqsLjB/XrIonVPk2GBXcSvlrW/GOJiuxz6XVrvrWWY8uSev+RM9rj7GLHEWmLiu
xAHCHaBdidom8bZ6UUqM1szg2yxtJDZr7NyREz1t+ZLX1kDCiGTtH9EGAN0piyA/
zUTM5h05JMTLms5++ggjA08rFkL8xE9WL9n+sgAc5Gnrn/mTEoZEQ1rDU51Xe2l6
64+4JYB39u/w0rdef5Q0GK+hgiEtGBGdzWMZWlNQattvz2VkOUkleZF1iVoZQNDp
T1VR5Ty9wl0v4mpeeWEEsBdVCNI0n1WSSzgbI30EWFDk+sVvymGs3VP71z1TT+dT
JcBANaSaeIAzvYyDPxemT+uPCa13i1kYa4s9nvtfsbxycr1lbMQvYJxjp8bh/m5U
aa1FkqZwHcs=
=FndD
-----END PGP SIGNATURE-----

--=-QQhfIe8w55dkAuke1KBz--

