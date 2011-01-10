Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59205 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab1AJSYv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 13:24:51 -0500
Received: by wyb28 with SMTP id 28so19685398wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jan 2011 10:24:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikS6ypimsFK8sgGdRyyTbarXLbYb=h8nMKpcv_v@mail.gmail.com>
References: <4CEA9903.6070604@lwfinger.net> <370521.43644.qm@web29514.mail.ird.yahoo.com>
 <AANLkTimd0EDGtZFcrhknyacoCQQZNMEKe-kvYNA9z_Bo@mail.gmail.com>
 <4CEAC868.9040402@lwfinger.net> <AANLkTim_O8SJ5xA4TWfOa2q7NXDG95-PDoXCqosiaGz3@mail.gmail.com>
 <4CEC2292.1030808@lwfinger.net> <AANLkTi=2rXEGLh+89AhPe_SAP=oH7_=D1GmrCVFRL2uT@mail.gmail.com>
 <4CEC5D6B.4060401@lwfinger.net> <AANLkTikS6ypimsFK8sgGdRyyTbarXLbYb=h8nMKpcv_v@mail.gmail.com>
From: Klaas De Craemer <klaasdc@gmail.com>
Date: Mon, 10 Jan 2011 19:24:30 +0100
Message-ID: <AANLkTi=iDFiuxKiCXCf54uAf4f1Vk-meNf=4J94Bn4a0@mail.gmail.com>
Subject: Re: RTL8187L: Can only "enable" hw radio switch after Windows boot
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: htl10@users.sourceforge.net, linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

I can add to this that the rtl8187 driver seems to perform worse then
its Windows counterpart (for this device anyway). Today, the Linux
driver could not even connect anymore to the AP. Issuing "iwconfig
wlan0 apname" just doesn't do anything. I could connect to another,
more closer AP in Linux however.
I'm very annoyed to announce that, despite the loss in flexibility, we
will be moving this box to Windows because the wireless connection
then "just works".
I'll still check the list and I will remain available to test anything
that could help the Linux driver though.

Regards,
Klaas

On Thu, Jan 6, 2011 at 19:07, Klaas De Craemer <klaasdc@gmail.com> wrote:
> Would there be any progress on this? I'm still having the same issue
> on humid days.
>
> Klaas
>
> On Wed, Nov 24, 2010 at 01:33, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> On 11/23/2010 03:06 PM, Klaas De Craemer wrote:
>>>
>>> Don't worry, I live in Belgium and temperatures in winter rarely get
>>> below -10 °C. I might just jam an USB cup heater in the enclosure...
>>>
>>> If you think there is anything I can help you with, please let me
>>> know. For now I'll try some more test variations to see if I can find
>>> more clues.
>>
>> I got drivers for XP and Linux from the Alfa site. I selected the high-power
>> version, which should match your device.
>>
>> I don't know what version is in the Windows version, but the Linux version has
>> rtl8187_linux_26.1025.0328.2007, which is pretty old. I have
>> rtl8187L_linux_26.1038.0626.2009, rtl8187L_linux_26.1039.0104.2010, and
>> rtl8187L_linux_26.1040.0820.2010 on my disk. At this point, I'm not sure which
>> version was used to generate the in-kernel Linux driver. Perhaps Herton
>> remembers, but it had to be something about the 2007 time frame.
>>
>> I had to build a new Windows XP system in a virtual machine. The one I already
>> had won't run on the machine I have now and the original is in the shop. Access
>> to the new host is restricted to mornings.
>>
>> Larry
>>
>
