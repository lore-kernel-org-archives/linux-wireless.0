Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56456 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab1AFSH0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 13:07:26 -0500
Received: by ywl5 with SMTP id 5so6503512ywl.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 10:07:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CEC5D6B.4060401@lwfinger.net>
References: <4CEA9903.6070604@lwfinger.net> <370521.43644.qm@web29514.mail.ird.yahoo.com>
 <AANLkTimd0EDGtZFcrhknyacoCQQZNMEKe-kvYNA9z_Bo@mail.gmail.com>
 <4CEAC868.9040402@lwfinger.net> <AANLkTim_O8SJ5xA4TWfOa2q7NXDG95-PDoXCqosiaGz3@mail.gmail.com>
 <4CEC2292.1030808@lwfinger.net> <AANLkTi=2rXEGLh+89AhPe_SAP=oH7_=D1GmrCVFRL2uT@mail.gmail.com>
 <4CEC5D6B.4060401@lwfinger.net>
From: Klaas De Craemer <klaasdc@gmail.com>
Date: Thu, 6 Jan 2011 19:07:03 +0100
Message-ID: <AANLkTikS6ypimsFK8sgGdRyyTbarXLbYb=h8nMKpcv_v@mail.gmail.com>
Subject: Re: RTL8187L: Can only "enable" hw radio switch after Windows boot
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: htl10@users.sourceforge.net, linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Would there be any progress on this? I'm still having the same issue
on humid days.

Klaas

On Wed, Nov 24, 2010 at 01:33, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 11/23/2010 03:06 PM, Klaas De Craemer wrote:
>>
>> Don't worry, I live in Belgium and temperatures in winter rarely get
>> below -10 °C. I might just jam an USB cup heater in the enclosure...
>>
>> If you think there is anything I can help you with, please let me
>> know. For now I'll try some more test variations to see if I can find
>> more clues.
>
> I got drivers for XP and Linux from the Alfa site. I selected the high-power
> version, which should match your device.
>
> I don't know what version is in the Windows version, but the Linux version has
> rtl8187_linux_26.1025.0328.2007, which is pretty old. I have
> rtl8187L_linux_26.1038.0626.2009, rtl8187L_linux_26.1039.0104.2010, and
> rtl8187L_linux_26.1040.0820.2010 on my disk. At this point, I'm not sure which
> version was used to generate the in-kernel Linux driver. Perhaps Herton
> remembers, but it had to be something about the 2007 time frame.
>
> I had to build a new Windows XP system in a virtual machine. The one I already
> had won't run on the machine I have now and the original is in the shop. Access
> to the new host is restricted to mornings.
>
> Larry
>
