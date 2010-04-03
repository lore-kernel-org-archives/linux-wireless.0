Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50687 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab0DCQ6U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Apr 2010 12:58:20 -0400
Received: by gwb19 with SMTP id 19so603676gwb.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Apr 2010 09:58:20 -0700 (PDT)
Message-ID: <4BB773A9.2070703@lwfinger.net>
Date: Sat, 03 Apr 2010 11:58:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Rogerio Luz Coelho <rogluz.news@gmail.com>
CC: linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: RTL 8187b - naughty behaviour
References: <u2u917a57cb1004030656w7aff9e18qa43a358674d52d5a@mail.gmail.com>	 <4BB7660A.3030900@lwfinger.net> <i2x917a57cb1004030949qabd49dfeqa1f7cb66f4ef0f4e@mail.gmail.com>
In-Reply-To: <i2x917a57cb1004030949qabd49dfeqa1f7cb66f4ef0f4e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/03/2010 11:49 AM, Rogerio Luz Coelho wrote:
> 
> I have a MS-Win7 instalation on this Laptop and it works 100% even at
> longer distances than you report,even with walls in between.
> 
> Will do the tcpperf test as soon as I get home. There are other with
> the same problem with my exact chip here in Brasil , that is because
> one of our leading Laptop vendors uses this config.

What is the exact make and model of the device? It might be difficult
for me to get one in the US, but one of the rtl8187 developers lives in
Brazil. He should be able to find one.

> Does it matter that the USB port used in this setting is a connected
> to a USB HUB and then to the mother board?

Is the hub passive, or is it powered? If the hub is good and not
underpowered, it should be OK.

> More details and tests will come your way in a day or two ... will
> reinstall Mandriva 2010 and do some tests with older kernels.

If you can download an openSUSE 11.2 Live CD and burn it, you would not
even have to do an installation. That one has a 2.6.31 kernel.

Larry
