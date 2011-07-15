Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46719 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751560Ab1GOE0V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 00:26:21 -0400
Subject: Re: Bug#633919:
 /lib/modules/2.6.39-2-amd64/kernel/net/wireless/cfg80211.ko: cfg80211
 calling CRDA drops wireless connection, clears ssid
From: Ben Hutchings <ben@decadent.org.uk>
To: Michael Forbes <miforbes@mit.edu>, 633919@bugs.debian.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20110715005011.15043.39294.reportbug@vincent>
References: <20110715005011.15043.39294.reportbug@vincent>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-rlonvprZyLq97KSi8lXh"
Date: Fri, 15 Jul 2011 05:26:13 +0100
Message-ID: <1310703973.8783.270.camel@localhost> (sfid-20110715_062625_130141_40DB4B35)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rlonvprZyLq97KSi8lXh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-07-14 at 20:50 -0400, Michael Forbes wrote:
> Package: linux-2.6
> Version: 2.6.39-2
> Severity: important
> File: /lib/modules/2.6.39-2-amd64/kernel/net/wireless/cfg80211.ko
> Tags: upstream
>=20
>=20
> I have a Lenovo Thinkpad T420, with "Intel(R) Centrino(R) Advanced-N 6205=
 AGN"
> wireless card.  wheezy is installed.  I sometimes connect to one of two
> different wireless networks, both unsecured (I configure the wireless thr=
ough
> /etc/network/interfaces).  In both instances, the connection will drop se=
veral
> times per day, without any provocation.  Another wheezy install on differ=
ent
> hardware had no such problems.  I imagine the issue is with the wireless =
card,
> as that seems to be the most relevant hardware difference between the new=
 laptop
> and the old laptop.
[...]
> Various searches indicate to me that cfg80211 is reseting the
> connection, and that this is causing the problem.  However, I cannot
> identify why it is being called.
[...]
> One more tidbit, I was running 'iw event' (instead of 'iwevent'), and got=
:
>=20
> 2011-07-14 20:38 [root@******** miforbes]# iw event
> wlan0 (phy #0): deauth a0:88:b4:68:59:e4 -> 16:18:0a:30:23:5c reason 4: D=
isassociated due to inactivity
> wlan0 (phy #0): disconnected (local request)
[...]

I would have expected that to appear in the kernel log.

Don't know what's going on here but maybe the upstream wireless
developers can work it out.

The full bug log is at <http://bugs.debian.org/633919>.

Ben.

--=20
Ben Hutchings
Absolutum obsoletum. (If it works, it's out of date.) - Stafford Beer

--=-rlonvprZyLq97KSi8lXh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATh/BX+e/yOyVhhEJAQr5Jw//bpf1Ow6ieVMxTwesLSyvZ+odI5QjEAau
AtJz8UhpXC7rItt+4Uz4UJnKNCKPVvcNFV0BkOP163Tb/PLHLw9X6RQrElm3EfY4
7YrLlkqPVVaXcoNP/l1zkqgd1bR3GjKSzS4viKVol3onHRDFDfIs4o/T5JLQBJ4+
Hom7xFWIz57GRJAE+SaGd8ATpreE66Hh+kmS4t68vrGrEe2kS5w9kK0SNg5Xzwhz
uGjXfAHikhPD6BOxoiqBnPz3XdBrEqATsvZyLqEW3EHtPsnKUAKrgjv3Q6Uv/uOI
cyEs/v0dbjZZV0h7PhrlK8qBHRQIqZIEe6uHzq/KHVZDXU+KVZCve9O3N1ivnPT4
tkibQiFIUaYz5w84xBJ4i1mQUXIrflmnLBScT6UegQ5ds6VgKQSkLaITyapRKGrh
80pzzmOJ88xgRsA8q7EYCgqI+boNbfax+g5crInWapWW6vsQ2h4zoTzt9pchvHEI
8hOzZfesqvJ/Q4YddTKTsrGYtarcnBASeTBD18y+/FnUxsYKTt1G08MHZnjKTbxl
KG8posCv8wvODYkYBhEi8t4H1S4DYcCkpg8I52ccvkGna5pP+4t7NtAjub4gPEC8
iSYNNE5iiuuvu7l7lcvIy2/6Gm6UXht52JKLZTgyYc4IhpNGzHM0CEU/oaKfZL+Y
jixDA1yVI90=
=Q7t6
-----END PGP SIGNATURE-----

--=-rlonvprZyLq97KSi8lXh--
