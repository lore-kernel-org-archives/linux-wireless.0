Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51325 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab2EXBNs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 21:13:48 -0400
Received: by yhmm54 with SMTP id m54so7271023yhm.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 May 2012 18:13:48 -0700 (PDT)
Message-ID: <4FBD8B42.5020708@lwfinger.net> (sfid-20120524_031353_545055_62B55BF7)
Date: Wed, 23 May 2012 20:13:38 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mourad De Clerck <bugs-wireless@aquazul.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: firmware loading fails for b43 using linux 3.4?
References: <4FBD7772.6070305@aquazul.com>
In-Reply-To: <4FBD7772.6070305@aquazul.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/23/2012 06:49 PM, Mourad De Clerck wrote:
> Hi,
>
> I'm probably missing something obvious, but when going from 3.3 to 3.4 the b43
> driver throws up an error, saying it can't find the firmware - but it really
> _is_ there.
>
>
> Here's the error:
>
> b43-phy0 ERROR: Firmware file "b43/ucode16_mimo.fw" not found
> b43-phy0 ERROR: Firmware file "b43-open/ucode16_mimo.fw" not found
> b43-phy0 ERROR: You must go to
> http://wireless.kernel.org/en/users/Drivers/b43#devicefirmware and download the
> correct firmware for this driver version. Please carefully read all instructions
> on this website.
>
>
> Here's the firmware it claims doesn't exist:
>
> $ sha1sum /lib/firmware/b43/ucode16_mimo.fw
> 825a4bc63e3a96bb20fd8551add947435d47ad46 /lib/firmware/b43/ucode16_mimo.fw
>
> This is from Debian's firmware-b43-installer package, version 1:015-14.
>
>
> The network card in question:
>
> 02:00.0 Network controller [0280]: Broadcom Corporation BCM4322 802.11a/b/g/n
> Wireless LAN Controller [14e4:432b] (rev 01)
>
>
> The only obvious change is 6b6fa5868eec26bdc6a83543cebb8cf832a2645a by Larry
> Finger. I don't know if it matters, but b43 is statically compiled in the kernel.
>
> Am I missing something?

I do not know. I am building a system with b43 built in. Have you tried using 
b43 as a module?

Larry

