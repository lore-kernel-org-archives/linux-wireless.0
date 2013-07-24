Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46732 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab3GXOkY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jul 2013 10:40:24 -0400
Message-ID: <51EFE74E.3090006@hauke-m.de> (sfid-20130724_164036_204195_57D26E6E)
Date: Wed, 24 Jul 2013 16:40:14 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Jordan McCarthy <mccarthy@opentechinstitute.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: IBSS-RSN support for BCM4313
References: <51EFC944.40502@opentechinstitute.org>
In-Reply-To: <51EFC944.40502@opentechinstitute.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/24/2013 02:32 PM, Jordan McCarthy wrote:
> Hi Linux wireless folk, I am a developer at a non-profit working on
> a wireless mesh networking platform, and we've just discovered that
> we have a fleet of netbooks with the Broadcom 4313 chipset, one
> that does not work particularly well (and sometimes not at all) in
> ad-hoc mode.
> 
> What's more, none of the available drivers seem to support
> IBSS-RSN, which is absolutely essential for the requirements of our
> platform. Accordingly, I wondered if anyone has any experience
> trying to get the BCM4313 to work in an IBSS-RSN configuration, and
> if not, what is needed to get either of the following:
> 
> - brcmsmac to support adhoc mode - b43 to cover the BCM4313

Hi Jordan,

I added basic adhoc mode support to brcmsmac in 3.10 [0].
This did not got much testing by me. If you want to improve this have
a look on how b43 handles adhoc mode and looking into the initial
brcmsmac commit to staging also helps.

Hauke

[0]:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=c55b3766054d3db7a9732c6c8a1c81afac2cfaa6
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJR7+dOAAoJEIZ0px9YPRMy/XEP/0B7JBgJYZwwbZZOX4reia6F
XGDoJ3FARwmTgsrIyR9ad8bkEjGUnBfXaln/9we1ePRGG+3floLgY7AifX6iaKib
C6wh3ivFLD05l2CkHLUR1As9o0kh09m+ke34gF0JzQ5g7CLAmNtHhoE1NcPXVsfd
VyRI35Gz47hO1w5b66zPmM8rMx1ua1I31gCJ50Cjbk3EEgnrQqtERxpwKrZTd13w
0qDR7gShcAoFYYBvKbf4mScJbuzOkYwOU9cpn6nIbZm48uhgpPHjR1fuuK5UF7dn
ZyDxdap4S4f9lQPPZtC+ne9SWigP6wuYxHZiUTL6jbcZcL14AHzDdQfuIzO+4cjK
+GPomc4BkDnhWg9AcbzquF9tw9YE7h0aKGHknB1DYTkRZnvTrwKjsGdu9TBxwlFz
QHe+pTHOndf+s9/aGqYm/sxq3GOGXHl+OUp8ErOUzLRCvCvy+QyHDBPoeT8BYe6/
k513hqc1eV64ypV/Mns2V1ZbLiLC7huK6pgcrQSeNfvq6JHw8fmMZuhuIVARum1R
iiEnuX7ZbR3L+MgJTE9K7RT5nkrRyj1/IAxd4/hPulBmCHkQnRFM2f+rVOBa5U/k
MsqgaCwEVotlHDy+lXFDQTyhWsizEGW2ebZihP3EI2I3U4qEuLgFg2pNG29ded8w
OrVIlJi8TbUXAbJWpyDC
=M1wB
-----END PGP SIGNATURE-----
