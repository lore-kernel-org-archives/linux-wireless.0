Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60706 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572AbYB1P6C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2008 10:58:02 -0500
Subject: RE: Roaming issues: AP deauthentication.
From: Johannes Berg <johannes@sipsolutions.net>
To: Lars Ericsson <Lars_Ericsson@telia.com>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <008401c8797e$d5352810$0b3ca8c0@gotws1589>
References: <008401c8797e$d5352810$0b3ca8c0@gotws1589>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uhpteeU261UmJYH+Xl4m"
Date: Thu, 28 Feb 2008 16:57:47 +0100
Message-Id: <1204214267.6309.66.camel@johannes.berg> (sfid-20080228_155809_104539_30FDDC3B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uhpteeU261UmJYH+Xl4m
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > My patches simply put the mac layer in IEEE80211_DISABLED state and=20
> > wait for the supplicant to decide.
> >
> > That would break supplicant-less operation which we can't do.

> The patch might not work for all use cases,=20
> but might be configurable for the wpa_supplicant.

I suppose we could do that if the current BSSID was set fixed?

> After the patch it looks as follows:
> where the STA roams from 60:00 to 64:f0:

I can't really see much difference but that may be because the lines are
broken weirdly :)

Can you post the actual patch?

johannes

--=-uhpteeU261UmJYH+Xl4m
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8bZ+qVg1VMiehFYAQKj/g//fs5YJaH4ednHm+3UIqvGOekcmcicmxnh
kUFVhv1EMKAgGVNPZiglK/zg0ZxgkT73e+tPwDJchL+KIMR9cX47XpDbz4zCniOu
eZubl0QnH3UWP12N7YAjlDwoTB9/8dw0P+z6mH3ffH2hQMOc8IoxZxkKkNUHLWDZ
0D3xKGvpFKNPyw2ksLVvXCpXREcwh9EJ3sCaLME9i3ptUr1gE4YztjZqugYAPJo+
6a0S8LUzJ7Mu8SBP+fZRfYt7fCHUUVj/iJRWodxZAcE7kEAdtL87BRAV27gInxad
TXFWjJaGrdyOwYJA8voTG3nNUEho6HovxeTWDar7GitDUC5BlPzOhtkV/c4cnOSd
IWH8U8DkXikGVL30BnOvt9wCf6ITxnaIQ9pOdHi5Iloh80115QbqE9jpNzCA0LY9
dy6z1WbcS+WFzynmdQAWeR+EY8IuI0kc6ICgwEAQq4b8Ik6QsWR+a7C658gJhk4G
Q53wOoe/zkea2eB26cjyU2+RLysFwKvAKUTrwAhe4jcP/6EAPNxa/7tmtLLetqFG
EK56F8IeYfwk+NbapsvGd3NPhV8SWkk4soNDzsxtfua7iNWVlYbmEzKYyYuGPBGz
1I+JXr/65Cic4G//lm/E0+qDRPqFoZ8HverzRSWYreFCmqZxpwIt54qs8NEVyq2e
PCXwo1jlAcE=
=zedm
-----END PGP SIGNATURE-----

--=-uhpteeU261UmJYH+Xl4m--

