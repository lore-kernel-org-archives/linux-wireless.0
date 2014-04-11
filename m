Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54613 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755772AbaDKNuL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2014 09:50:11 -0400
Message-ID: <5347F307.1070006@rempel-privat.de> (sfid-20140411_155018_256056_A0EA48A8)
Date: Fri, 11 Apr 2014 15:49:59 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Kathiravan Thirumoorthy <t.kathiravan@globaledgesoft.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] 802.11k support in  ath9k
References: <53453C3F.3090605@globaledgesoft.com> <53479A12.6000706@rempel-privat.de> <5347A51F.7030102@globaledgesoft.com>
In-Reply-To: <5347A51F.7030102@globaledgesoft.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="X9b4aJIgTxqrqe7Rv0NEbs9ui9W21Tn6k"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--X9b4aJIgTxqrqe7Rv0NEbs9ui9W21Tn6k
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 11.04.2014 10:17, schrieb Kathiravan Thirumoorthy:
> On Friday 11 April 2014 01:00 PM, Oleksij Rempel wrote:
>> Am 09.04.2014 14:25, schrieb Kathiravan Thirumoorthy:
>>> Hi Folks,
>>>
>>> I am thinking to work on 802.11k. To start up with this, I would be k=
een
>>> to know if ath9k supports RRM(802.11k) functionality?
>>> Looking for your valuable feedback and suggestions to start with.
>>> Thanks in advance.
>> I would suggest you to start investigation on your own. I'm not sure,
>> but probably you should take a look at hostapd and linux/net/wireless =
-
>> most of 802.11k work should happen on upper levels.
>>
>>
> Hi,
>     In hostapd, I searched no information regarding 802.11k. In kernel
> source also i didnt get much information. So I need to generate some
> action frames which are mentioned in specifications. I am getting the
> error(no:-67) for those frames. Any patches can i get???

How do you generate this frames and where did you get this error?

So far i can see, there was no work done on 802.11k - no patches (Fixme
if i'm wrong).

I would suggest you, to start discussion on linux-wireless and hostapd
maeling lists. Most of changes will go to mac80211 and hostpad or
wpa_sup..  Probably first of all you will need to implement monitoring
for 80211k. For example tcpdump and wireshark should be able to decode
it. It will make your work easier.

--=20
Regards,
Oleksij


--X9b4aJIgTxqrqe7Rv0NEbs9ui9W21Tn6k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlNH8woACgkQHwImuRkmbWnzAwEAg1X4qXxVKC/eLJwxIp5MIC8Q
zQCcZaXYdhC8D4z0DGkA/0anHuMI/Ro6mzp48jx4ucVfAWE1Te52Sj0w3HksMcRF
=6Kel
-----END PGP SIGNATURE-----

--X9b4aJIgTxqrqe7Rv0NEbs9ui9W21Tn6k--
