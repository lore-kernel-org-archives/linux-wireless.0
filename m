Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:54437 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2LUVxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2012 16:53:24 -0500
Received: by mail-qa0-f53.google.com with SMTP id a19so3821326qad.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Dec 2012 13:53:24 -0800 (PST)
Message-ID: <50D4DA51.6040903@lwfinger.net> (sfid-20121221_225329_015519_DDD1BA34)
Date: Fri, 21 Dec 2012 15:53:21 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Alden Page <pagea@allegheny.edu>
CC: linux-wireless@vger.kernel.org
Subject: Re: bugreport Connectivity problems with rtl8192cu
References: <CABLZTyB1Dr9z_XeHmE0ES6fZ6AqQekqmXxGo_nfRuWgxLgLXSg@mail.gmail.com>
In-Reply-To: <CABLZTyB1Dr9z_XeHmE0ES6fZ6AqQekqmXxGo_nfRuWgxLgLXSg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/21/2012 03:01 PM, Alden Page wrote:
> I apologize for sending this to both maintainers listed on the rtl819x
> privately. I've never had to file a bug before and did not mean to
> give the impression of malice or selfishness, I'm simply unfamiliar
> with the way open source developers go about things.
>
> In any case, I am having some problems with the rtl8192cu driver.
> After a period of five minutes to an hour, I will lose connectivity to
> my wireless router. In the 3.2 kernel, I would be unable to connect
> until I restarted my computer. My wireless SSID would be visible
> through nm-applet, but connecting would just result in network-manager
> prompting me for the password again, attempting to connect for a
> while, and then timing out before repeating the cycle. I compiled and
> installed the 3.7.1 kernel to see if it would solve this problem but
> had no such luck. The only difference is that unplugging the wireless
> adapter and plugging it back in restores connectivity for a period of
> time before the problem occurs again. I also get stuck at "Waiting for
> headers" a lot while waiting for package upgrades. The device is an
> Encore N150, which uses this particular Realtek chipset. The
> proprietary driver does not support my architecture. While I
> appreciate the invitation to "look for the problem myself", I have no
> experience working with the kernel or writing drivers. I'll do my best
> anyway, of course.
>
> Some information about my system:
> Crunchbang 11 on kernel 3.7.1 amd64
> Encore N150 Wireless USB adapter, using network-manager and nm-applet
> Connecting to a Linksys E3000. Works fine with all other devices in the house
>
> The adapter does not lose its connection in Windows, so I think
> hardware failure is unlikely.
>
> Relevant modules:
> rtl8192cu              75225  0
> rtlwifi                81359  1 rtl8192cu
> rtl8192c_common        48515  1 rtl8192cu

One point. GregKH is the maintainer of drivers/staging/*. Some of the Realtek 
drivers are in that tree because they do not meet all the requirements for 
inclusion in the main drivers/net/wireless tree. The driver in question, 
rtl8192cu, is found in drivers/net/wireless.

> The output of dmesg is attached in plaintext.
>
> Thanks for your time (and the warm welcome)

Your attached dmesg output did not even show a disconnection. Why was that?

Larry

