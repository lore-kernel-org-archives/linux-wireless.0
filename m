Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mamona.cetuc.puc-rio.br ([139.82.74.4]:59143 "EHLO
	mamona.cetuc.puc-rio.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045AbYGBMZD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 08:25:03 -0400
Message-ID: <34838.201.36.206.138.1215000227.squirrel@mamao.cetuc.puc-rio.br> (sfid-20080702_142510_482691_5DF13CCB)
Date: Wed, 2 Jul 2008 09:03:47 -0300 (BRT)
Subject: b43 ssb inplicit declaration
From: "Felipe Maya" <fmay@cetuc.puc-rio.br>
To: linux-wireless@vger.kernel.org
Cc: marcelo.toledo@vexcorp.com
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Where can I get an updated SSB source?

Thanks.
Felipe Maya

CC [M] 
/opt/openwrt-ssb-ehci-ohci/build_dir/linux-brcm47xx/compat-wireless-2008-07-01/drivers/net/wireless/b43/dma.o
/opt/openwrt-ssb-ehci-ohci/build_dir/linux-brcm47xx/compat-wireless-2008-07-01/drivers/net/wireless/b43/dma.c:
In function 'map_descbuffer':
/opt/openwrt-ssb-ehci-ohci/build_dir/linux-brcm47xx/compat-wireless-2008-07-01/drivers/net/wireless/b43/dma.c:331:
error: implicit declaration of function 'ssb_dma_map_single'
/opt/openwrt-ssb-ehci-ohci/build_dir/linux-brcm47xx/compat-wireless-2008-07-01/drivers/net/wireless/b43/dma.c:
In function 'unmap_descbuffer':
/opt/openwrt-ssb-ehci-ohci/build_dir/linux-brcm47xx/compat-wireless-2008-07-01/drivers/net/wireless/b43/dma.c:346:
error: implicit declaration of function 'ssb_dma_unmap_single'
/opt/openwrt-ssb-ehci-ohci/build_dir/linux-brcm47xx/compat-wireless-2008-07-01/drivers/net/wireless/b43/dma.c:
In function 'sync_descbuffer_for_cpu':
/opt/openwrt-ssb-ehci-ohci/build_dir/linux-brcm47xx/compat-wireless-2008-07-01/drivers/net/wireless/b43/dma.c:359:
error: implicit declaration of function 'ssb_dma_sync_single_for_cpu'
/opt/openwrt-ssb-ehci-ohci/build_dir/linux-brcm47xx/compat-wireless-2008-07-01/drivers/net/wireless/b43/dma.c:
In function 'sync_descbuffer_for_device':
/opt/openwrt-ssb-ehci-ohci/build_dir/linux-brcm47xx/compat-wireless-2008-07-01/drivers/net/wireless/b43/dma.c:368:
error: implicit declaration of function 'ssb_dma_sync_single_for_device'
/opt/openwrt-ssb-ehci-ohci/build_dir/linux-brcm47xx/compat-wireless-2008-07-01/drivers/net/wireless/b43/dma.c:
In function 'alloc_ringmemory':
/opt/openwrt-ssb-ehci-ohci/build_dir/linux-brcm47xx/compat-wireless-2008-07-01/drivers/net/wireless/b43/dma.c:399:
error: implicit declaration of function 'ssb_dma_alloc_consistent'
/opt/openwrt-ssb-ehci-ohci/build_dir/linux-brcm47xx/compat-wireless-2008-07-01/drivers/net/wireless/b43/dma.c:401:
warning: assignment makes pointer from integer without a cast
/opt/openwrt-ssb-ehci-ohci/build_dir/linux-brcm47xx/compat-wireless-2008-07-01/drivers/net/wireless/b43/dma.c:
In function 'free_ringmemory':
/opt/openwrt-ssb-ehci-ohci/build_dir/linux-brcm47xx/compat-wireless-2008-07-01/drivers/net/wireless/b43/dma.c:418:
error: implicit declaration of function 'ssb_dma_free_consistent'
/opt/openwrt-ssb-ehci-ohci/build_dir/linux-brcm47xx/compat-wireless-2008-07-01/drivers/net/wireless/b43/dma.c:
In function 'b43_dma_mapping_error':
/opt/openwrt-ssb-ehci-ohci/build_dir/linux-brcm47xx/compat-wireless-2008-07-01/drivers/net/wireless/b43/dma.c:526:
error: implicit declaration of function 'ssb_dma_mapping_error'
make[8]: ***
[/opt/openwrt-ssb-ehci-ohci/build_dir/linux-brcm47xx/compat-wireless-2008-07-01/drivers/net/wireless/b43/dma.o]
Error 1
make[7]: ***
[/opt/openwrt-ssb-ehci-ohci/build_dir/linux-brcm47xx/compat-wireless-2008-07-01/drivers/net/wireless/b43]
Error 2
make[6]: ***
[/opt/openwrt-ssb-ehci-ohci/build_dir/linux-brcm47xx/compat-wireless-2008-07-01/drivers/net/wireless]
Error 2
make[5]: ***
[_module_/opt/openwrt-ssb-ehci-ohci/build_dir/linux-brcm47xx/compat-wireless-2008-07-01]
Error 2
make[5]: Leaving directory
`/opt/openwrt-ssb-ehci-ohci/build_dir/linux-brcm47xx/linux-2.6.25.9'
make[4]: *** [modules] Error 2
make[4]: Leaving directory
`/opt/openwrt-ssb-ehci-ohci/build_dir/linux-brcm47xx/compat-wireless-2008-07-01'
make[3]: ***
[/opt/openwrt-ssb-ehci-ohci/build_dir/linux-brcm47xx/compat-wireless-2008-07-01/.built]
Error 2

