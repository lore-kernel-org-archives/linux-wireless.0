Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pdtms1.pdt.com ([207.18.22.4]:26037 "EHLO mail.pdt.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932603Ab1AKTFz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 14:05:55 -0500
From: "Brzezowski, Karen" <Karen.Brzezowski@pdt.com>
To: "Krakowski, Oz" <ozk@ti.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: What pieces are needed for wl1271..what directories, files,
 configs, etc..
Date: Tue, 11 Jan 2011 19:05:53 +0000
Message-ID: <0826983CC0CB074798C42E77D8ACD07F0683D3@pdtms1.pdt.com>
References: <AQHLsOWcAO4PZ7142ESGHYLUk4riDg==>
	<0826983CC0CB074798C42E77D8ACD07F067DE7@pdtms1.pdt.com>,<AANLkTinjGLvWbSnfeNoUkoC2q4jN+uRntSYS6MAvm1vv@mail.gmail.com>
In-Reply-To: <AANLkTinjGLvWbSnfeNoUkoC2q4jN+uRntSYS6MAvm1vv@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Oz,

Thank you for your response.  I have been looking at that web page:
http://linuxwireless.org/en/users/Drivers/wl12xx

when i get the latest driver at
git clone git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git

Do I take everything that comes in this compressed file and replace it in a Linux kernel?
Which Linux kernel is this driver code for?

I'm not really sure what the compat-wireless is...we are using the Linux 2.6.31 kernel
Do I need to get compat-wireless somehow for the 31 kernel?

Then the notes say integrations needs to be gotten for SDIO, Lenient, and platform data pasing..

Then the notes say I need WL127x firmware...

after all that I can build the kernel?

Do you have any example code that uses the interfaces for the wl1271 chip (the APIs)?

I've never ported a driver in Linux before...
I assumed all it would be is to get the driver directory corresponding to the new chip, adding or replacing it
in the drivers directory, build it, and voila, i have a driver to test..

I think I should not have assumed that, correct?

...this is why I'm confused........
:-)
thank you for your time!!!!!!!!!!
Karen

________________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] on behalf of Krakowski, Oz [ozk@ti.com]
Sent: Tuesday, January 11, 2011 12:13 AM
To: Brzezowski, Karen
Cc: linux-wireless@vger.kernel.org
Subject: Re: What pieces are needed for wl1271..what directories, files, configs, etc..

Hi Karen,

On Mon, Jan 10, 2011 at 10:44 AM, Brzezowski, Karen
<Karen.Brzezowski@pdt.com> wrote:
>
> Hello all wireless gurus!!
>
> I've been watching the linux-wireless mailings on the wl1271...........
>
> I've been trying to figure out how to get the wl1271 working with
> imx233 processor...
>
> I think we are moving to Linux 2.6.35 and android gingerbread (2.3)...
>
> I"m very confused as to what files/configs/etc..need to be grabbed to get my task going.......
>
> I see spi, sdio...not sure where all changes are made for the wl1271...i'm assuming
> not just in the ...net/wireless/wl1271 directory.......... i have firmware too...........(.bins..)
>
> I'm quite confused about the chip and how each part will work (BT, WLAN, and FM)...
> Do you have any documentation..(for dummies, that would be me!)
> that would help me understand about the chip..how it communicates to the processor,
> how it does it's job with respect to BT, WLAN, and FM, etc..
>
> I have NO idea where to begin.......I've been googling and reading and I have downloaded
> your wl12xx git........

If you haven't done so already, suggest you start by going through the
following wiki page: http://linuxwireless.org/en/users/Drivers/wl12xx
This should give you an idea of where to get the latest code, how to
compile it to your kernel (using compat-wireless) and links to the
relevant patches needed.
This will get you started with WLAN.

>
> If you can help me AT ALL to get me up to speed/ to start, what i need to do to connect
> the wl1271 to the imx233....if not imx233..that whatever you have........

The wiki page does include some basic information needed in order to
port to different hardware platforms.

Regards,
Oz.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
