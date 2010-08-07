Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49345 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab0HGFXt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Aug 2010 01:23:49 -0400
Received: by ewy23 with SMTP id 23so3019506ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Aug 2010 22:23:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTim8i245P0nGcnpsf63_O8xXeby9re=pX53WfOwV@mail.gmail.com>
References: <AANLkTi=W=vkgb0gM7ZWsBeE79Fe3iabtKFgu2S7N5uLe@mail.gmail.com>
	<201008011137.49528.florian@openwrt.org>
	<AANLkTik=t=jeCG7=bgkq3LBwJP9vq7KmFpgDeHngPoq-@mail.gmail.com>
	<4C55F377.6040404@candelatech.com>
	<AANLkTi=FEFrKdXUHN-h-BZruvNzSmwXdPcq9-OgZcFAM@mail.gmail.com>
	<4C565100.4040305@candelatech.com>
	<AANLkTim8i245P0nGcnpsf63_O8xXeby9re=pX53WfOwV@mail.gmail.com>
Date: Sat, 7 Aug 2010 15:23:46 +1000
Message-ID: <AANLkTi=Krfwcmn6v7e6jU87A4cM3H06LTU7_XOiB-WUx@mail.gmail.com>
Subject: Re: virtual access poitns (ath5k/mac80211)
From: Ryszard <ryszard99@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Florian Fainelli <florian@openwrt.org>,
	Patrick McHardy <kaber@trash.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hey ben,

i've spend a day attempting to get the kernel installed but am not
having much luck.. the box i'm installing on is an alix
(http://www.pcengines.ch/alix2d13.htm, amd geode) which has an ubuntu
lucid kernel on it.

the error message i'm getting (before it drops to an initramfs) is:
==========================================
Gave up waiting for root device.  Common problems:
 - Boot args (cat /proc/cmdline)
   - Check rootdelay= (did the system wait long enough?)
   - Check root= (did the system wait for the right device?)
 - Missing modules (cat /proc/modules; ls /dev)
chvt: can't open console
ALERT! /dev/disk/by-uuid/371f6b1f-0267-41c1-94d6-4068567af74f does not
exist. Dropping to a shell!



BusyBox v1.13.3 (Ubuntu 1:1.13.3-1ubuntu11) built-in shell (ash)
Enter 'help' for a list of built-in commands.


(initramfs)
==========================================

while the error message may seem obvious (that it cant find the disk)
i'm unsure how to proceed.. are you able to give any tips at all?
(i'll keep plugging away in the meantime)
regs
R

On 2 August 2010 21:16, Ryszard <ryszard99@gmail.com> wrote:
> Hi Ben,
> i'll get to this in the next day or so.
> regs
> R.
>
> On 2 August 2010 15:00, Ben Greear <greearb@candelatech.com> wrote:
>>
>> On 08/01/2010 06:51 PM, Ryszard wrote:
>>>
>>> Hey ben,
>>>
>>> thanks for the reply on this.
>>>
