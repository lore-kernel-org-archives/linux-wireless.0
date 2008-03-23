Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc3-s17.bay0.hotmail.com ([65.54.246.217]:43002 "EHLO
	bay0-omc3-s17.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbYCWQnD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Mar 2008 12:43:03 -0400
Message-ID: <BAY101-W143CDEC5E4B7194B35601EC8030@phx.gbl> (sfid-20080323_164318_707281_1C58F84E)
From: Adam Turk <bofh1234@hotmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: 
Date: Sun, 23 Mar 2008 12:43:02 -0400
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello, 

I just compiled 2.6.25-rc6 and got a bunch of warnings when I did make modules_install. I am using a PC not a laptop so I don't bother compiling PCMCIA support.

WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/usb/rndis_host.ko needs unknown symbol usbnet_skb_return
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/usb/rndis_host.ko needs unknown symbol usbnet_suspend
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/usb/rndis_host.ko needs unknown symbol usbnet_generic_cdc_bind
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/usb/rndis_host.ko needs unknown symbol usbnet_disconnect
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/usb/rndis_host.ko needs unknown symbol usbnet_cdc_unbind
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/usb/rndis_host.ko needs unknown symbol usbnet_probe
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/usb/rndis_host.ko needs unknown symbol usbnet_resume
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/wireless/b43/b43.ko needs unknown symbol pcmcia_disable_device
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/wireless/b43/b43.ko needs unknown symbol pcmcia_unregister_driver
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/wireless/b43/b43.ko needs unknown symbol pcmcia_map_mem_page
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/wireless/b43/b43.ko needs unknown symbol pccard_get_first_tuple
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/wireless/b43/b43.ko needs unknown symbol pcmcia_request_window
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/wireless/b43/b43.ko needs unknown symbol pcmcia_request_configuration
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/wireless/b43/b43.ko needs unknown symbol pccard_get_tuple_data
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/wireless/b43/b43.ko needs unknown symbol pcmcia_register_driver
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/wireless/b43/b43.ko needs unknown symbol pccard_parse_tuple
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/wireless/b43/b43.ko needs unknown symbol pcmcia_request_irq
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/wireless/libertas/libertas.ko needs unknown symbol debugfs_remove
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/wireless/libertas/libertas.ko needs unknown symbol debugfs_create_file
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/wireless/libertas/libertas.ko needs unknown symbol debugfs_create_dir
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/wireless/libertas/libertas_cs.ko needs unknown symbol pcmcia_disable_device
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/wireless/libertas/libertas_cs.ko needs unknown symbol pcmcia_unregister_driver
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/wireless/libertas/libertas_cs.ko needs unknown symbol pccard_get_first_tuple
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/wireless/libertas/libertas_cs.ko needs unknown symbol pcmcia_request_io
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/wireless/libertas/libertas_cs.ko needs unknown symbol pcmcia_request_configuration
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/wireless/libertas/libertas_cs.ko needs unknown symbol pccard_get_tuple_data
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/wireless/libertas/libertas_cs.ko needs unknown symbol pcmcia_register_driver
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/wireless/libertas/libertas_cs.ko needs unknown symbol pccard_parse_tuple
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/net/wireless/libertas/libertas_cs.ko needs unknown symbol pcmcia_request_irq
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/ssb/ssb.ko needs unknown symbol pccard_get_first_tuple
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/ssb/ssb.ko needs unknown symbol pcmcia_access_configuration_register
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/ssb/ssb.ko needs unknown symbol pccard_get_tuple_data
WARNING: /lib/modules/2.6.25-rc6/updates/drivers/ssb/ssb.ko needs unknown symbol pccard_get_next_tuple
WARNING: /lib/modules/2.6.25-rc6/updates/net/wireless/cfg80211.ko needs unknown symbol debugfs_remove
WARNING: /lib/modules/2.6.25-rc6/updates/net/wireless/cfg80211.ko needs unknown symbol debugfs_rename
WARNING: /lib/modules/2.6.25-rc6/updates/net/wireless/cfg80211.ko needs unknown symbol debugfs_create_dir

Just an FYI,
_________________________________________________________________
Test your Star IQ
http://club.live.com/red_carpet_reveal.aspx?icid=redcarpet_HMTAGMAR