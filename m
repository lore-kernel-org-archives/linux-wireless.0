Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.telexis.nl ([87.213.113.58]:22492 "EHLO mail.telexis.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab3JVIbq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Oct 2013 04:31:46 -0400
From: Bastiaan de Groot <bastiaan.de.groot@telexis.nl>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: =?iso-8859-1?Q?RE:_Intel=AE_Centrino=AE_Advanced-N_6235_-_iwlwifi-6000g2b?=
 =?iso-8859-1?Q?-6.ucode_not_reconnecting_issue?=
Date: Tue, 22 Oct 2013 08:31:42 +0000
Message-ID: <2027E41A9379094181F2CA441442CE1D279B7AC3@RSWKA02MXS.telexis.nl> (sfid-20131022_103151_558448_AB212DFE)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear community,

I have a "Intel® Centrino® Advanced-N 6235" wificard.
Running Debian 7.0 "wheezy"

Firmware: Iwlwifi-6000g2b-6.ucode

Using:
Kernel 3.2.0-4-686-pae

It connects but when wpa_supplicant is trying to re-connect I get:

[83667.904059] iwlwifi 0000:05:00.0: iwl_hcmd_queue_reclaim: Read index for DMA queue txq id (9), index 157 is out of range [0-256] 0 0.
[83667.904276] iwlwifi 0000:05:00.0: HCMD_ACTIVE already clear for command POWER_TABLE_CMD
[83667.904289] iwlwifi 0000:05:00.0: iwl_hcmd_queue_reclaim: Read index for DMA queue txq id (9), index 156 is out of range [0-256] 0 0.
[83667.904493] iwlwifi 0000:05:00.0: HCMD_ACTIVE already clear for command REPLY_RXON_ASSOC
[83667.904516] iwlwifi 0000:05:00.0: iwl_hcmd_queue_reclaim: Read index for DMA queue txq id (9), index 143 is out of range [0-256] 0 0.
[83667.904722] iwlwifi 0000:05:00.0: HCMD_ACTIVE already clear for command REPLY_RXON
[83667.904732] iwlwifi 0000:05:00.0: iwl_hcmd_queue_reclaim: Read index for DMA queue txq id (9), index 139 is out of range [0-256] 0 0.
[83667.904935] iwlwifi 0000:05:00.0: HCMD_ACTIVE already clear for command REPLY_TX_LINK_QUALITY_CMD
[83667.904998] iwlwifi 0000:05:00.0: iwl_hcmd_queue_reclaim: Read index for DMA queue txq id (9), index 172 is out of range [0-256] 0 0.
[83667.905200] iwlwifi 0000:05:00.0: HCMD_ACTIVE already clear for command REPLY_LEDS_CMD
[83667.905212] iwlwifi 0000:05:00.0: iwl_hcmd_queue_reclaim: Read index for DMA queue txq id (9), index 165 is out of range [0-256] 0 0.
[83667.908013] iwlwifi 0000:05:00.0: HCMD_ACTIVE already clear for command POWER_TABLE_CMD
[83667.920999] iwlwifi 0000:05:00.0: iwl_hcmd_queue_reclaim: Read index for DMA queue txq id (9), index 162 is out of range [0-256] 0 0.
[83667.924978] iwlwifi 0000:05:00.0: HCMD_ACTIVE already clear for command REPLY_TX_LINK_QUALITY_CMD
[83667.937183] iwlwifi 0000:05:00.0: iwl_hcmd_queue_reclaim: Read index for DMA queue txq id (9), index 158 is out of range [0-256] 0 0.
[83667.941157] iwlwifi 0000:05:00.0: HCMD_ACTIVE already clear for command REPLY_RXON
[83667.953377] iwlwifi 0000:05:00.0: iwl_hcmd_queue_reclaim: Read index for DMA queue txq id (9), index 171 is out of range [0-256] 0 0.
[83667.957319] iwlwifi 0000:05:00.0: HCMD_ACTIVE already clear for command REPLY_TX_LINK_QUALITY_CMD
[83668.896034] iwlwifi 0000:05:00.0: Failed to start RT ucode: -110
[83668.904290] iwlwifi 0000:05:00.0: Unable to initialize device.

The issue looks similar like this one:

http://ubuntuforums.org/showthread.php?t=2178006&s=9157c353cd4a322c2a3b2a6dc693d243

Can you please give me advice on how to resolve this issue?

Thanks in advance!
Bastiaan















Met vriendelijke groet,

Bastiaan de Groot




Laan van Zuid Hoorn 55
2289 DC Rijswijk
The Netherlands

Telephone         +31 (0)70 319 39 38
Operations        +31 (0)70 319 23 47
Fax                   +31 (0)70 319 17 59
Mobile               +31 (0)6 211 92 911
E-mail               bastiaan.de.groot@telexis.nl
Website             www.telexis.nl

