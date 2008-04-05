Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48533 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbYDELyv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2008 07:54:51 -0400
Subject: Re: compat-wireless iwl4965 on hp/compaq 2510p
From: Johannes Berg <johannes@sipsolutions.net>
To: Bachman Kharazmi <bachman@tor.lindesign.se>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47F76814.7010405@tor.lindesign.se>
References: <47F75EB4.9090703@tor.lindesign.se>
	 (sfid-20080405_124018_600873_72164D53) <1207396223.3860.9.camel@johannes.berg>
	 <47F76814.7010405@tor.lindesign.se>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AcYnmzdkYfU4M/HXLwN2"
Date: Sat, 05 Apr 2008 13:54:48 +0200
Message-Id: <1207396488.3860.12.camel@johannes.berg> (sfid-20080405_125454_821378_2606F3C7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AcYnmzdkYfU4M/HXLwN2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sat, 2008-04-05 at 13:52 +0200, Bachman Kharazmi wrote:
> Sure..
> lapp:/tmp# iwconfig wlan0 essid planet_mars key B200A92732DA86E90DEFEFF3F=
B

> wlan0     IEEE 802.11  ESSID:"planet_mars"
>            Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associate=
d

> receive_packet failed on wlan0: Network is down

Try turning on the interface first... 'ip link set wlan0 up' might help

johannes

--=-AcYnmzdkYfU4M/HXLwN2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/doh6Vg1VMiehFYAQJzJg//dL+TUfcFf6lIVRNOFyrO3zbuo2S7DFWW
XYq808fNgQA6jqxwXzwOfSeH1K6HAbzqGaMCu50Br2JkogBST6djWwkPtJRjYemJ
HATapiaYlCrULccyW5Zxabpo0NEaBe92Bt+qSmk0Jm6BVCtKqhkmSuP4bYW2dC8k
Mh8oKQW7tsuWmaYTfDLy0pz20DpJ3j+qvwCZuql97Lxes6pLXFI+xqMzmAMK6XpI
8DSeRCNsurucSObc//pbLyei5lc3i4Ml1Kw+fM5Oz06MDZ94RprxTp+di/d3QPL/
jgaqHDJioKBE0f/J0WWIlUKDFjKmD0VaMOyhEOykZx2lrZSSUkEIetUmWl9/0NwW
qH7Y0dj0TBT64jHo6R7KxYBEkppuFTPXQ72LV2qDzb7JQpJHmlRiP90V4d4wAqfJ
7QTJXYkDZ7JT6A6ntR/+0iZMZTAp+o31b5B6MK45XrH/zlQ5+e+P3xHlKpZ8KFnp
hkpE79E0Nv9eHn7g9UNIeSj+KGTt87z6lZUv/dqbEyNT+xMrbhWqMOJgB6UILTu5
f6UyEvoldpMB+TEH3sA7amZu+i32MRBMBJuzhCcZn19xuiMdfOTRehav4Vz3x3jC
/KWR1TXKB3pIsujpyr86U1rL7fG+SnpldJZ1RVt/Ke8R9EKIX8//zpNl8vC7SBxs
SnEdxvXPpwo=
=aG0i
-----END PGP SIGNATURE-----

--=-AcYnmzdkYfU4M/HXLwN2--

