Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:52532 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754842Ab1JQHcG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Oct 2011 03:32:06 -0400
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: David Rientjes <rientjes@google.com>,
	David Rientjes <rientjes@google.com>
Subject: Re: 3.1.0-rc9+ : wlan stops working w/o any error messages
Date: Mon, 17 Oct 2011 09:31:58 +0200
Cc: werner <w.landgraf@ru.ru>, "Wey-Yi Guy" <wey-yi.w.guy@intel.com>,
	ilw@linux.intel.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <201110152119.58509.toralf.foerster@gmx.de> <alpine.DEB.2.00.1110151416360.15894@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1110151416360.15894@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201110170931.59534.toralf.foerster@gmx.de> (sfid-20111017_093228_081291_F55BBAF3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


David Rientjes wrote at 23:21:59
> What's the last kernel prior to 3.1-rc9 that worked for you?
2.6.39.4 (in general that kernel version rocks, reliable, stable, no problems 
AFAICS, 3.0.x have problems in the DVB-T area, 3.1 added wlan issues)

> What does "iwconfig" show?
wlan0     IEEE 802.11abgn  ESSID:"IBM"  
          Mode:Managed  Frequency:2.462 GHz  Access Point: 00:21:55:AC:8B:80   
          Bit Rate=54 Mb/s   Tx-Power=15 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=49/70  Signal level=-61 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

> What does "dmesg | grep iwlagn" show?
n22 ~ # dmesg | grep iwlagn
iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:03:00.0: setting latency timer to 64
iwlagn 0000:03:00.0: pci_resource_len = 0x00002000
iwlagn 0000:03:00.0: pci_resource_base = f81f8000
iwlagn 0000:03:00.0: HW Revision ID = 0x0
iwlagn 0000:03:00.0: irq 48 for MSI/MSI-X
iwlagn 0000:03:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
iwlagn 0000:03:00.0: L1 Disabled; Enabling L0S
iwlagn 0000:03:00.0: device EEPROM VER=0x11e, CALIB=0x4
iwlagn 0000:03:00.0: Device SKU: 0Xf0
iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:03:00.0: loaded firmware version 8.83.5.1 build 33692
iwlagn 0000:03:00.0: L1 Disabled; Enabling L0S
iwlagn 0000:03:00.0: Radio type=0x1-0x2-0x0
iwlagn 0000:03:00.0: L1 Disabled; Enabling L0S
iwlagn 0000:03:00.0: Radio type=0x1-0x2-0x0


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
