Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c2bthomr13.btconnect.com ([213.123.20.131]:5347 "EHLO
	mail.btconnect.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754031Ab1G1XdQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 19:33:16 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Subject: help
To: linux-wireless@vger.kernel.org
Date: Fri, 29 Jul 2011 00:33:13 +0100
MIME-Version: 1.0
From: "Martin Partridge" <martin_partridge@btconnect.com>
Message-ID: <op.vzcrpnuuhgplxr@melanie> (sfid-20110729_013323_805238_F2EC1F19)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I don't understand the last 2 steps, i'm running fedora (ok i lie its  
Fuduntu, but to all intents and purposes its fedora) Kernel version:  
2.6.39.3-1.fc14.i686
i'm using a WG511v2 PCMCIA card, i've downloaded the correct firmware,  
renamed it and modprobed everything as instructed, the bit i'm having  
trouble with is this bit:

Enabling p54

To enable p54, you must first enable mac80211:

Networking Support --->
   Wireless  --->
     <M> cfg80211 - wireless configuration API
     <M> Generic IEEE 802.11 Networking Stack (mac80211)

You can then enable p54 in the kernel configuration under

Device Drivers  --->
   [*] Network device support  --->
         Wireless LAN --->
           [*] Wireless LAN (IEEE 802.11)
           <M>   Softmac Prism54 support
           <M>     Prism54 USB support
           <M>     Prism54 PCI support
           <M>     Prism54 SPI (stlc45xx) support

where do i type this, or what does it mean? I i don't have a 'networking  
support' menu and it's not a program, where do i find this? is it a conf  
file? I'm no stranger to linux but this is perplexing, the card works fine  
on windows, but i can't get it work now. I have a kernel config file in  
/etc/sysconfig but its a bit bare, as shown below:

# UPDATEDEFAULT specifies if new-kernel-pkg should make
# new kernels the default
UPDATEDEFAULT=yes

# DEFAULTKERNEL specifies the default kernel package type
DEFAULTKERNEL=kernel

That's the whole thing.

How do i enable p54 and mac80211, i'm not sure and its bloody annoying.

regards

Martin Partridge

-- 
Using Opera's revolutionary e-mail client: http://www.opera.com/mail/
