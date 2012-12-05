Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hotel311.server4you.de ([85.25.146.15]:39449 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2LEIQN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 03:16:13 -0500
Message-ID: <50BF02CA.2030009@monom.org> (sfid-20121205_091616_469135_F56A8FBA)
Date: Wed, 05 Dec 2012 09:16:10 +0100
From: Daniel Wagner <wagi@monom.org>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Seth Forshee <seth.forshee@canonical.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH v2 00/22] brcmsmac: Tx rework and expanded debug/trace
 support
References: <50AA845C.2050809@monom.org> <50AB3182.5040505@monom.org> <20121120142822.GA26602@thinkpad-t410> <50ABC168.8080904@monom.org> <20121120205418.GB26602@thinkpad-t410> <50AC05A5.3090706@monom.org> <50AC07F2.8000400@monom.org> <50ACA28F.9010800@broadcom.com> <50ACA55F.5050406@monom.org> <20121121143528.GC23606@thinkpad-t410> <20121126193655.GF4556@thinkpad-t410> <50B3DD38.5060808@monom.org> <50BC6181.8080307@monom.org> <50BC64C4.9040001@broadcom.com> <50BC7BC8.8030003@monom.org> <50BCE3FF.6020603@broadcom.com>
In-Reply-To: <50BCE3FF.6020603@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend

On 03.12.2012 18:40, Arend van Spriel wrote:
> So what exactly is the brand and model of your home 11n AP. With a bit
> of luck we may have it over here.

It is a "Alice Modem WLAN 1421". It seems to be a device only created for
this ISP. Some research gave me that it might be produced by Arcadyan.
According my findings the chipset would come either from  Lantiq
(Infineon) Danube or Amazon-SE.

BTW, I found a lot of people complaining about that crap hardware.
Not only WLAN performance is pretty bad for lot's of people it also has
sever problems keeping the Internet link open. The only working fix
seems to be to replace it with something which is known to work.

Ah, some more googling revealed this:

https://forum.openwrt.org/viewtopic.php?id=15934&p=23

"""
just wanting to know if i am right

I am having an arcardyan AR7505 board here with an Infineon PSB 50601HL V1.2 SOC

it has 2M Flash - EON EN29LV160AB and a RTL8306 Switch

it runs a BRN Bootloader: Wireless ADSL Gateway AMAZON_SE Loader V0.02.06 build Jul 23 2010 00:32:10

i was able to connect a Serial connector and managed to download the firmware as a backup.

after this was trying to run u-boot from memory (this is where i hit the wall)
from my understanding i do upload an uboot.bin (BRN-Version) version via xmodem to
RAM Memory and execute it from there - since this was only a test, i "just"
tried any danube/lantiq uboot to see if it might work.... but it does not. 
(most of the time the system just reboots . the rest of the time i get an output 
on the serial console that does not seem to be in the correct speed .... and the
system sticks in limbo) can you give me a brief hint what i need to do.

thanks for your help

BTW: it is a German Alice ADSL Wlan 1421 Modem

"""

cheers,
daniel
