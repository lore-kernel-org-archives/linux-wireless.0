Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58831 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab2AZSsq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 13:48:46 -0500
Received: by yenm6 with SMTP id m6so407127yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 10:48:46 -0800 (PST)
Message-ID: <4F21A01E.20105@lwfinger.net> (sfid-20120126_194850_164983_1AB4C6E1)
Date: Thu, 26 Jan 2012 12:49:02 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Nikola Gacic <empnik@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Question regarding Linux RTL driver
References: <CAOVbLLHPdC3XkuTs6OapNMFkSbWaRq54D5U3RDY=N4ugZfEKKQ@mail.gmail.com> <CAOVbLLHK=3K5KfYs7V+9PyE2joWTewuXvpS7RzU63GJS0C2=ug@mail.gmail.com> <CAOVbLLH_RXSzXeQ-g7--6QrUBGD63o-9-7a7NjKc=LM8UL2+GA@mail.gmail.com> <CAOVbLLEzuyBkQv0a238SfDrNXi3hf72Kzyjv8L=m9hokhGjx5A@mail.gmail.com> <CAOVbLLFcja-DV1bEq9C2U8q5eohc7O0AE=oymfjMMBOBi4D52g@mail.gmail.com>
In-Reply-To: <CAOVbLLFcja-DV1bEq9C2U8q5eohc7O0AE=oymfjMMBOBi4D52g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2012 11:37 AM, Nikola Gacic wrote:
> Hello Mr. Finger,
>
>      I don't know if this is the right way for contacting you but I couldn't
> find the other way.
>      Firstly, I want to say that I am student at School of electrical
> Engineering in Belgrade and I am working on some embedded project where I tried
> to use you RTL8187 Linux driver to communicate with PIC32 microcontroller over USB.
>      I would appreciate any help with my problem. If you could spare some time
> to read this it would be great. I have several questions. Initialization worked
> fine I think (I get ACK packets), but when I try to finally send IN packet to
> endpoint 0x81 I get NAK packets all the time!
>      I checked code in microcontroller several times and, of course, maybe error
> could be somewhere in initialization, but would that block my IN packets to
> device? I know that PIC32 cannot work in high-speed mode, only  in full-speed,
> but in the datasheet for this dongle it says it can work in full-speed. So I
> want to know does USB card set its speed to full-speed automatically?
>      I think my understanding of driver code is good so you can give me some
> general guidelines regarding initialization if you don't want to go to
> details.Thank you in advance.

Contacting me is OK, but all communication should also be Cc'd to the 
linux-wireless mailing list.

Could you please give me some more details? Is this setup as an ad-hoc wireless 
connection? I know that rtl8187 does not work in AP mode, but I'm not sure about 
ad-hoc mode, and I am unable to test that at the moment.

Which device are you using - RTL8187L, or RTL8187B? The USB ID should tell that.

Yes, the device will work with USB1.1 hardware, and it might even work with 
USB1.0, but I have never tested that.

Larry











