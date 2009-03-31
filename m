Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:21122 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756476AbZCaRKA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 13:10:00 -0400
Subject: Re: [ipw3945-devel] 2.6.29-wl-36116-g6a982a0: connection loss
From: reinette chatre <reinette.chatre@intel.com>
To: Nico -telmich- Schottelius
	<nico-linux-ipw3945-devel@schottelius.org>,
	Kalle Valo <kalle.valo@nokia.com>
Cc: "ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090331044946.GA10616@denkbrett.schottelius.org>
References: <20090331044946.GA10616@denkbrett.schottelius.org>
Content-Type: text/plain
Date: Tue, 31 Mar 2009 10:15:33 -0700
Message-Id: <1238519733.10366.32.camel@rc-desk> (sfid-20090331_191007_889953_E44BBA1F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding Kalle and the linux-wireless list ... if anybody responds who is
not member of ipw3945 ml, please consider removing that ml from cc list.
If anybody on ipw3945 are interested in this, please follow thread on
linux-wireless.

On Mon, 2009-03-30 at 21:49 -0700, Nico -telmich- Schottelius wrote:
> Hello!
> 
> Using this version from iwlwifi-2.6 the notebook loses the connection
> to the AP quite often, without moving it around. It used to work on
> 2.6.29 (linux-2.6).
> 
> Configuration can be found at [0].
> 
> dmesg attached.
> 
> Sincerly,
> 
> Nico
> 
> dmesg:
> 
> [ 2878.903479] PM: Syncing filesystems ... done.
> [ 2879.069197] [drm:gm45_get_vblank_counter] *ERROR* trying to get vblank count for disabled pipe 0
> [ 2879.695470] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [ 2879.713249] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> [ 2879.722910] Suspending console(s) (use no_console_suspend to debug)
> [ 2879.740177] pci 0000:00:02.0: power state changed by ACPI to D3
> [ 2880.436385] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [ 2880.437030] sd 0:0:0:0: [sda] Stopping disk
> [ 2880.856391] ehci_hcd 0000:00:1d.7: PCI INT D disabled
> [ 2880.856470] ehci_hcd 0000:00:1d.7: PME# disabled
> [ 2880.873410] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
> [ 2880.873438] uhci_hcd 0000:00:1d.2: PCI INT C disabled
> [ 2880.873508] uhci_hcd 0000:00:1d.1: PCI INT B disabled
> [ 2880.873575] uhci_hcd 0000:00:1d.0: PCI INT A disabled
> [ 2880.873844] HDA Intel 0000:00:1b.0: PCI INT B disabled
> [ 2880.888141] ehci_hcd 0000:00:1a.7: PCI INT D disabled
> [ 2880.888217] ehci_hcd 0000:00:1a.7: PME# disabled
> [ 2880.905157] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
> [ 2880.905182] uhci_hcd 0000:00:1a.2: PCI INT C disabled
> [ 2880.905251] uhci_hcd 0000:00:1a.1: PCI INT B disabled
> [ 2880.905318] uhci_hcd 0000:00:1a.0: PCI INT A disabled
> [ 2880.963117] e1000e 0000:00:19.0: PME# enabled
> [ 2880.963153] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
> [ 2880.963161] e1000e 0000:00:19.0: PME# enabled
> [ 2880.963165] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
> [ 2880.963177] e1000e 0000:00:19.0: PCI INT A disabled
> [ 2880.976210] ACPI handle has no context!
> [ 2880.997832] ACPI: Preparing to enter system sleep state S3
> [ 2881.019077] Disabling non-boot CPUs ...
> [ 2881.124068] CPU 1 is now offline
> [ 2881.124073] SMP alternatives: switching to UP code
> [ 2881.382661] CPU1 is down
> [ 2881.382769] Extended CMOS year: 2000
> [ 2881.382769] Back to C!
> [ 2881.382769] CPU0: Thermal monitoring enabled (TM2)
> [ 2881.382769] Extended CMOS year: 2000
> [ 2881.382769] pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900403)
> [ 2881.382769] pci 0000:00:02.1: restoring config space at offset 0x1 (was 0x900000, writing 0x900007)
> [ 2881.382769] pci 0000:00:03.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
> [ 2881.382769] pci 0000:00:03.0: restoring config space at offset 0x1 (was 0x100006, writing 0x180006)
> [ 2881.382769] pci 0000:00:03.2: restoring config space at offset 0xf (was 0x300, writing 0x30b)
> [ 2881.382769] pci 0000:00:03.2: restoring config space at offset 0x1 (was 0xb00005, writing 0xb00001)
> [ 2881.382769] serial 0000:00:03.3: restoring config space at offset 0xf (was 0x200, writing 0x20b)
> [ 2881.382769] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
> [ 2881.382769] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
> [ 2881.382769] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
> [ 2881.382769] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
> [ 2881.382769] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100102)
> [ 2881.382769] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
> [ 2881.382769] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
> [ 2881.382769] pcieport-driver 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
> [ 2881.382769] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
> [ 2881.382769] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
> [ 2881.382769] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
> [ 2881.382769] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
> [ 2881.382769] pci 0000:00:1e.0: restoring config space at offset 0xf (was 0x40000, writing 0x400ff)
> [ 2881.382769] pci 0000:00:1e.0: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
> [ 2881.382769] pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0x0, writing 0xfff0)
> [ 2881.382769] pci 0000:00:1e.0: restoring config space at offset 0x7 (was 0x22800000, writing 0x228000f0)
> [ 2881.382769] pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
> [ 2881.382769] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
> [ 2881.382769] iwlagn 0000:03:00.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
> [ 2881.382769] Enabling non-boot CPUs ...
> [ 2881.382769] SMP alternatives: switching to SMP code
> [ 2881.509951] Booting processor 1 APIC 0x1 ip 0x6000
> [ 2881.382433] Initializing CPU#1
> [ 2881.382433] Calibrating delay using timer specific routine.. 4522.48 BogoMIPS (lpj=9044964)
> [ 2881.382433] CPU: L1 I cache: 32K, L1 D cache: 32K
> [ 2881.382433] CPU: L2 cache: 3072K
> [ 2881.382433] [ds] using Core 2/Atom configuration
> [ 2881.382433] CPU: Physical Processor ID: 0
> [ 2881.382433] CPU: Processor Core ID: 1
> [ 2881.382433] CPU1: Thermal monitoring enabled (TM2)
> [ 2881.601008] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz stepping 06
> [ 2881.604014] Switched to high resolution mode on CPU 1
> [ 2881.612346] CPU1 is up
> [ 2881.612348] ACPI: Waking up from system sleep state S3
> [ 2881.651799] ACPI: EC: non-query interrupt received, switching to interrupt mode
> [ 2881.669698] pci 0000:00:02.0: PME# disabled
> [ 2881.669703] pci 0000:00:02.1: PME# disabled
> [ 2881.669706] pci 0000:00:03.0: PME# disabled
> [ 2881.669708] pci 0000:00:03.2: PME# disabled
> [ 2881.669782] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> [ 2881.669787] e1000e 0000:00:19.0: setting latency timer to 64
> [ 2881.669790] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
> [ 2881.669794] e1000e 0000:00:19.0: PME# disabled
> [ 2881.669795] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
> [ 2881.669799] e1000e 0000:00:19.0: PME# disabled
> [ 2881.669829] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
> [ 2881.724869] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
> [ 2881.724875] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> [ 2881.724881] uhci_hcd 0000:00:1a.0: setting latency timer to 64
> [ 2881.724905] usb usb2: root hub lost power or was reset
> [ 2881.724958] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
> [ 2881.724964] uhci_hcd 0000:00:1a.1: setting latency timer to 64
> [ 2881.724987] usb usb4: root hub lost power or was reset
> [ 2881.725885] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
> [ 2881.725890] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
> [ 2881.725897] uhci_hcd 0000:00:1a.2: setting latency timer to 64
> [ 2881.725919] usb usb5: root hub lost power or was reset
> [ 2881.725985] ehci_hcd 0000:00:1a.7: PME# disabled
> [ 2881.726702] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
> [ 2881.726709] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
> [ 2881.726716] ehci_hcd 0000:00:1a.7: setting latency timer to 64
> [ 2881.726722] ehci_hcd 0000:00:1a.7: PME# disabled
> [ 2881.726787] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [ 2881.726793] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [ 2881.726809] pcieport-driver 0000:00:1c.0: setting latency timer to 64
> [ 2881.726817] pcieport-driver 0000:00:1c.1: setting latency timer to 64
> [ 2881.726825] pcieport-driver 0000:00:1c.3: setting latency timer to 64
> [ 2881.727475] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [ 2881.727480] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [ 2881.727487] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [ 2881.727510] usb usb6: root hub lost power or was reset
> [ 2881.727562] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [ 2881.727568] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [ 2881.727591] usb usb7: root hub lost power or was reset
> [ 2881.727642] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [ 2881.727648] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [ 2881.727670] usb usb8: root hub lost power or was reset
> [ 2881.727739] ehci_hcd 0000:00:1d.7: PME# disabled
> [ 2881.728398] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
> [ 2881.728410] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> [ 2881.728421] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [ 2881.728432] ehci_hcd 0000:00:1d.7: PME# disabled
> [ 2881.728462] pci 0000:00:1e.0: setting latency timer to 64
> [ 2881.728567] ahci 0000:00:1f.2: setting latency timer to 64
> [ 2881.729422] sd 0:0:0:0: [sda] Starting disk
> [ 2882.048292] ata2: SATA link down (SStatus 0 SControl 300)
> [ 2883.337277] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [ 2883.382946] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
> [ 2883.382954] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
> [ 2883.383134] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
> [ 2883.383141] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
> [ 2883.394033] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
> [ 2883.394041] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
> [ 2883.394221] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
> [ 2883.394228] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
> [ 2883.395341] ata1.00: configured for UDMA/100
> [ 2883.397667] ata1.00: configured for UDMA/100
> [ 2883.412268] ata1: EH complete
> [ 2883.412379] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
> [ 2883.412417] sd 0:0:0:0: [sda] Write Protect is off
> [ 2883.412422] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [ 2883.412475] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [ 2883.412535] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
> [ 2883.412566] sd 0:0:0:0: [sda] Write Protect is off
> [ 2883.412571] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [ 2883.412621] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [ 2883.773604] Monitor-Mwait will be used to enter C-3 state
> [ 2883.775647] thinkpad_acpi: EC reports that Thermal Table has changed
> [ 2884.808126] usb 1-6: reset high speed USB device using ehci_hcd and address 3
> [ 2884.975379] Registered led device: iwl-phy0::radio
> [ 2884.975424] Registered led device: iwl-phy0::assoc
> [ 2884.975467] Registered led device: iwl-phy0::RX
> [ 2884.975511] Registered led device: iwl-phy0::TX
> [ 2885.100138] usb 3-6: reset high speed USB device using ehci_hcd and address 2
> [ 2885.352120] usb 4-1: reset full speed USB device using uhci_hcd and address 2
> [ 2885.499427] pci 0000:00:02.0: power state changed by ACPI to D0
> [ 2885.499623] pci 0000:00:02.0: power state changed by ACPI to D0
> [ 2885.499636] pci 0000:00:02.0: setting latency timer to 64
> [ 2885.517523] Restarting tasks ... done.
> [ 2886.936163] IBM TrackPoint firmware: 0x0e, buttons: 3/3
> [ 2886.954436] input: TPPS/2 IBM TrackPoint as /class/input/input12
> [ 2891.584135] usb 3-1: new high speed USB device using ehci_hcd and address 3
> [ 2891.719654] usb 3-1: configuration #1 chosen from 1 choice
> [ 2891.728109] scsi5 : SCSI emulation for USB Mass Storage devices
> [ 2891.734018] usb-storage: device found at 3
> [ 2891.734023] usb-storage: waiting for device to settle before scanning
> [ 2896.732856] scsi 5:0:0:0: Direct-Access     WD       5000BMV External 1.75 PQ: 0 ANSI: 4
> [ 2896.733688] sd 5:0:0:0: [sdc] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
> [ 2896.734169] sd 5:0:0:0: [sdc] Write Protect is off
> [ 2896.734176] sd 5:0:0:0: [sdc] Mode Sense: 23 00 00 00
> [ 2896.734181] sd 5:0:0:0: [sdc] Assuming drive cache: write through
> [ 2896.734918] sd 5:0:0:0: [sdc] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
> [ 2896.735417] sd 5:0:0:0: [sdc] Write Protect is off
> [ 2896.735424] sd 5:0:0:0: [sdc] Mode Sense: 23 00 00 00
> [ 2896.735428] sd 5:0:0:0: [sdc] Assuming drive cache: write through
> [ 2896.735435]  sdc: unknown partition table
> [ 2896.768368] sd 5:0:0:0: [sdc] Attached SCSI disk
> [ 2896.768910] usb-storage: device scan complete
> [ 3009.365039] wlan0: direct probe to AP 00:14:6c:67:9c:32 try 1
> [ 3009.368315] wlan0 direct probe responded
> [ 3009.368321] wlan0: authenticate with AP 00:14:6c:67:9c:32
> [ 3009.370298] wlan0: authenticated
> [ 3009.370304] wlan0: associate with AP 00:14:6c:67:9c:32
> [ 3009.568063] wlan0: associate with AP 00:14:6c:67:9c:32
> [ 3009.575107] wlan0: RX AssocResp from 00:14:6c:67:9c:32 (capab=0x601 status=0 aid=10)
> [ 3009.575114] wlan0: associated
> [ 3009.581276] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [ 3020.000031] wlan0: no IPv6 routers present
> [ 3151.295473] wlan0: beacon loss from AP 00:14:6c:67:9c:32 - sending probe request
> [ 4191.742593] wlan0: beacon loss from AP 00:14:6c:67:9c:32 - sending probe request
> [ 4193.740066] wlan0: no probe response from AP 00:14:6c:67:9c:32 - disassociating
> [ 4321.376160] wlan0: deauthenticated (Reason: 7)
> [ 4965.645063] CE: hpet increasing min_delta_ns to 15000 nsec
> [ 7337.805893] wlan0: direct probe to AP 00:14:6c:67:9c:32 try 1
> [ 7337.810976] wlan0 direct probe responded
> [ 7337.810983] wlan0: authenticate with AP 00:14:6c:67:9c:32
> [ 7338.008060] wlan0: authenticate with AP 00:14:6c:67:9c:32
> [ 7338.010087] wlan0: authenticated
> [ 7338.010093] wlan0: associate with AP 00:14:6c:67:9c:32
> [ 7338.018590] wlan0: RX ReassocResp from 00:14:6c:67:9c:32 (capab=0x201 status=0 aid=13)
> [ 7338.018597] wlan0: associated
> [ 7525.760817] usb 3-1: USB disconnect, address 3
> [ 7572.146385] wlan0: beacon loss from AP 00:14:6c:67:9c:32 - sending probe request
> [ 7702.189368] wlan0: beacon loss from AP 00:14:6c:67:9c:32 - sending probe request
> [ 7962.173161] wlan0: beacon loss from AP 00:14:6c:67:9c:32 - sending probe request
> [ 8092.216232] wlan0: beacon loss from AP 00:14:6c:67:9c:32 - sending probe request
> [ 8094.216137] wlan0: no probe response from AP 00:14:6c:67:9c:32 - disassociating
> [ 8221.952208] wlan0: deauthenticated (Reason: 7)
> [33012.904311] wlan0: direct probe to AP 00:14:6c:67:9c:32 try 1
> [33012.907527] wlan0 direct probe responded
> [33012.907533] wlan0: authenticate with AP 00:14:6c:67:9c:32
> [33013.104059] wlan0: authenticate with AP 00:14:6c:67:9c:32
> [33013.106102] wlan0: authenticated
> [33013.106107] wlan0: associate with AP 00:14:6c:67:9c:32
> [33013.114796] wlan0: RX ReassocResp from 00:14:6c:67:9c:32 (capab=0x201 status=0 aid=14)
> [33013.114802] wlan0: associated
> [33053.635621] wlan0: beacon loss from AP 00:14:6c:67:9c:32 - sending probe request
> [33183.267415] wlan0: beacon loss from AP 00:14:6c:67:9c:32 - sending probe request

Perhaps the new beacon filtering work [1] is changing more than it
intended?

Reinette

[1] http://marc.info/?l=linux-wireless&m=123775186703406&w=2

