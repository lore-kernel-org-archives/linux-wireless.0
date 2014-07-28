Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:43936 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaG1Tjl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2014 15:39:41 -0400
Received: by mail-oa0-f49.google.com with SMTP id eb12so9184450oac.36
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2014 12:39:40 -0700 (PDT)
Message-ID: <53D6A5D2.2030400@lwfinger.net> (sfid-20140728_213944_051806_14F3AFD4)
Date: Mon, 28 Jul 2014 14:34:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
CC: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: [ANN]: new experimental firmware for 3160 / 7260 / 7265
References: <53D53C0A.6080407@gmail.com>
In-Reply-To: <53D53C0A.6080407@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/27/2014 12:51 PM, Emmanuel Grumbach wrote:
> We released an experimental firmware for 3160 / 7260 / 7265.
> 
> It is available from my linux-firmware.git clone:
> 
> 3160:
> https://git.kernel.org/cgit/linux/kernel/git/egrumbach/linux-firmware.git/plain/iwlwifi-3160-9.ucode?h=Core6
>
> 
7260:
https://git.kernel.org/cgit/linux/kernel/git/egrumbach/linux-firmware.git/plain/iwlwifi-7260-9.ucode?h=Core6
> 7265:
> https://git.kernel.org/cgit/linux/kernel/git/egrumbach/linux-firmware.git/plain/iwlwifi-7265-9.ucode?h=Core6
>
>  We had an issue with the version number in this stream, so I can't release
> it officially, nor can I send a pull request to integrate it to
> linux-firmware.git. I am working with the firmware team to fix the version
> issue. I still would be glad to have more testing on this firmware, so any
> feedback would be greatly appreciated. It has gone through our regular
> testing cycles, but "field" feedback is always valuable.
> 
> Thanks in advance to anyone who will test it.
> 
> New (temporary) version number: 25.223.9.0

I have been running the new version of the 7260 firmware in the 2.4 GHz band.
After approximately 24 hours, I have had no disconnects. At a distance of
about 2 m from a Netgear WNDR3400v2 router, I get netperf transfers of 61-63
Mbps in both directions. In the much-quieter 5 GHz band, the transfers run at
~90 Mbps.

The new firmware looks good.

Larry


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJT1qXSAAoJEN3EhhFFgSoYI28H/1Nb3Q2xxT5GQCC0KxISqgDt
vC4SeWI9v41cUSqDfSirl2swiPoJ397tDHPeewacDbbb62Oj0UTJIEMd2Hltw3E6
PCUThR9lV4JvYcKmq03Hci1QTdXB3MNHbpjc8klTAEXELtwYfHQLLu2DN2p3X1vX
KF2KeNhMykWTpyilnuziyemAoqDcR/5VPQma0E0Imzyir6S4HVFkrJpJWV8q0Ars
MsA1gJDP11jccuuB4NcTbg/VvvmrI8P/iEI3+ISeBnaL6I01uO4VY070wKnX2v9W
xv9RRzm1ZTMpu0iWTZVdJfIJlIb1ZS0vy5GpKEZDiW1BBvQ7tueqzSpNMfDrA60=
=3nbd
-----END PGP SIGNATURE-----
