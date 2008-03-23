Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34063 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931AbYCWMMu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Mar 2008 08:12:50 -0400
Subject: Re: hostapd with mac80211 and rt2500pci: hostapd doesn't receive
	clients EAPOL keys unless mon.wlan1 is promiscuous
From: Johannes Berg <johannes@sipsolutions.net>
To: Bas Hulsken <bhulsken@hotmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1206271458.2902.27.camel@Bas> (sfid-20080323_113430_380950_98BCE00E)
References: <1206271458.2902.27.camel@Bas>
	 (sfid-20080323_113430_380950_98BCE00E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5PQRE+ucaJhyupHAZsVN"
Date: Sun, 23 Mar 2008 13:12:21 +0100
Message-Id: <1206274341.16475.185.camel@johannes.berg> (sfid-20080323_121259_283402_9A458369)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5PQRE+ucaJhyupHAZsVN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Ok, to summarize: hostapd doesn't seem to work at the moment with
> rt2500pci and lates git.wireless-testing. The cause seems to be that
> EOPOL key send from the client does not arrive at hostapd. This can be
> 'fixed' by running tethereal on the monitor interface. Any thoughts on
> what might cause this?

Can you stick a printk into the driver to print out
 * the configured MAC address
 * the filter flags configuration?

Whenever either changes.

johannes

--=-5PQRE+ucaJhyupHAZsVN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+ZJJKVg1VMiehFYAQI3qw//RmMgIsOvP2Cs/J7GEUY1T3LUUv+SFXmW
tL5+1yZEFm6cWvXFoyap9ScmGFG/rhN5cXlubXfM/1ITYmck/Fo6n85JxOlwftt6
04LXf3qyiTEnz24ODXrVCY61JYH0rM/8o52PgQ3cTnC0rU8oFxGzBBDVIiXOKbT1
WikhRbpNKPB5zdEJNJO0B8HECsGAtHfxLoyfdtyaIicAug7l9iB1lio6gz1yoAJ5
4V+kVSggU8PaqvmYLidyzT9mX8Aba/d5JV/m6fdjyTxUQIadjkeaIZybgLI98kAZ
HS81nhBJfXX/C+/HqANiTUcaCUzcYhkjr3160v9wy/Y/qBFmLro2u1wlpetI5eig
QSS47KduIJjBrzP3JgK6345w0aF58LF2sJ35Uy7LZztOLEZ0UGBU3xGSMOg2yarn
IqeaHogfPTsDKc3K+Ftpw/aIdTXEySTrQ59LR/fGKyj9/qTPTXPXcJJVHngz5YGT
1t7jylAWSN8gXi+rBsTuPqaSxzvIBPIMAVKKBKXmnqnJ/bDuPw96hCJY3OlC9GF4
ww4ATkjyQkPIaX0e2jKWnLTVI88u9h+rUzKHxojNfNiq3VhYxLlHDUV4lsGvR6Mt
Dv3VbMy0LM/AMxxtLWrvbJNZCWaQGBcJp6xLuXVL40GS4L/Hp04PzGHzGZ2e2/hf
BF9Fu9ezucg=
=K+ik
-----END PGP SIGNATURE-----

--=-5PQRE+ucaJhyupHAZsVN--

