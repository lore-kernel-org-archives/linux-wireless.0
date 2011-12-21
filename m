Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54860 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab1LUSwO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 13:52:14 -0500
Received: by wgbdr13 with SMTP id dr13so14682078wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 10:52:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EF21983.1020107@broadcom.com>
References: <CAG9cJm=YkvHY56LoBoUf3fuh=xb7m+c0GgUzMZX+QyG1+CBCMg@mail.gmail.com>
	<4EF21983.1020107@broadcom.com>
Date: Wed, 21 Dec 2011 19:52:12 +0100
Message-ID: <CACna6rxEjQLj_j-f7WZOtOEGfDa+TPWyLDrn2t-FGZ5T2_fz-g@mail.gmail.com> (sfid-20111221_195218_009356_589D6B4F)
Subject: Re: bcm4331 firmware installer package
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: lina <lina.lastname@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Debian Lists <debian-user@lists.debian.org>,
	=?UTF-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/12/21 Arend van Spriel <arend@broadcom.com>:
> On 12/21/2011 11:59 AM, lina wrote:
>> Hi,
>>
>> I don't know which one (else) can be fit for bcm4331 802.11a/b/g/n (rev 02)
>>
>> From http://wiki.debian.org/bcm43xx#b43_and_b43legacy
>>
>> I tried:
>>
>> 1] aptitude install firmware-b43-lpphy-installer
>>
>> No chroot environment found. Starting normal installation
>> No supported card found.
>> Use proper b43 or b43legacy firmware.
>> Aborting.
>>
>> 2] # aptitude install firmware-b43-installer
>>
>> No chroot environment found. Starting normal installation
>> Unsupported device(s) found: PCI id 14e4:4331
>> Aborting.
>>
>> both of the listed are not working,
>>
>
> The bcm4331 support in b43 is pretty new so I do not expect distros are
> providing packages for it. Your best bet is to get linux-firmware repo
> from git.kernel.org. Probably the b43 developers can point you to the
> specific firmware file you need to use for that phy.

Arend: I'm not sure how to say it nice... but there is only one
company starting with "B" having copyrights to the BCM4331 firmware.
Only this company can legally submit BCM4331 firmware to
linux-firmware repo.

-- 
Rafał
