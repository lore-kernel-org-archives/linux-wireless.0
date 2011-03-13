Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43063 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003Ab1CMOYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Mar 2011 10:24:17 -0400
Received: by qyg14 with SMTP id 14so3703530qyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Mar 2011 07:24:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <op.vr99odoz3ri7v4@arend-laptop>
References: <33960.57403.qm@web34205.mail.mud.yahoo.com>
	<op.vr99odoz3ri7v4@arend-laptop>
Date: Sun, 13 Mar 2011 15:24:15 +0100
Message-ID: <AANLkTinFJt92Ai_DGWDE7VrTV4gb0h7Dz6rW_Hb7nvnt@mail.gmail.com>
Subject: Re: Broadcom USB Dongle Wifi BCM4323
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: HiEn <vhpham80@yahoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/3/13 Arend van Spriel <arend@broadcom.com>:
> On Sun, 13 Mar 2011 10:18:32 +0100, HiEn <vhpham80@yahoo.com> wrote:
>
>> Hi Arend,
>> I've tried but could not find the driver source code (linux) for BCM4323
>> (USB Wifi Dongle).   Could you please give me some advise?
>>
>> Thanks and best regards,
>>
>
> Well, you did not find it because there is no open-source support for it.
> Both b43 and brcm80211 drivers do not provide usb support (see table at
> http://wireless.kernel.org/en/users/Drivers/b43#Known_PCI_devices). It is
> suggested to use ndiswrapper, but I guess that is not your goal as you are
> looking for source code.

Does anyone have some hardware knowledge about that card? Is this
standard SSB/AI bus with USB host? Or some totally different hardware?

-- 
Rafał
