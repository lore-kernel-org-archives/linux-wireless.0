Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web36101.mail.mud.yahoo.com ([66.163.179.215]:41971 "HELO
	web36101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750757Ab1BJHV7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 02:21:59 -0500
Message-ID: <762759.49884.qm@web36101.mail.mud.yahoo.com>
References: <426364.35269.qm@web36108.mail.mud.yahoo.com> <AANLkTinoaTFbb3yaEmD5B4q+6U+VVtSVxrqnkryVrxeT@mail.gmail.com> <681857.63296.qm@web36106.mail.mud.yahoo.com> <201102100821.39020.ozan@pardus.org.tr>
Date: Wed, 9 Feb 2011 23:21:57 -0800 (PST)
From: Noel Milton Vega <nmvega@computingarchitects.com>
Reply-To: Noel Milton Vega <nmvega@ComputingArchitects.Com>
Subject: Re: Need Linux driver (preferably 64 bit) for "Intel Corporation Centrino Advanced-N 6230 (rev 34)" WiFI & Bluetooth card ...
To: =?utf-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
Cc: julian.calaby@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <201102100821.39020.ozan@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One more time... hopefully this one doesn't wrap around
on anyone on this list (apologies for the repeat send).

Hello Ozan:

You know that's actually a great point. You just reminded
me of something! I have noticed that, while the laptop
Bluetooth indicator light does toggle On-and-Off each
time I press Fn-12; the WiFi laptop indicator light does
*not*. It has never turned on (*ever*), no matter how many
times I press Fn-11 (the key combination to toggle WiFi
On-and-Off). I just assumed it was the driver issue I
was having (and it may still be).

Here are your rfkill outputs...

Executed when Bluetooth light was on - RX/TX enabled; WiFi light is off.)
root@p170hm# rfkill list

   0: hci0: Bluetooth
      Soft blocked: no
      Hard blocked: no

        Note: Don't let the above 2nd bluetooth interface
        beguile you. This is a tiny bluetooth dongle I
        temporarily attached to a USB port because this
        same N-6320 card also provides the laptop's bluetooth
        capability. But being connected to a USB port, Fn-12
        will not affect it showing up in the output of rfkill
        (see later below - it will remain in the output).

   1: hci1: Bluetooth    
      Soft blocked: no              
      Hard blocked: no              

(Executed when Bluetooth light was off -- RX/TX disabled; WiFi light is off)
root@# rfkill list

   0: hci0: Bluetooth
   Soft blocked: no
   Hard blocked: no

In either case, I see no reference to a WiFi device.

Hope that helps some more.
Regards & Thanks,
Noel





----- Original Message ----
> From: Ozan Çağlayan <ozan@pardus.org.tr>
> To: Noel Milton Vega <nmvega@computingarchitects.com>
> Cc: Julian Calaby <julian.calaby@gmail.com>; linux-wireless@vger.kernel.org
> Sent: Thu, February 10, 2011 1:21:38 AM
> Subject: Re: Need Linux driver (preferably 64 bit) for "Intel Corporation 
>Centrino Advanced-N 6230 (rev 34)" WiFI & Bluetooth card ...
> 
> Perşembe 10 Şubat 2011 günü (saat 07:25:12) Noel Milton Vega şunları  
yazmıştı:
> > Hi Julian,
> > 
> > Thank you for the extended reply.  It's appreciated. Your output wish is
> > my command. Here they are (and  then some):
> 
> Can you run
> 
> rfkill list
> 
> and send the output?  Are there any WLAN toggles on your laptop (a hard switch 
>or Fn + Fx  combination)?
> If yes try playing with them.
> 
> ---
> Ozan  Çağlayan
> TUBITAK/UEKAE - Pardus Linux
> http://www.pardus.org.tr/eng
> 
