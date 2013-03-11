Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from winsoft.com.pl ([109.234.111.213]:44890 "EHLO winsoft.com.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab3CKUGW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 16:06:22 -0400
Message-ID: <513E34FD.8090606@winsoft.pl> (sfid-20130311_210626_843302_8E11A0E2)
Date: Mon, 11 Mar 2013 20:48:13 +0100
From: Krzysztof Kolasa <kkolasa@winsoft.pl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: sgruszka@redhat.com, linville@tuxdriver.com
Subject: iwlegacy iwl3945 unable to connect to any hotspots on 3.9.0-rc1/rc2
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hotspots are visible and are working OK but wifi card can't connect.

dmesg | grep iwl3945 ( kernel 3.9.0-rc1/rc2 ):

[   13.930138] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network 
Connection driver for Linux, in-tree:s
[   13.930145] iwl3945: Copyright(c) 2003-2011 Intel Corporation
[   13.971267] iwl3945 0000:02:00.0: Tunable channels: 13 802.11bg, 23 
802.11a channels
[   13.971275] iwl3945 0000:02:00.0: Detected Intel Wireless WiFi Link 
3945ABG
[   13.971441] iwl3945 0000:02:00.0: irq 43 for MSI/MSI-X
[   15.518646] iwl3945 0000:02:00.0: loaded firmware version 15.32.2.9
[   20.885241] iwl3945 0000:02:00.0: Microcode SW error detected. 
Restarting 0x82000008.
[   20.885251] iwl3945 0000:02:00.0: Loaded firmware version: 15.32.2.9
[   20.885286] iwl3945 0000:02:00.0: Start IWL Error Log Dump:
[   20.885290] iwl3945 0000:02:00.0: Status: 0x000202E4, count: 1
[   20.885294] iwl3945 0000:02:00.0: Desc       Time       asrtPC blink2 
ilink1  nmiPC   Line
[   20.885526] iwl3945 0000:02:00.0: SYSASSERT     (0x5) 0000201042 
0x008B6 0x00274 0x00320 0x04CA6 116
[   20.885545] iwl3945 0000:02:00.0: Error Reply type 0x00000005 cmd 
C_TX (0x1C) seq 0x0016 ser 0x00740000
[   20.885552] iwl3945 0000:02:00.0: Command C_TX_PWR_TBL failed: FW Error
[   20.885558] iwl3945 0000:02:00.0: Error setting Tx power (-5).
[   20.887300] iwl3945 0000:02:00.0: Can't stop Rx DMA.
[   21.173032] iwl3945 0000:02:00.0: Microcode SW error detected. 
Restarting 0x82000008.
[   21.173038] iwl3945 0000:02:00.0: Loaded firmware version: 15.32.2.9
[   21.173072] iwl3945 0000:02:00.0: Start IWL Error Log Dump:
[   21.173076] iwl3945 0000:02:00.0: Status: 0x000202E4, count: 1
[   21.173080] iwl3945 0000:02:00.0: Desc       Time       asrtPC blink2 
ilink1  nmiPC   Line
[   21.173309] iwl3945 0000:02:00.0: SYSASSERT     (0x5) 0000208934 
0x008B6 0x0035E 0x00320 0x00000 267
[   21.173320] iwl3945 0000:02:00.0: Error Reply type 0x00000001 cmd 
N_ALIVE (0x01) seq 0x0402 ser 0x00010000
[   21.175058] iwl3945 0000:02:00.0: Can't stop Rx DMA.


dmesg | grep iwl3945 ( kernel 3.8.1 connected correctly):

[    2.744464] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network 
Connection driver for Linux, in-tree:s
[    2.744470] iwl3945: Copyright(c) 2003-2011 Intel Corporation
[    2.794481] iwl3945 0000:02:00.0: Tunable channels: 13 802.11bg, 23 
802.11a channels
[    2.794490] iwl3945 0000:02:00.0: Detected Intel Wireless WiFi Link 
3945ABG
[    2.794653] iwl3945 0000:02:00.0: irq 43 for MSI/MSI-X
[    4.111179] iwl3945 0000:02:00.0: loaded firmware version 15.32.2.9



