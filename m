Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55023 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759048Ab2HXRgS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 13:36:18 -0400
Received: by wibhr14 with SMTP id hr14so1200637wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 24 Aug 2012 10:36:17 -0700 (PDT)
Message-ID: <1345829949.1460.5.camel@localhost.localdomain> (sfid-20120824_193622_464995_2E8DD5FD)
Subject: Re: [BUG] brcmsmac: Invalid killswitch handling
From: Sebastian Poehn <sebastian.poehn@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend@broadcom.com>
Date: Fri, 24 Aug 2012 19:39:09 +0200
In-Reply-To: <50375E8F.6010302@broadcom.com>
References: <1345798314.1478.12.camel@localhost.localdomain>
	 <50375E8F.6010302@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-08-24 at 12:59 +0200, Arend van Spriel wrote:
> brcmsmac handled the rfkill switch properly so this would be a 
> regression. I also have Dell laptops here with a physical rfkill switch. 
> What rfkill switch do you have?

I have no idea how to detect the type of the switch (looks like it's
neither connected via usb nor pci). That's what rfkill tells me:

[sebastian@localhost ~]$ rfkill list
0: dell-wifi: Wireless LAN
	Soft blocked: yes
	Hard blocked: yes
1: phy0: Wireless LAN
	Soft blocked: no
	Hard blocked: no

It is a Vostro 3300 with a physical slide switch on the front being
either black and enabled or red and disabled.

> 
> Anyway, I will test over here on my hardware as this regression has been 
> flagged internally here as well. Would you be willing to test a fix on 
> your system when I have one?

Would be a joy for me

