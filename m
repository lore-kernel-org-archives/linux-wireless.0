Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:50353 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbZLCNkF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 08:40:05 -0500
Received: by fxm21 with SMTP id 21so1411101fxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Dec 2009 05:40:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B17BE42.8040407@lwfinger.net>
References: <1259756709.31590.62.camel@peura.elisa-laajakaista.fi>
	 <4B169608.3010902@lwfinger.net>
	 <1259822699.31590.914.camel@peura.elisa-laajakaista.fi>
	 <3ace41890912030401k7cb41386rc134e167a8e4bea6@mail.gmail.com>
	 <4B17BE42.8040407@lwfinger.net>
Date: Thu, 3 Dec 2009 13:40:10 +0000
Message-ID: <3ace41890912030540y1abbab45v765518d4845dd20c@mail.gmail.com>
Subject: Re: New rtl8187 rfkill support blocks my wlan for good.
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?ISO-8859-1?Q?Antti_Kaijanm=E4ki?= <antti@kaijanmaki.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 3, 2009 at 1:33 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> What does your system report as the cut label and the customer ID? If
> the OEM gets to choose how the GPIO pins are wired, perhaps we can use
> that info to differentiate between a value of 0x2 vs 0x4.

What's the "cut label"? Your mean the "RTL8187BvE V0 + rtl8225z2"
part? Here is mine, and it seems identical to Antti's: (I just removed
my mac-address). So everything looks identical, really, I think.

phy0: Selected rate control algorithm 'minstrel'
phy0: hwaddr -----------------, RTL8187BvE V0 + rtl8225z2
rtl8187: Customer ID is 0x04
Registered led device: rtl8187-phy0::tx
Registered led device: rtl8187-phy0::rx
rtl8187: wireless switch is off
usbcore: registered new interface driver rtl8187
udev: renamed network interface wlan0 to wlan2
...
rtl8187: wireless radio switch turned on
rtl8187: wireless radio switch turned off
rtl8187: wireless radio switch turned on
rtl8187: wireless radio switch turned off

And the last few lines from playing with the rfkill switch on the laptop.

> If anyone else has a built-in RTL8187L with a radio-kill switch, I
> would appreciate getting information regarding your system. The 2
> lines are as follows:
>
> phy0: hwaddr XX:XX:XX:XX:XX:XX, RTL8187BvE V0 + rtl8225z2
> rtl8187: Customer ID is 0x04

Looks the same here.
