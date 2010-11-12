Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41737 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752408Ab0KLPL2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 10:11:28 -0500
Message-ID: <4CDD5915.5080604@openwrt.org>
Date: Fri, 12 Nov 2010 16:11:17 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	lrodriguez@atheros.com
Subject: Re: [PATCH v2 0/9] ath5k: Add AHB support
References: <1289573296-3129-1-git-send-email-Wojciech.Dubowik@neratec.com>
In-Reply-To: <1289573296-3129-1-git-send-email-Wojciech.Dubowik@neratec.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-12 3:48 PM, Wojciech Dubowik wrote:
> This series of patches implements AHB bus support for ath5k driver.
> 
> General comments for AHB bus support in ath5k:
> 	* most of the original patches came from Felix Fetikau. I have used
> 		them as a reference and ported to current git tree
> 	* tried with access point functionality with WPA2 and without encryption
> 	* tested on AR5312 for AHB and AR5414 and AR5212 for PCI
> 	* compat wireless from openwrt was used for testing these patches
> 	* last two patches have to be applied together because otherwise
> 		hardware will crash on reset if only number 9 is committed.
> 		I have kept them separated for better visibility. 
> 		There are two false positive checkpatch warnings from them.
> 
> Wojciech Dubowik (9):
>   ath5k: Use Generic DMA for later support of AHB bus.
>   ath5k: Introduce ath5k_init_softc function as in ath9k
>   ath5k: Move PCI bus functions to separate file.
>   ath5k: Use generic eeprom read from common ath_bus_opts struct.
>   ath5k: Check if pci pdev struct is initialized in common functions.
>   ath5k: Add a function to read chipset's MAC revision
>   ath5k: Add initial registers values for radio RF2317 chip.
>   ath5k: Add AHB bus support.
>   ath5k: Fix reset and interrupts for AHB type of devices.
One thing I forgot: it would be nice if you could add my Signed-off-by
for patches that I co-authored, maybe also a From: for patches that were
almost entirely written by me.

Thanks,

- Felix
