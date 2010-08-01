Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57765 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab0HAQRR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Aug 2010 12:17:17 -0400
Received: by wwj40 with SMTP id 40so3081813wwj.1
        for <linux-wireless@vger.kernel.org>; Sun, 01 Aug 2010 09:17:16 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 1 Aug 2010 12:17:16 -0400
Message-ID: <AANLkTi=XOECFnOgB5mmaDejVhH2aAEedYqz9tyeSz7Ge@mail.gmail.com>
Subject: SMC 2802W -status unsupported
From: David Cozatt <olbrannon@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Accessing http://wireless.kernel.org/en/users/Drivers/p54 shows in unsupported

    * early PrismGT cards (e.g.: Netgear WG511v1, SMC 2802W)

There are 2 revisions of this model

random david # lspci -vv | grep SMC
    Subsystem: Standard Microsystems Corp [SMC] SMC2802W Wireless PCI Adapter
random david # lspci -vv | grep Wireless
    Subsystem: Standard Microsystems Corp [SMC] SMC2802W Wireless PCI Adapter
random david # dmesg | grep phy0

phy0: p54 detected a LM86 firmware
phy0: FW rev 2.13.12.0 - Softmac protocol 5.9
phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
phy0: hwaddr 00:04:e2:63:c2:67, MAC:isl3890 RF:Duette3
phy0: Selected rate control algorithm 'minstrel'
p54pci 0000:00:0a.0: is registered as 'phy0'

Part numbers:
99-012084-164
99-012084-285

You can verify this with choosing the 2802W from the drop down boxes
@http://www.smc.com/index.cfm?event=downloads.searchCriteria&localeCode=EN_USA&knowsPartNumber=false&productCategory=5&modelNumber=536&downloadType=0&os=0

Mine is the -164 version. Anything else needed to confirm working properly?

random david # uname -a
Linux random 2.6.34.1 #5 SMP Thu Jul 22 22:06:56 EDT 2010 x86_64 AMD
Athlon(tm) 64 Processor 3200+ AuthenticAMD GNU/Linux

Posting vie device ;-)

kind regards
DJ Cozatt
