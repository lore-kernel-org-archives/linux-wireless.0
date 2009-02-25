Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59614 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224AbZBYDcD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 22:32:03 -0500
Subject: Re: [PATCH v3] mac80211: Give it some time to do the TSF sync
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090225004955.227080@gmx.net> (sfid-20090225_015029_602384_627C04D3)
References: <20090221231800.227280@gmx.net>
	 (sfid-20090222_001831_559891_2537405E) <1235439633.4455.33.camel@johannes.local>
	 <20090225004955.227080@gmx.net> (sfid-20090225_015029_602384_627C04D3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-K955j96BquD3WE4fyNdG"
Date: Tue, 24 Feb 2009 17:45:34 -0800
Message-Id: <1235526334.28635.2.camel@johannes.local> (sfid-20090225_043207_902102_D51109C3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-K955j96BquD3WE4fyNdG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-25 at 01:49 +0100, Alina Friedrichsen wrote:
> Hello Johannes!
>=20
> > Please elaborate on what this does. This uses the assumption that
> > reset_tsf() makes it start at 0, and that then the hardware won't sync
> > up until N seconds etc.
>=20
> The ath5k and ath9k drivers do so. If a driver/hardware don't, it
> causes other problems. For example ("iwconfig wlan0 essid new_ibss")
> if the sync isn't done before the first beacon is send and the TSF of
> the old IBSS-Network was higher the the TSF of the new one, so the all
> nodes of the new network now sync to the higher TSF of the old
> network.

Right. I just want to see an explanation in the code.

johannes

--=-K955j96BquD3WE4fyNdG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJpKK8AAoJEKVg1VMiehFYmukQALX+5h3SIKlNWekccG3kUf+v
FXNMWtbt7/PjBJPmZYgjEtNeZSJ4aRwv9TaX/bRWMGyyfeJ3fRnDHHw8q2KMa74Z
VKU7GbesoMte9dgL3AP1ne028uqr+I4dNQd3+9W8zUHmc28grspI6gpz8nU4nUno
b9zAw4H/+tnKlVNNNggpFa2t+d6eowhwgrgG/B97+jUKI7pFDBkIZ6aPwg/BtqLZ
/3hznr58I5ULph+QBnf8xXu1wmgUiRRr1+SQSJhBkhvYnLqKwFxp2kaM5ZFF1iWv
6JjHm2SGA91V3hw6+6/k9zOsZ7N6crNXr8VxBGiDGZ3i1VaIc81abDvHfwgar7xH
cp90BDmxsrLy4R84yRC+pCbb1bYTGGJVhhV04o4X8rNQbUpmiOv7uBWJh+6pNCbY
XLHhaFAhOqQpcSsJrmbHOTGponnWOjBuBVo4n6lUuLX4dEM5LqkqcZ1qcPMvApiK
4iDTMvrDJ8NvFa4H0Fz8rhXLQ58OQWQO9BQ+G1iGMQHT7N8H1mppSkSTKKHCXtyo
Bauu65FCXWnUSeWMxI3a9vIl7Z5CK7CqtPXl1l3VfCQTHoKZMKWByCwBGI7CtfwW
vCYIFsV/9X8sVZHRgmDFIonpzMijOJMMlB3KOXxUMq5rHz/BMT5lb+1O0bV/jVL6
krf8o45qeZDHEDGoknpc
=uOCV
-----END PGP SIGNATURE-----

--=-K955j96BquD3WE4fyNdG--

