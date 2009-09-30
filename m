Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33071 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752843AbZI3LEc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 07:04:32 -0400
From: Reiner Schmidt <schmidtreiner@gmx.net>
To: linux-wireless@vger.kernel.org
Subject: B43 Module on Compaq HP615 Laptop
Date: Wed, 30 Sep 2009 13:04:33 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200909301304.33903.schmidtreiner@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, 
I am trying to install the newest compat-wireless package (from 30.09.2009) 
onto this notebook. It has a Broadcom 4312 compatible  WLAN device on it .
Its id is:14e4:4315.
I use s debian sidux distribution with an 2.6.29-4 liquorix-kernel.
Unfortunately I can currently use newer kernels on this notebook because it 
wouldn't boot up. Tried several 2.6.30 and -31 kernels up too 2.6.31-1.

Compiling the package works so far but when loading the module b43 manually or 
via /etc/modules it complains heavily about ssb-related issues.

 
> b43: disagrees about version of symbol ssb_device_is_enabled
> b43: Unknown symbol ssb_device_is_enabled
> b43: Unknown symbol ssb_pmu_set_ldo_paref
> b43: disagrees about version of symbol ssb_pcicore_dev_irqvecs_enable
> b43: Unknown symbol ssb_pcicore_dev_irqvecs_enable
> b43: disagrees about version of symbol ssb_bus_may_powerdown
> b43: Unknown symbol ssb_bus_may_powerdown
> b43: disagrees about version of symbol ssb_dma_free_consistent
> b43: Unknown symbol ssb_dma_free_consistent
> b43: disagrees about version of symbol ssb_bus_suspend
> b43: Unknown symbol ssb_bus_suspend
> b43: disagrees about version of symbol ssb_bus_unregister
> b43: Unknown symbol ssb_bus_unregister
> b43: disagrees about version of symbol ssb_bus_resume
> b43: Unknown symbol ssb_bus_resume
> b43: disagrees about version of symbol ssb_set_devtypedata
> b43: Unknown symbol ssb_set_devtypedata
> b43: disagrees about version of symbol ssb_device_disable
> b43: Unknown symbol ssb_device_disable
> b43: Unknown symbol ssb_pmu_set_ldo_voltage
> b43: disagrees about version of symbol ssb_dma_alloc_consistent
> b43: Unknown symbol ssb_dma_alloc_consistent
> b43: disagrees about version of symbol ssb_dma_set_mask
> b43: Unknown symbol ssb_dma_set_mask
> b43: disagrees about version of symbol ssb_device_enable
> b43: Unknown symbol ssb_device_enable
> b43: disagrees about version of symbol ssb_driver_unregister
> b43: Unknown symbol ssb_driver_unregister
> b43: disagrees about version of symbol __ssb_driver_register
> b43: Unknown symbol __ssb_driver_register
> b43: disagrees about version of symbol ssb_bus_pcmciabus_register
> b43: Unknown symbol ssb_bus_pcmciabus_register
> b43: disagrees about version of symbol ssb_bus_powerup
> b43: Unknown symbol ssb_bus_powerup
> b43: disagrees about version of symbol ssb_dma_translation
> b43: Unknown symbol ssb_dma_translation

Is this a real bug or do Ihave to submit additional prameter for the module 
when I load it? 
If so, where can I find those otions ?

Kind regards

Reiner Schmidt
