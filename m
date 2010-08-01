Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36002 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab0HAQfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Aug 2010 12:35:08 -0400
Received: by pzk26 with SMTP id 26so1093521pzk.19
        for <linux-wireless@vger.kernel.org>; Sun, 01 Aug 2010 09:35:07 -0700 (PDT)
Message-ID: <4C55A261.10902@lwfinger.net>
Date: Sun, 01 Aug 2010 11:35:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: David Cozatt <olbrannon@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: SMC 2802W -status unsupported
References: <AANLkTi=XOECFnOgB5mmaDejVhH2aAEedYqz9tyeSz7Ge@mail.gmail.com>
In-Reply-To: <AANLkTi=XOECFnOgB5mmaDejVhH2aAEedYqz9tyeSz7Ge@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/01/2010 11:17 AM, David Cozatt wrote:
> Accessing http://wireless.kernel.org/en/users/Drivers/p54 shows in unsupported
> 
>     * early PrismGT cards (e.g.: Netgear WG511v1, SMC 2802W)
> 
> There are 2 revisions of this model
> 
> random david # lspci -vv | grep SMC
>     Subsystem: Standard Microsystems Corp [SMC] SMC2802W Wireless PCI Adapter
> random david # lspci -vv | grep Wireless
>     Subsystem: Standard Microsystems Corp [SMC] SMC2802W Wireless PCI Adapter
> random david # dmesg | grep phy0
> 
> phy0: p54 detected a LM86 firmware
> phy0: FW rev 2.13.12.0 - Softmac protocol 5.9
> phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
> phy0: hwaddr 00:04:e2:63:c2:67, MAC:isl3890 RF:Duette3
> phy0: Selected rate control algorithm 'minstrel'
> p54pci 0000:00:0a.0: is registered as 'phy0'
> 
> Part numbers:
> 99-012084-164
> 99-012084-285
> 
> You can verify this with choosing the 2802W from the drop down boxes
> @http://www.smc.com/index.cfm?event=downloads.searchCriteria&localeCode=EN_USA&knowsPartNumber=false&productCategory=5&modelNumber=536&downloadType=0&os=0
> 
> Mine is the -164 version. Anything else needed to confirm working properly?

If I understand correctly, the device is working - only the wiki is wrong.

For my info, what does 'lspci -nnk | grep 2802' show?

Larry
