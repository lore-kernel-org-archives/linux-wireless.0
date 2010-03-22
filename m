Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:17415 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab0CVIn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 04:43:58 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1115389qwh.37
        for <linux-wireless@vger.kernel.org>; Mon, 22 Mar 2010 01:43:58 -0700 (PDT)
From: Steven Wheeler <stevenwheel@gmail.com>
To: "'Pavel Roskin'" <proski@gnu.org>
Cc: <linux-wireless@vger.kernel.org>
References: <002a01cac969$b726e8d0$2574ba70$@com> <1269232531.18891.6.camel@mj>
In-Reply-To: <1269232531.18891.6.camel@mj>
Subject: RE: Problems with Netgear WG511v1 PCMCIA
Date: Mon, 22 Mar 2010 03:43:55 -0500
Message-ID: <000001cac99b$cf9ff140$6edfd3c0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, meant to include it: Kernel is 2.6.27.7

I thought about trying the prism54 driver but was unable to download the
firmware from the links in the P54 site.
No matter what I did I kept getting the html page back as a text file to be
saved, very weird.

-----Original Message-----
From: Pavel Roskin [mailto:proski@gnu.org] 
Sent: Sunday, March 21, 2010 11:36 PM
To: Steven Wheeler
Cc: linux-wireless@vger.kernel.org
Subject: Re: Problems with Netgear WG511v1 PCMCIA

On Sun, 2010-03-21 at 21:45 -0500, Steven Wheeler wrote:
> I am attempting to resurrect my old Toshiba Portege 3110CT laptop
> Installed Slackware 12.2 on it and all is working well except for my
> WG511v1.

Sorry for being blunt, but please don't expect anyone who is busy
hacking wireless drivers to pull Slackware 12.1 and see what kernel
version it has.

> I have reached my knowledge limit and if anyone has a suggestion to try I
> would appreciate it.  I am really hoping I can use this card since money
is
> tight right now

Understood.

> Mar 21 21:29:01 PopsLT kernel: p54: unknown eeprom code : 0x1
> Mar 21 21:29:01 PopsLT kernel: p54: unknown eeprom code : 0x3

If I remember correctly, it's harmless.

Since you are using a softmac driver, and you kernel is likely old, you
have basically two options.

1) Try the fullmac driver (prism54).
2) Try compat-wireless.

-- 
Regards,
Pavel Roskin

