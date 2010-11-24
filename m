Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41496 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab0KXAeC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 19:34:02 -0500
Received: by vws13 with SMTP id 13so4781164vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 16:34:02 -0800 (PST)
Message-ID: <4CEC5D6B.4060401@lwfinger.net>
Date: Tue, 23 Nov 2010 18:33:47 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Klaas De Craemer <klaasdc@gmail.com>
CC: htl10@users.sourceforge.net, linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: RTL8187L: Can only "enable" hw radio switch after Windows boot
References: <4CEA9903.6070604@lwfinger.net> <370521.43644.qm@web29514.mail.ird.yahoo.com> <AANLkTimd0EDGtZFcrhknyacoCQQZNMEKe-kvYNA9z_Bo@mail.gmail.com> <4CEAC868.9040402@lwfinger.net> <AANLkTim_O8SJ5xA4TWfOa2q7NXDG95-PDoXCqosiaGz3@mail.gmail.com> <4CEC2292.1030808@lwfinger.net> <AANLkTi=2rXEGLh+89AhPe_SAP=oH7_=D1GmrCVFRL2uT@mail.gmail.com>
In-Reply-To: <AANLkTi=2rXEGLh+89AhPe_SAP=oH7_=D1GmrCVFRL2uT@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/23/2010 03:06 PM, Klaas De Craemer wrote:
> 
> Don't worry, I live in Belgium and temperatures in winter rarely get
> below -10 °C. I might just jam an USB cup heater in the enclosure...
> 
> If you think there is anything I can help you with, please let me
> know. For now I'll try some more test variations to see if I can find
> more clues.

I got drivers for XP and Linux from the Alfa site. I selected the high-power
version, which should match your device.

I don't know what version is in the Windows version, but the Linux version has
rtl8187_linux_26.1025.0328.2007, which is pretty old. I have
rtl8187L_linux_26.1038.0626.2009, rtl8187L_linux_26.1039.0104.2010, and
rtl8187L_linux_26.1040.0820.2010 on my disk. At this point, I'm not sure which
version was used to generate the in-kernel Linux driver. Perhaps Herton
remembers, but it had to be something about the 2007 time frame.

I had to build a new Windows XP system in a virtual machine. The one I already
had won't run on the machine I have now and the original is in the shop. Access
to the new host is restricted to mornings.

Larry
