Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755072AbXEKBOS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 21:14:18 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l4B1EGXi012256
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 10 May 2007 18:14:18 -0700
Received: from akpm.corp.google.com (shell0.pdx.osdl.net [10.9.0.31])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with SMTP id l4B1EGTm003025
	for <linux-wireless@vger.kernel.org>; Thu, 10 May 2007 18:14:16 -0700
Date: Thu, 10 May 2007 18:14:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-wireless@vger.kernel.org
Subject: libertas driver
Message-Id: <20070510181416.8637b466.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


x86_64 build is a bit ugly.

drivers/net/wireless/libertas/tx.c: In function 'SendSinglePacket':
drivers/net/wireless/libertas/tx.c:81: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
drivers/net/wireless/libertas/rx.c: In function 'libertas_process_rxed_packet':
drivers/net/wireless/libertas/rx.c:213: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
drivers/net/wireless/libertas/rx.c:213: warning: format '%d' expects type 'int', but argument 4 has type 'long unsigned int'
drivers/net/wireless/libertas/rx.c: In function 'process_rxed_802_11_packet':
drivers/net/wireless/libertas/rx.c:367: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
drivers/net/wireless/libertas/rx.c:367: warning: format '%d' expects type 'int', but argument 4 has type 'long unsigned int'
drivers/net/wireless/libertas/cmd.c: In function 'libertas_queue_cmd':
drivers/net/wireless/libertas/cmd.c:950: warning: cast from pointer to integer of different size
drivers/net/wireless/libertas/cmd.c: In function 'DownloadcommandToStation':
drivers/net/wireless/libertas/cmd.c:979: warning: cast from pointer to integer of different size
drivers/net/wireless/libertas/cmd.c:979: warning: cast from pointer to integer of different size
drivers/net/wireless/libertas/cmd.c: In function 'libertas_prepare_and_send_command':
drivers/net/wireless/libertas/cmd.c:1177: warning: cast from pointer to integer of different size
drivers/net/wireless/libertas/join.c: In function 'libertas_cmd_80211_ad_hoc_join':
drivers/net/wireless/libertas/join.c:789: warning: cast from pointer to integer of different size
drivers/net/wireless/libertas/scan.c: In function 'InterpretBSSDescriptionWithIE':
drivers/net/wireless/libertas/scan.c:1118: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
drivers/net/wireless/libertas/scan.c: In function 'libertas_get_scan':
drivers/net/wireless/libertas/scan.c:1586: warning: format '%d' expects type 'int', but argument 5 has type 'long unsigned int'
drivers/net/wireless/libertas/debugfs.c: In function 'libertas_parse_ssid':
drivers/net/wireless/libertas/debugfs.c:279: warning: comparison of distinct pointer types lacks a cast
drivers/net/wireless/libertas/debugfs.c: In function 'wlan_debugfs_read':
drivers/net/wireless/libertas/debugfs.c:1823: warning: cast to pointer from integer of different size
drivers/net/wireless/libertas/debugfs.c:1825: warning: cast to pointer from integer of different size
drivers/net/wireless/libertas/debugfs.c:1827: warning: cast to pointer from integer of different size
drivers/net/wireless/libertas/debugfs.c: In function 'wlan_debugfs_write':
drivers/net/wireless/libertas/debugfs.c:1884: warning: cast to pointer from integer of different size
drivers/net/wireless/libertas/debugfs.c:1886: warning: cast to pointer from integer of different size
drivers/net/wireless/libertas/debugfs.c:1888: warning: cast to pointer from integer of different size
drivers/net/wireless/libertas/debugfs.c: At top level:
drivers/net/wireless/libertas/debugfs.c:1900: warning: initialization from incompatible pointer type
drivers/net/wireless/libertas/debugfs.c: In function 'libertas_debug_init':
drivers/net/wireless/libertas/debugfs.c:1919: warning: cast from pointer to integer of different size
drivers/net/wireless/libertas/ioctl.c: In function 'wlan_set_linkmode_ioctl':
drivers/net/wireless/libertas/ioctl.c:696: warning: cast from pointer to integer of different size
drivers/net/wireless/libertas/ioctl.c: In function 'wlan_set_radiomode_ioctl':
drivers/net/wireless/libertas/ioctl.c:728: warning: cast from pointer to integer of different size
drivers/net/wireless/libertas/ioctl.c: In function 'wlan_set_debugmode_ioctl':
drivers/net/wireless/libertas/ioctl.c:757: warning: cast from pointer to integer of different size
drivers/net/wireless/libertas/ioctl.c: In function 'wlan_fwt_cleanup_ioctl':
drivers/net/wireless/libertas/ioctl.c:1779: warning: cast to pointer from integer of different size
drivers/net/wireless/libertas/ioctl.c: In function 'wlan_fwt_time_ioctl':
drivers/net/wireless/libertas/ioctl.c:1810: warning: cast to pointer from integer of different size
drivers/net/wireless/libertas/ioctl.c: In function 'wlan_mesh_get_ttl_ioctl':
drivers/net/wireless/libertas/ioctl.c:1839: warning: cast to pointer from integer of different size
drivers/net/wireless/libertas/ioctl.c: In function 'libertas_do_ioctl':
drivers/net/wireless/libertas/ioctl.c:1947: warning: cast from pointer to integer of different size
drivers/net/wireless/libertas/ioctl.c:2025: warning: cast from pointer to integer of different size
drivers/net/wireless/libertas/ioctl.c:2171: warning: cast from pointer to integer of different size
drivers/net/wireless/libertas/ioctl.c:2188: warning: cast to pointer from integer of different size
drivers/net/wireless/libertas/ioctl.c:2192: warning: cast to pointer from integer of different size
drivers/net/wireless/libertas/ioctl.c:2196: warning: cast to pointer from integer of different size
drivers/net/wireless/libertas/if_usb.c: In function '__if_usb_submit_rx_urb':
drivers/net/wireless/libertas/if_usb.c:393: warning: passing argument 4 of 'usb_fill_bulk_urb' makes pointer from integer without a cast


And all this annotation

/**
 *  @brief Convert mw value to dbm value
 *
 *  @param mw      the value of mw
 *  @return        the value of dbm
 */

will be converted to kerneldoc form, I trust?
