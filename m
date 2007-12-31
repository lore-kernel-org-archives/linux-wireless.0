Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:42890 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbXLaFfG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Dec 2007 00:35:06 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1J9DIk-0007Vf-OR
	for linux-wireless@vger.kernel.org; Mon, 31 Dec 2007 05:35:02 +0000
Received: from pD9EEF28C.dip.t-dialin.net ([217.238.242.140])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 31 Dec 2007 05:35:02 +0000
Received: from rafi by pD9EEF28C.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 31 Dec 2007 05:35:02 +0000
To: linux-wireless@vger.kernel.org
From: Rafael Remy <rafi@theater-kgr.com>
Subject: what kernel modules are nessecary for compact wireless
Date: Mon, 31 Dec 2007 05:28:34 +0000 (UTC)
Message-ID: <loom.20071231T052528-182@post.gmane.org> (sfid-20071231_053524_179501_471A687F)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello

i use a small holded 2.6.23-12 kernel with debian.

what modules i have to put into the kernel for wireless working?

i installed the kernel modules, the fwcutter and the firmware.

PrinzIP:/lib/modules/2.6.23.12/updates/drivers/net/wireless/b43# modprobe b43
WARNING: Error inserting ssb
(/lib/modules/2.6.23.12/updates/drivers/ssb/ssb.ko): Unknown symbol in module,
or unknown parameter (see dmesg)
FATAL: Error inserting b43
(/lib/modules/2.6.23.12/updates/drivers/net/wireless/b43/b43.ko): Unknown symbol
in module, or unknown parameter (see dmesg)

dmesg:

ssb: Unknown symbol pcmcia_access_configuration_register
b43: Unknown symbol ssb_device_is_enabled
b43: Unknown symbol pcmcia_disable_device
b43: Unknown symbol ssb_pcicore_dev_irqvecs_enable
b43: Unknown symbol ssb_bus_may_powerdown
b43: Unknown symbol pcmcia_unregister_driver
b43: Unknown symbol pcmcia_map_mem_page
b43: Unknown symbol ssb_bus_unregister
b43: Unknown symbol ssb_set_devtypedata
b43: Unknown symbol ssb_device_disable
b43: Unknown symbol pccard_get_first_tuple
b43: Unknown symbol ssb_dma_set_mask
b43: Unknown symbol pcmcia_request_window
b43: Unknown symbol ssb_device_enable
b43: Unknown symbol ssb_driver_unregister
b43: Unknown symbol __ssb_driver_register
b43: Unknown symbol pcmcia_request_configuration
b43: Unknown symbol ssb_bus_pcmciabus_register
b43: Unknown symbol ssb_bus_powerup
b43: Unknown symbol pccard_get_tuple_data
b43: Unknown symbol pcmcia_register_driver
b43: Unknown symbol pccard_parse_tuple
b43: Unknown symbol ssb_dma_translation
b43: Unknown symbol pcmcia_request_irq
ssb: Unknown symbol pcmcia_access_configuration_register
b43: Unknown symbol ssb_device_is_enabled
b43: Unknown symbol pcmcia_disable_device
b43: Unknown symbol ssb_pcicore_dev_irqvecs_enable
b43: Unknown symbol ssb_bus_may_powerdown
b43: Unknown symbol pcmcia_unregister_driver
b43: Unknown symbol pcmcia_map_mem_page
b43: Unknown symbol ssb_bus_unregister
b43: Unknown symbol ssb_set_devtypedata
b43: Unknown symbol ssb_device_disable
b43: Unknown symbol pccard_get_first_tuple
b43: Unknown symbol ssb_dma_set_mask
b43: Unknown symbol pcmcia_request_window
b43: Unknown symbol ssb_device_enable
b43: Unknown symbol ssb_driver_unregister
b43: Unknown symbol __ssb_driver_register
b43: Unknown symbol pcmcia_request_configuration
b43: Unknown symbol ssb_bus_pcmciabus_register
b43: Unknown symbol ssb_bus_powerup
b43: Unknown symbol pccard_get_tuple_data
b43: Unknown symbol pcmcia_register_driver
b43: Unknown symbol pccard_parse_tuple
b43: Unknown symbol ssb_dma_translation
b43: Unknown symbol pcmcia_request_irq


