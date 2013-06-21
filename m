Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from daemonizer.de ([178.77.74.210]:38935 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423672Ab3FUT1j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jun 2013 15:27:39 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: Arend van Spriel <arend@broadcom.com>
Cc: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Subject: Re: Poor wireless reception on BCM4313
Date: Fri, 21 Jun 2013 21:27:49 +0200
Message-ID: <10018887.BRLyK6cNd3@fuchs> (sfid-20130621_212742_204327_364A36B4)
In-Reply-To: <51C4A013.90403@broadcom.com>
References: <1624172.s6pnfBcJL7@fuchs> <51C4A013.90403@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart62361930.aUGgn04GO1"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart62361930.aUGgn04GO1
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Friday 21 June 2013 20:48:51 Arend van Spriel wrote:
> On 06/21/2013 08:26 PM, Maximilian Engelhardt wrote:
> > Hello developers,
> > 
> > I'm having problems with the reception performance of my BCM4313 wireless
> > card. The card is basically working fine, but the reception is quite bad
> > compared to other wifi equipment. I first suspected a hardware problem,
> > but
> > after I tried Windows 7 with the same hardware and having no problem there
> > I'm quite sure this is a software issue.
> 
> Can you sent contents of /sys/kernel/debug/brcmsmac/bcma*/hardware?
> 
> Regards,
> Arend

Hello Arend,

see below.

$ cat /sys/kernel/debug/brcmsmac/bcma0\:0/hardware 
board vendor: 14e4
board type: 608
board revision: 1109
board flags: 402201
board flags2: 884
firmware revision: 262032c

Greetings,
Maxi
--nextPart62361930.aUGgn04GO1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAABCgAGBQJRxKk4AAoJEIHqZH0kK9IVfTcP/RUavqBsVFM2o26mjCafLn13
eTGlBTSUFXZmtJC3tBFULjEjJ98PggTNRG1rQUqWfdpfvobngifmeCw8L7MtRGpU
1zDdOo4s3DWBijlsCZF5KkoPHEBcz5uHXwUN5zPBxbwMiO4+OsEIp4ugLbUP0HMi
nUuu9hmgCVLkHxoPbjWHCVQ6jZ4eqjDHGCMzASwVEX6/3sHsUEPPKqPFJKkiCdgQ
DByNSlJDyrKZyZwFmcUAgcP2jt6XSqwgDcpWfkDVodmlI+lN2upa8d1x3AqkReU+
uGFBhlcB0ahEQ37MdkoZ4JTFjAcQRrJZwg5iwRI07oS5RUa6kRKn6TjktJTR5XS/
w0ghxSeHlSmGCcB9K9ccUBUkJNme/79IEqLcN0v4uYhR/UApwgdlWSi566hYZ5oa
fPJtkP5ds0IBHs9+XOXWmTeI1oLm2whhz/s9846klL7W6JaNGOENsPSjkV7/ndod
Ew9hY4u6seSlqIeraM6wssZCX8E+zEqvNwlYoNlYkqiHR3VJh53Nqak5RrFkNrxA
D2mOs2dRsnzkJLb/pqhEPnmHa/qRgOfaHK0tV0SKR4QhV7lSs5n4wJTy6iPLTokb
IoLCDGb8EX5cy2Hc+6wlb5mRut7sx4Bq9HfnYgVEN5GZqoQodkMJ5X+4+z9jqnBw
6NbwyNuER+hhByQqv3+W
=SWP9
-----END PGP SIGNATURE-----

--nextPart62361930.aUGgn04GO1--

