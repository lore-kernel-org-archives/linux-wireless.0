Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:40961 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072Ab1AKGOA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 01:14:00 -0500
Received: by mail-wy0-f178.google.com with SMTP id 42so20997701wyb.37
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jan 2011 22:13:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0826983CC0CB074798C42E77D8ACD07F067DE7@pdtms1.pdt.com>
References: <AQHLsOWcAO4PZ7142ESGHYLUk4riDg==>
	<0826983CC0CB074798C42E77D8ACD07F067DE7@pdtms1.pdt.com>
Date: Tue, 11 Jan 2011 00:13:57 -0600
Message-ID: <AANLkTinjGLvWbSnfeNoUkoC2q4jN+uRntSYS6MAvm1vv@mail.gmail.com>
Subject: Re: What pieces are needed for wl1271..what directories, files,
 configs, etc..
From: "Krakowski, Oz" <ozk@ti.com>
To: "Brzezowski, Karen" <Karen.Brzezowski@pdt.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
