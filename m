Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39521 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab2GYSAp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 14:00:45 -0400
Received: by vcbfk26 with SMTP id fk26so825467vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 11:00:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <501030E9.3090707@lwfinger.net>
References: <CAAT9HsjZ7wPbkRMH94HDNBS+vOhLigKLYULqfyQobh_Oyt9M4w@mail.gmail.com>
 <501030E9.3090707@lwfinger.net>
From: Tim and Alison Bentley <Home@TRARBentley.net>
Date: Wed, 25 Jul 2012 19:00:24 +0100
Message-ID: <CAAT9Hshwb+iPMALGvP1P2UHzEQbyvYNM0_zz0dHp0mJuy6KwLA@mail.gmail.com> (sfid-20120725_200049_170338_2ACD56A0)
Subject: Re: New Laptop and Driver
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

01:00.0 VGA compatible controller [0300]: nVidia Corporation Device
[10de:0de9] (rev a1)
03:00.0 Network controller [0280]: Atheros Communications Inc. Device
[168c:0037] (rev 01)
04:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev
07)


On 25 July 2012 18:46, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 07/25/2012 12:30 PM, Tim and Alison Bentley wrote:
>>
>> I have a new laptop and running the latest version of Fedora 17 it
>> cannot see the Wireless card.
>>
>> lspci -k
>>
>> 01:00.0 VGA compatible controller: nVidia Corporation Device 0de9 (rev
>> a1)
>>          Subsystem: Device 1b0a:20dd
>>          Kernel driver in use: nouveau
>> 03:00.0 Network controller: Atheros Communications Inc. Device 0037 (rev
>> 01)
>>          Subsystem: Lite-On Communications Inc Device 6618
>> 04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
>> RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 07)
>>          Subsystem: Realtek Semiconductor Co., Ltd. Device 0123
>>          Kernel driver in use: r8169
>>
>> lspci -v
>>
>> 03:00.0 Network controller: Atheros Communications Inc. Device 0037 (rev
>> 01)
>>          Subsystem: Lite-On Communications Inc Device 6618
>>          Flags: bus master, fast devsel, latency 0, IRQ 3
>>          Memory at f7200000 (64-bit, non-prefetchable) [size=512K]
>>          Expansion ROM at f7280000 [disabled] [size=64K]
>>          Capabilities: <access denied>
>>
>> Is this chip known upstream or a new one?
>>
>> [18:28][tim@tigger2] ~ $uname -a
>> Linux tigger2 3.4.6-2.fc17.x86_64 #1 SMP Thu Jul 19 22:54:16 UTC 2012
>> x86_64 x86_64 x86_64 GNU/Linux
>> [18:29][tim@tigger2] ~ $
>
>
> We need to see the PCI IDs for the Atheros device. Use "lspci -nn".
>
> Larry
>



-- 
Tim and Alison Bentley
Home@TRARBentley.net
