Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1391 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab1LURiW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 12:38:22 -0500
Message-ID: <4EF21983.1020107@broadcom.com> (sfid-20111221_183825_398031_0E06AD08)
Date: Wed, 21 Dec 2011 18:38:11 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: lina <lina.lastname@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Debian Lists" <debian-user@lists.debian.org>,
	=?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Subject: Re: bcm4331 firmware installer package
References: <CAG9cJm=YkvHY56LoBoUf3fuh=xb7m+c0GgUzMZX+QyG1+CBCMg@mail.gmail.com>
In-Reply-To: <CAG9cJm=YkvHY56LoBoUf3fuh=xb7m+c0GgUzMZX+QyG1+CBCMg@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/21/2011 11:59 AM, lina wrote:
> Hi,
> 
> I don't know which one (else) can be fit for bcm4331 802.11a/b/g/n (rev 02)
> 
> From http://wiki.debian.org/bcm43xx#b43_and_b43legacy
> 
> I tried:
> 
> 1] aptitude install firmware-b43-lpphy-installer
> 
> No chroot environment found. Starting normal installation
> No supported card found.
> Use proper b43 or b43legacy firmware.
> Aborting.
> 
> 2] # aptitude install firmware-b43-installer
> 
> No chroot environment found. Starting normal installation
> Unsupported device(s) found: PCI id 14e4:4331
> Aborting.
> 
> both of the listed are not working,
>

The bcm4331 support in b43 is pretty new so I do not expect distros are
providing packages for it. Your best bet is to get linux-firmware repo
from git.kernel.org. Probably the b43 developers can point you to the
specific firmware file you need to use for that phy.

> [29546.428819] b43-phy0 ERROR: FOUND UNSUPPORTED PHY (Analog 9, Type
> 7, Revision 1)

Gr. AvS

