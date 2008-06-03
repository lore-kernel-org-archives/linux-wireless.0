Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n71.bullet.mail.sp1.yahoo.com ([98.136.44.36]:26928 "HELO
	n71.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750757AbYFCIYf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 04:24:35 -0400
Message-ID: <4844FFBF.4060203@yahoo.it> (sfid-20080603_102441_988782_1EDA9CE9)
Date: Tue, 03 Jun 2008 10:24:31 +0200
From: Filippo Zangheri <filippo.zangheri@yahoo.it>
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix rate control initialisation
References: <g1uicv$se6$1@ger.gmane.org> <1212392284.4148.7.camel@johannes.berg> <g21c9v$vdl$1@ger.gmane.org>
In-Reply-To: <g21c9v$vdl$1@ger.gmane.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Sitsofe and everybody,

Sitsofe Wheeler ha scritto:
> This is far better (the rate sets itself to 24Mb/s or 36 Mb/s rather than
> being fixed on 54 Mb/s). However when using iwl3945 the rate could not be
> forced using iwconfig wlan0 rate 54M fixed and it took a little . The rate

Here I have the same behaviour with iwl3945 from
compat-wireless-2008-06-03, I cannot force the bitrate with iwconfig
(Wireless-Tools v29).

But the interface automatically sets the speed to 54M. And it worked
 nominally even before this latest patch by Johannes. I'm pretty
near the access point's antenna; signal strength varies between 99%
and 100% and noise power oscillates between -24 and -19 dBm.

So, maybe, the problem does not reside in the device driver?

Best regards.

- --
Filippo Zangheri

GPG key ID: 0x6C1F2F2F
Key fingerprint: E0A6 2A28 04EF EE13 5C5F 8BB8 8F3C 4C1B 6C1F 2F2F
Key server: pgp.mit.edu

- -----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GE d- s+:- a-- C++ UL+++ P+ L+++ E-- W+ N* o-- K- w--- O-- M--
V- PS++ PE+ Y+ PGP++ t 5-- X++ R* tv b+ DI-- D---- G-- e++ h--
r++ z*
- ------END GEEK CODE BLOCK------
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIRP+/jzxMG2wfLy8RApbpAJ9JuyRPjBfn5h+cnIvJKL1W8LPotACdFe9G
BDW2z00i8j1Djt6xzTz6LiM=
=egTP
-----END PGP SIGNATURE-----

