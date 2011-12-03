Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.allnet.de ([212.18.29.59]:18846 "EHLO mail.allnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab1LCOII (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Dec 2011 09:08:08 -0500
Message-ID: <4EDA2D34.4070108@allnet.de> (sfid-20111203_150834_119872_D0502588)
Date: Sat, 3 Dec 2011 15:07:48 +0100
From: Daniel Golle <dgolle@allnet.de>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH v1 0/3] support for antenna configuration profiles
References: <20111128161225.GA25430@localhost>	 (sfid-20111128_171757_078893_7ACF616B) <1322499145.4060.8.camel@jlt3.sipsolutions.net>	 <4ED4C789.8060701@allnet.de> (sfid-20111129_125258_741403_289EEE8F) <1322643422.3982.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1322643422.3982.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Sorry for the delay, I replied off-list by accident and noticed that just now...

On 11/30/2011 09:57 AM, Johannes Berg wrote:
> For example, this seems like hardware mods, so how does the driver know
> what the profiles are?
Available profiles are passed to the driver via platform_data of the PCI device
which is set in the board-setup code.
See changes made to ath9k_platform in the ath9k-specific part 3 of the patchset
and the board-setup (in the appendix of my previous v0 patch-set, as there were
no changes to that since the previous patch, I didn't re-post the changes needed
in arch/mips/ar71xx/dev-ap91-pci.c and my board-setup).


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO2i0vAAoJEDy9cKN/1Et0vxUP/0ubjhKrnOGV+zPPY2P4m6HK
2n0mhcF9rYA3+7I1DB+6ZwECUvWgJTW/+XSG792huFcND7S9KwREa7RlCj9ES6lQ
w1WDuk2xcazZHpGN1+TCkLQHDXDQQ/wBZfUppF4ELGhyj0Gujoo1VcADqcQMwVaO
xVaKUcQN+g5HHsvtnApWh68MfYzEEG5Hk1Z2wqvAc4f8e1knVEZxkMb2nE0o2pLH
mW6sgcg81lXfnK6P9RBPlEQ3Ef8qxpXvrcEbhBv5LXak1waCx6T7ZIV1CsDytWAm
C6Rkaitcu10gua7i4dnlWc6wyKQVBd+sIfrb+QPInmMxbSdzQj1nOylth/3Y6CAJ
b+vQdDDl1WJriVESS/N2ooA7UhHoQhp7/tBQESHZFxE56ejF++fuq4I/I8OqvCIV
qQsuyY36xbHoh/WztqMOBWTcG4y6Mjd9Eb36yV0DeHVKjUrtsBUMaRUyLXMOAjRm
P5XzdbUAKm7HfqKdqxHoNehH2GZ6D46BhGvfUierlZOjAyYPZyeRuJgA15em2zpI
xf98G80m8bN3K4EUKFK78FqULGaitxI4IyR18bdP/5W9bb1Y8IhEKY0pohHX0YJr
6gdsJOKeajg52O/qVkvsjjU/oByBUzk9RVXas4ivO1GDNQ0i/HK+gK40kK9Fq2FN
Wdfu2vKmgfqobSbNlCAY
=LDqq
-----END PGP SIGNATURE-----
