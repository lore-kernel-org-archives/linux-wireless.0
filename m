Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:64910 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1LVG5N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 01:57:13 -0500
Received: by qadb15 with SMTP id b15so5187591qad.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 22:57:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACna6rxEjQLj_j-f7WZOtOEGfDa+TPWyLDrn2t-FGZ5T2_fz-g@mail.gmail.com>
References: <CAG9cJm=YkvHY56LoBoUf3fuh=xb7m+c0GgUzMZX+QyG1+CBCMg@mail.gmail.com>
	<4EF21983.1020107@broadcom.com>
	<CACna6rxEjQLj_j-f7WZOtOEGfDa+TPWyLDrn2t-FGZ5T2_fz-g@mail.gmail.com>
Date: Thu, 22 Dec 2011 14:57:10 +0800
Message-ID: <CAG9cJm=XE3jQiYvGB4T6_Avj=bmc_wXe8JGMr5hePuCu-OnPuA@mail.gmail.com> (sfid-20111222_075716_894309_45630DF6)
Subject: Re: bcm4331 firmware installer package
From: lina <lina.lastname@gmail.com>
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Debian Lists <debian-user@lists.debian.org>,
	=?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am still a bit confused. (First thanks for the links all of you
provided, but I have visited those web before).

Here is the thing:
BCM4331 802.11a/b/g/n fit for
BCM4331              b/g  HT (r1)

What does the 802.11a for?

On Thu, Dec 22, 2011 at 2:52 AM, Rafał Miłecki <zajec5@gmail.com> wrote:
> 2011/12/21 Arend van Spriel <arend@broadcom.com>:
>> On 12/21/2011 11:59 AM, lina wrote:
>>> Hi,
>>>
>>> I don't know which one (else) can be fit for bcm4331 802.11a/b/g/n (rev 02)
>>>
>>> From http://wiki.debian.org/bcm43xx#b43_and_b43legacy
>>>
>>> I tried:
>>>
>>> 1] aptitude install firmware-b43-lpphy-installer
>>>
>>> No chroot environment found. Starting normal installation
>>> No supported card found.
>>> Use proper b43 or b43legacy firmware.
>>> Aborting.
>>>
>>> 2] # aptitude install firmware-b43-installer
>>>
>>> No chroot environment found. Starting normal installation
>>> Unsupported device(s) found: PCI id 14e4:4331
>>> Aborting.
>>>
>>> both of the listed are not working,
>>>
>>
>> The bcm4331 support in b43 is pretty new so I do not expect distros are
>> providing packages for it. Your best bet is to get linux-firmware repo
>> from git.kernel.org. Probably the b43 developers can point you to the
>> specific firmware file you need to use for that phy.
>
> Arend: I'm not sure how to say it nice... but there is only one
> company starting with "B" having copyrights to the BCM4331 firmware.
> Only this company can legally submit BCM4331 firmware to
> linux-firmware repo.
>
> --
> Rafał
