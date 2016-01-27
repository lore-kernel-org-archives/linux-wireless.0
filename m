Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60831 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932957AbcA0Ozi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 09:55:38 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1aORUt-0001vf-B3
	for linux-wireless@vger.kernel.org; Wed, 27 Jan 2016 15:55:03 +0100
Received: from 151.67.96.135 ([151.67.96.135])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jan 2016 15:55:03 +0100
Received: from natserver2 by 151.67.96.135 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jan 2016 15:55:03 +0100
To: linux-wireless@vger.kernel.org
From: Drunk Cat <natserver2@gmail.com>
Subject: rtl8xxxu (mac80211) not working with alfa AWUS036NHR v2
Date: Wed, 27 Jan 2016 14:50:25 +0000 (UTC)
Message-ID: <loom.20160127T154906-116@post.gmane.org> (sfid-20160127_155542_201956_1B139E2A)
References: <1444869891-21174-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

problem: it does not connect to any wifi network you can see the time out on 
dmesg

>uname -a
Linux DrunkCatPC 4.4.0-4-MANJARO #1 SMP PREEMPT Wed Jan 20 20:22:31 UTC 2016 
x86_64 GNU/Linux

>lsusb

Bus 002 Device 007: ID 0bda:817f Realtek Semiconductor Corp. RTL8188RU 
802.11n WLAN Adapter

>iwconfig
wlp0s20u1  IEEE 802.11bgn  ESSID:off/any  
          Mode:Managed  Access Point: Not-Associated   Tx-Power=20 dBm   
          Retry short limit:7   RTS thr=2347 B   Fragment thr:off
          Power Management:off
>dmesg

