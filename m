Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:5003 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab0CVEfd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 00:35:33 -0400
Subject: Re: Problems with Netgear WG511v1 PCMCIA
From: Pavel Roskin <proski@gnu.org>
To: Steven Wheeler <stevenwheel@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <002a01cac969$b726e8d0$2574ba70$@com>
References: <002a01cac969$b726e8d0$2574ba70$@com>
Content-Type: text/plain
Date: Mon, 22 Mar 2010 00:35:31 -0400
Message-Id: <1269232531.18891.6.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-03-21 at 21:45 -0500, Steven Wheeler wrote:
> I am attempting to resurrect my old Toshiba Portege 3110CT laptop
> Installed Slackware 12.2 on it and all is working well except for my
> WG511v1.

Sorry for being blunt, but please don't expect anyone who is busy
hacking wireless drivers to pull Slackware 12.1 and see what kernel
version it has.

> I have reached my knowledge limit and if anyone has a suggestion to try I
> would appreciate it.  I am really hoping I can use this card since money is
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
