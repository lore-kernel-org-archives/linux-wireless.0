Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:17768 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab0C3TUf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 15:20:35 -0400
Received: by ey-out-2122.google.com with SMTP id 9so97318eyd.5
        for <linux-wireless@vger.kernel.org>; Tue, 30 Mar 2010 12:20:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BB24655.5040908@gmail.com>
References: <4BB24655.5040908@gmail.com>
Date: Tue, 30 Mar 2010 20:20:33 +0100
Message-ID: <880c1631003301220n391db934i2e59b415dd9c2a86@mail.gmail.com>
Subject: Re: [rt2x00-users] FW RT307x/RT309x
From: Luis Correia <buga@loide.net>
To: rt2x00 Users List <users@rt2x00.serialmonkey.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xose,

On Tue, Mar 30, 2010 at 19:43, Xose Vazquez Perez
<xose.vazquez@gmail.com> wrote:
> Luis Correia wrote:
>
>> I'm sorry to be kinda annoying, but the firmware cannot be distributed
>> unless it is available directly from Ralink's website with a proper
>> license.
>>
>> Therefore I kindly request that nothing should be done about this request.
>>
>> I will personally contact Ralink and ask for the relevant firmware
>> files to be made available.
>
> FW files are inside the source code of the drivers:
>
> ./pci/2010_0115_RT3562_RT3062_Linux_STA_V2.3.0.0/include/firmware.h
> ./pci/2010_01_29_RT2860_Linux_STA_v2.3.0.0/include/firmware.h
> ./pci/RT3090_LinuxSTA_V2.3.1.4_20100222/include/firmware.h
> ./usb/2009_1214_RT3572_LinuxSTA_V2.3.0.0/include/firmware.h
> ./usb/RT2870_LinuxSTA_V2.3.0.0/include/firmware.h
> ./usb/RT3070_LinuxSTA_V2.3.0.1_20100208/include/firmware.h

Sorry, you can do whatever you want, but I, representing the rt2x00
team cannot back you up in this.

The distributions surely aren't getting the firmware files from source
code, when they are available with a clear license in the
manufacturer's website.

We also do not condone any (mis)use of those firmware files.
However support will only be given to people using firmware obtained
from Ralink.

(and please don't take my words as harsh, we all get stuff from places
we're not actually very proud)

Luis Correia
rt2x00 project admin