[16421.696441] usb 2-1: new high-speed USB device number 6 using xhci_hcd
[16423.550427] usb 2-1: Vendor:         11n U
[16423.550433] usb 2-1: Product: US036NHR
[16423.550437] usb 2-1: RTL8188RU rev A (TSMC) 1T1R, TX queues 2, WiFi=1, 
BT=0, GPS=0, HI PA=1
[16423.550439] usb 2-1: RTL8188RU MAC: 00:c0:ca:7e:c7:d3
[16423.550441] usb 2-1: rtl8xxxu: Loading firmware 
rtlwifi/rtl8192cufw_TMSC.bin
[16423.566357] usb 2-1: Firmware revision 80.0 (signature 0x88c1)
[16423.851643] usb 2-1: rtl8xxxu_iqk_path_a: Path A RX IQK failed!
[16423.958287] usbcore: registered new interface driver rtl8xxxu
[16424.016545] rtl8xxxu 2-1:1.0 wlp0s20u1: renamed from wlan0
[16424.032244] IPv6: ADDRCONF(NETDEV_UP): wlp0s20u1: link is not ready
[16424.038160] IPv6: ADDRCONF(NETDEV_UP): wlp0s20u1: link is not ready
[16424.080456] IPv6: ADDRCONF(NETDEV_UP): wlp0s20u1: link is not ready
[16673.335433] ACPI Warning: \_SB_.PCI0.RP05.PEGP._DSM: Argument #4 type 
mismatch - Found [Buffer], ACPI requires [Package] (20150930/nsarguments-95)
[16673.343329] [drm] Module unloaded
[16673.358464] bbswitch: disabling discrete graphics
[16673.358476] ACPI Warning: \_SB_.PCI0.RP05.PEGP._DSM: Argument #4 type 
mismatch - Found [Buffer], ACPI requires [Package] (20150930/nsarguments-95)
[16673.370088] pci 0000:04:00.0: Refused to change power state, currently in 
D0
[16693.345669] bbswitch: enabling discrete graphics
[16693.851919] [drm] Initialized nvidia-drm 0.0.0 20150116 for 0000:04:00.0 
on minor 1
[16693.851926] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  352.63  Sat 
Nov  7 21:25:42 PST 2015
[16693.874719] vgaarb: this pci device is not a vga device
[16693.877519] ACPI Warning: \_SB_.PCI0.RP05.PEGP._DSM: Argument #4 type 
mismatch - Found [Buffer], ACPI requires [Package] (20150930/nsarguments-95)
[16693.877610] ACPI Warning: \_SB_.PCI0.RP05.PEGP._DSM: Argument #4 type 
mismatch - Found [Buffer], ACPI requires [Package] (20150930/nsarguments-95)
[16693.877645] ACPI Warning: \_SB_.PCI0.RP05.PEGP._DSM: Argument #4 type 
mismatch - Found [Buffer], ACPI requires [Package] (20150930/nsarguments-95)
[16693.877680] ACPI Warning: \_SB_.PCI0.RP05.PEGP._DSM: Argument #4 type 
mismatch - Found [Buffer], ACPI requires [Package] (20150930/nsarguments-95)
[16693.877711] ACPI Warning: \_SB_.PCI0.RP05.PEGP._DSM: Argument #4 type 
mismatch - Found [Buffer], ACPI requires [Package] (20150930/nsarguments-95)
[16693.877741] ACPI Warning: \_SB_.PCI0.RP05.PEGP._DSM: Argument #4 type 
mismatch - Found [Buffer], ACPI requires [Package] (20150930/nsarguments-95)
[16693.877796] ACPI Warning: \_SB_.PCI0.RP05.PEGP._DSM: Argument #4 type 
mismatch - Found [Buffer], ACPI requires [Package] (20150930/nsarguments-95)
[16693.877823] ACPI Warning: \_SB_.PCI0.RP05.PEGP._DSM: Argument #4 type 
mismatch - Found [Buffer], ACPI requires [Package] (20150930/nsarguments-95)
[16693.896287] ACPI Warning: \_SB_.PCI0.RP05.PEGP._DSM: Argument #4 type 
mismatch - Found [Buffer], ACPI requires [Package] (20150930/nsarguments-95)
[16694.332278] vgaarb: this pci device is not a vga device
[16754.752107] wlp3s0: deauthenticating from 9c:97:26:0f:0e:8e by local 
choice (Reason: 3=DEAUTH_LEAVING)
[16754.773908] cfg80211: World regulatory domain updated:
[16754.773911] cfg80211:  DFS Master region: unset
[16754.773912] cfg80211:   (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp), (dfs_cac_time)
[16754.773913] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 
2000 mBm), (N/A)
[16754.773915] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 
2000 mBm), (N/A)
[16754.773916] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 
2000 mBm), (N/A)
[16754.773917] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 
KHz AUTO), (N/A, 2000 mBm), (N/A)
[16754.773919] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 
KHz AUTO), (N/A, 2000 mBm), (0 s)
[16754.773920] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 
2000 mBm), (0 s)
[16754.773921] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 
2000 mBm), (N/A)
[16754.773922] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), 
(N/A, 0 mBm), (N/A)
[16763.402727] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[16763.417485] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[16855.122476] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[16886.169494] wlp0s20u1: authenticate with 9c:97:26:0f:0e:8e
[16886.178492] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 1/3)
[16886.378815] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 2/3)
[16886.582153] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 3/3)
[16886.785485] wlp0s20u1: authentication with 9c:97:26:0f:0e:8e timed out
[16887.892687] wlp0s20u1: authenticate with 9c:97:26:0f:0e:8e
[16887.900447] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 1/3)
[16888.102209] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 2/3)
[16888.305548] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 3/3)
[16888.508920] wlp0s20u1: authentication with 9c:97:26:0f:0e:8e timed out
[16890.019757] wlp0s20u1: authenticate with 9c:97:26:0f:0e:8e
[16890.026490] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 1/3)
[16890.228972] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 2/3)
[16890.432302] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 3/3)
[16890.635649] wlp0s20u1: authentication with 9c:97:26:0f:0e:8e timed out
[16892.649660] wlp0s20u1: authenticate with 9c:97:26:0f:0e:8e
[16892.656123] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 1/3)
[16892.859066] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 2/3)
[16893.062410] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 3/3)
[16893.265769] wlp0s20u1: authentication with 9c:97:26:0f:0e:8e timed out
[16904.280196] wlp0s20u1: authenticate with 9c:97:26:0f:0e:8e
[16904.291265] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 1/3)
[16904.492903] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 2/3)
[16904.696222] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 3/3)
[16904.859783] wlp0s20u1: aborting authentication with 9c:97:26:0f:0e:8e by 
local choice (Reason: 3=DEAUTH_LEAVING)
[16904.884734] IPv6: ADDRCONF(NETDEV_UP): wlp0s20u1: link is not ready
[17480.739921] vgaarb: this pci device is not a vga device
[17594.761942] vgaarb: this pci device is not a vga device
[17614.149381] wlp0s20u1: authenticate with 9c:97:26:0f:0e:8e
[17614.154382] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 1/3)
[17614.355248] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 2/3)
[17614.558591] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 3/3)
[17614.761922] wlp0s20u1: authentication with 9c:97:26:0f:0e:8e timed out
[17625.726388] wlp0s20u1: authenticate with 9c:97:26:0f:0e:8e
[17625.732085] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 1/3)
[17625.932382] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 2/3)
[17626.135736] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 3/3)
[17626.339089] wlp0s20u1: authentication with 9c:97:26:0f:0e:8e timed out
[16421.696441] usb 2-1: new high-speed USB device number 6 using xhci_hcd
[16423.550427] usb 2-1: Vendor:         11n U
[16423.550433] usb 2-1: Product: US036NHR
[16423.550437] usb 2-1: RTL8188RU rev A (TSMC) 1T1R, TX queues 2, WiFi=1, 
BT=0, GPS=0, HI PA=1
[16423.550439] usb 2-1: RTL8188RU MAC: 00:c0:ca:7e:c7:d3
[16423.550441] usb 2-1: rtl8xxxu: Loading firmware 
rtlwifi/rtl8192cufw_TMSC.bin
[16423.566357] usb 2-1: Firmware revision 80.0 (signature 0x88c1)
[16423.851643] usb 2-1: rtl8xxxu_iqk_path_a: Path A RX IQK failed!
[16423.958287] usbcore: registered new interface driver rtl8xxxu
[16424.016545] rtl8xxxu 2-1:1.0 wlp0s20u1: renamed from wlan0
[16424.032244] IPv6: ADDRCONF(NETDEV_UP): wlp0s20u1: link is not ready
[16424.038160] IPv6: ADDRCONF(NETDEV_UP): wlp0s20u1: link is not ready
[16424.080456] IPv6: ADDRCONF(NETDEV_UP): wlp0s20u1: link is not ready
[16673.335433] ACPI Warning: \_SB_.PCI0.RP05.PEGP._DSM: Argument #4 type 
mismatch - Found [Buffer], ACPI requires [Package] (20150930/nsarguments-95)
[16673.343329] [drm] Module unloaded
[16673.358464] bbswitch: disabling discrete graphics
[16673.358476] ACPI Warning: \_SB_.PCI0.RP05.PEGP._DSM: Argument #4 type 
mismatch - Found [Buffer], ACPI requires [Package] (20150930/nsarguments-95)
[16673.370088] pci 0000:04:00.0: Refused to change power state, currently in 
D0
[16693.345669] bbswitch: enabling discrete graphics
[16693.851919] [drm] Initialized nvidia-drm 0.0.0 20150116 for 0000:04:00.0 
on minor 1
[16693.851926] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  352.63  Sat 
Nov  7 21:25:42 PST 2015
[16693.874719] vgaarb: this pci device is not a vga device
[16693.877519] ACPI Warning: \_SB_.PCI0.RP05.PEGP._DSM: Argument #4 type 
mismatch - Found [Buffer], ACPI requires [Package] (20150930/nsarguments-95)
[16693.877610] ACPI Warning: \_SB_.PCI0.RP05.PEGP._DSM: Argument #4 type 
mismatch - Found [Buffer], ACPI requires [Package] (20150930/nsarguments-95)
[16693.877645] ACPI Warning: \_SB_.PCI0.RP05.PEGP._DSM: Argument #4 type 
mismatch - Found [Buffer], ACPI requires [Package] (20150930/nsarguments-95)
[16693.877680] ACPI Warning: \_SB_.PCI0.RP05.PEGP._DSM: Argument #4 type 
mismatch - Found [Buffer], ACPI requires [Package] (20150930/nsarguments-95)
[16693.877711] ACPI Warning: \_SB_.PCI0.RP05.PEGP._DSM: Argument #4 type 
mismatch - Found [Buffer], ACPI requires [Package] (20150930/nsarguments-95)
[16693.877741] ACPI Warning: \_SB_.PCI0.RP05.PEGP._DSM: Argument #4 type 
mismatch - Found [Buffer], ACPI requires [Package] (20150930/nsarguments-95)
[16693.877796] ACPI Warning: \_SB_.PCI0.RP05.PEGP._DSM: Argument #4 type 
mismatch - Found [Buffer], ACPI requires [Package] (20150930/nsarguments-95)
[16693.877823] ACPI Warning: \_SB_.PCI0.RP05.PEGP._DSM: Argument #4 type 
mismatch - Found [Buffer], ACPI requires [Package] (20150930/nsarguments-95)
[16693.896287] ACPI Warning: \_SB_.PCI0.RP05.PEGP._DSM: Argument #4 type 
mismatch - Found [Buffer], ACPI requires [Package] (20150930/nsarguments-95)
[16694.332278] vgaarb: this pci device is not a vga device
[16754.752107] wlp3s0: deauthenticating from 9c:97:26:0f:0e:8e by local 
choice (Reason: 3=DEAUTH_LEAVING)
[16754.773908] cfg80211: World regulatory domain updated:
[16754.773911] cfg80211:  DFS Master region: unset
[16754.773912] cfg80211:   (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp), (dfs_cac_time)
[16754.773913] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 
2000 mBm), (N/A)
[16754.773915] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 
2000 mBm), (N/A)
[16754.773916] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 
2000 mBm), (N/A)
[16754.773917] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 
KHz AUTO), (N/A, 2000 mBm), (N/A)
[16754.773919] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 
KHz AUTO), (N/A, 2000 mBm), (0 s)
[16754.773920] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 
2000 mBm), (0 s)
[16754.773921] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 
2000 mBm), (N/A)
[16754.773922] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), 
(N/A, 0 mBm), (N/A)
[16763.402727] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[16763.417485] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[16855.122476] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[16886.169494] wlp0s20u1: authenticate with 9c:97:26:0f:0e:8e
[16886.178492] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 1/3)
[16886.378815] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 2/3)
[16886.582153] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 3/3)
[16886.785485] wlp0s20u1: authentication with 9c:97:26:0f:0e:8e timed out
[16887.892687] wlp0s20u1: authenticate with 9c:97:26:0f:0e:8e
[16887.900447] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 1/3)
[16888.102209] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 2/3)
[16888.305548] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 3/3)
[16888.508920] wlp0s20u1: authentication with 9c:97:26:0f:0e:8e timed out
[16890.019757] wlp0s20u1: authenticate with 9c:97:26:0f:0e:8e
[16890.026490] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 1/3)
[16890.228972] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 2/3)
[16890.432302] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 3/3)
[16890.635649] wlp0s20u1: authentication with 9c:97:26:0f:0e:8e timed out
[16892.649660] wlp0s20u1: authenticate with 9c:97:26:0f:0e:8e
[16892.656123] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 1/3)
[16892.859066] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 2/3)
[16893.062410] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 3/3)
[16893.265769] wlp0s20u1: authentication with 9c:97:26:0f:0e:8e timed out
[16904.280196] wlp0s20u1: authenticate with 9c:97:26:0f:0e:8e
[16904.291265] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 1/3)
[16904.492903] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 2/3)
[16904.696222] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 3/3)
[16904.859783] wlp0s20u1: aborting authentication with 9c:97:26:0f:0e:8e by 
local choice (Reason: 3=DEAUTH_LEAVING)
[16904.884734] IPv6: ADDRCONF(NETDEV_UP): wlp0s20u1: link is not ready
[17480.739921] vgaarb: this pci device is not a vga device
[17594.761942] vgaarb: this pci device is not a vga device
[17614.149381] wlp0s20u1: authenticate with 9c:97:26:0f:0e:8e
[17614.154382] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 1/3)
[17614.355248] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 2/3)
[17614.558591] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 3/3)
[17614.761922] wlp0s20u1: authentication with 9c:97:26:0f:0e:8e timed out
[17625.726388] wlp0s20u1: authenticate with 9c:97:26:0f:0e:8e
[17625.732085] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 1/3)
[17625.932382] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 2/3)
[17626.135736] wlp0s20u1: send auth to 9c:97:26:0f:0e:8e (try 3/3)
[17626.339089] wlp0s20u1: authentication with 9c:97:26:0f:0e:8e timed out

