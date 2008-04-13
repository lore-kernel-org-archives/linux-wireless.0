Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from durandal.kismetwireless.net ([199.201.145.179]:53217 "EHLO
	durandal.nerv-un.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbYDMFD3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2008 01:03:29 -0400
Date: Sun, 13 Apr 2008 01:02:36 -0400
From: Mike Kershaw <dragorn@kismetwireless.net>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Kismet shows no clients (drivers iwl3945.ko or p54pci.ko)
Message-ID: <20080413050236.GA13869@drd1813.lan> (sfid-20080413_060335_213206_973263B6)
Reply-To: Mike Kershaw <dragorn@kismetwireless.net>
References: <47FDF732.7000304@interia.pl> <20080410181612.GB23971@drd1813.lan> <D936D925018D154694D8A362EEB089200428A22D@orsmsx416.amr.corp.intel.com> <20080412153417.GA11886@drd1813.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
In-Reply-To: <20080412153417.GA11886@drd1813.lan>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 12, 2008 at 11:34:17AM -0400, Mike Kershaw wrote:
> On Fri, Apr 11, 2008 at 07:50:33AM -0700, Chatre, Reinette wrote:
> > Could you please load the driver with debugging (modprobe iwl4965
> > debug=3D0x43fff) to help us get a better idea what is going on.

Heres another set of failures, coming out of S3 suspend-to-ram on the
same kernel.  Device was unresponsive on resume, reloaded modules with debu=
g,
continued to be unresponsive until I rebooted.

iwl4965: No space for Tx
iwl4965: Error sending REPLY_CARD_STATE_CMD: enqueue_hcmd failed: -28
iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.2.26kds
iwl4965: Copyright(c) 2003-2008 Intel Corporation
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:03:00.0 to 64
iwl4965: Detected Intel Wireless WiFi Link 4965AGN
iwl4965: Tunable channels: 11 802.11bg, 13 802.11a channels
phy4: Selected rate control algorithm 'iwl-4965-rs'
input: 4965AGN as /class/input/input14
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
iwl4965: Could not read microcode: -22
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
iwl4965: Could not read microcode: -22
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
iwl4965: Wait for START_ALIVE timeout after 2000ms.
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
iwl4965: Wait for START_ALIVE timeout after 2000ms.

[ reload with debug ]

iwl4965: No space for Tx
iwl4965: Error sending REPLY_CARD_STATE_CMD: enqueue_hcmd failed: -28
iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.2.26kds
iwl4965: Copyright(c) 2003-2008 Intel Corporation
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:03:00.0 to 64
iwl4965: U iwl4965_pci_probe pci_resource_len =3D 0x00002000
iwl4965: U iwl4965_pci_probe pci_resource_base =3D f8954000
iwl4965: Detected Intel Wireless WiFi Link 4965AGN
iwl4965: U iwl4965_pci_probe MAC address: 00:13:e8:92:3f:cb
iwl4965: U iwl4965_set_rxon_chain rx chain 280E
iwl4965: U iwlcore_set_rxon_channel Staging channel set to 6 [0]
iwl4965: U iwl_init_channel_map Initializing regulatory info from EEPROM
iwl4965: U iwl_init_channel_map Parsing data for 56 channels.
iwl4965: U iwl_init_channel_map Ch. 1 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b=
 14dBm): Ad-Hoc supported
iwl4965: U iwl_init_channel_map Ch. 2 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b=
 14dBm): Ad-Hoc supported
iwl4965: U iwl_init_channel_map Ch. 3 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b=
 14dBm): Ad-Hoc supported
iwl4965: U iwl_init_channel_map Ch. 4 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b=
 14dBm): Ad-Hoc supported
iwl4965: U iwl_init_channel_map Ch. 5 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b=
 14dBm): Ad-Hoc supported
iwl4965: U iwl_init_channel_map Ch. 6 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b=
 14dBm): Ad-Hoc supported
iwl4965: U iwl_init_channel_map Ch. 7 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b=
 14dBm): Ad-Hoc supported
iwl4965: U iwl_init_channel_map Ch. 8 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b=
 14dBm): Ad-Hoc supported
iwl4965: U iwl_init_channel_map Ch. 9 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b=
 14dBm): Ad-Hoc supported
iwl4965: U iwl_init_channel_map Ch. 10 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2=
b 14dBm): Ad-Hoc supported
iwl4965: U iwl_init_channel_map Ch. 11 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2=
b 14dBm): Ad-Hoc supported
iwl4965: U iwl_init_channel_map Ch. 12 Flags 0 [2.4GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 13 Flags 0 [2.4GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 14 Flags 0 [2.4GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 183 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 184 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 185 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 187 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 188 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 189 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 192 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 196 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 7 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 8 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 11 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 12 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 16 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 34 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 36 [5.2GHz] VALID WIDE (0x21 15dBm): Ad=
-Hoc not supported
iwl4965: U iwl_init_channel_map Ch. 38 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 40 [5.2GHz] VALID WIDE (0x21 15dBm): Ad=
-Hoc not supported
iwl4965: U iwl_init_channel_map Ch. 42 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 44 [5.2GHz] VALID WIDE (0x21 15dBm): Ad=
-Hoc not supported
iwl4965: U iwl_init_channel_map Ch. 46 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 48 [5.2GHz] VALID WIDE (0x21 15dBm): Ad=
-Hoc not supported
iwl4965: U iwl_init_channel_map Ch. 52 [5.2GHz] VALID RADAR WIDE (0x31 15dB=
m): Ad-Hoc not supported
iwl4965: U iwl_init_channel_map Ch. 56 [5.2GHz] VALID RADAR WIDE (0x31 15dB=
m): Ad-Hoc not supported
iwl4965: U iwl_init_channel_map Ch. 60 [5.2GHz] VALID RADAR WIDE (0x31 15dB=
m): Ad-Hoc not supported
iwl4965: U iwl_init_channel_map Ch. 64 [5.2GHz] VALID RADAR WIDE (0x31 15dB=
m): Ad-Hoc not supported
iwl4965: U iwl_init_channel_map Ch. 100 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 104 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 108 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 112 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 116 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 120 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 124 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 128 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 132 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 136 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 140 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 145 Flags 0 [5.2GHz] - No traffic
iwl4965: U iwl_init_channel_map Ch. 149 [5.2GHz] VALID WIDE (0x21 16dBm): A=
d-Hoc not supported
iwl4965: U iwl_init_channel_map Ch. 153 [5.2GHz] VALID WIDE (0x21 16dBm): A=
d-Hoc not supported
iwl4965: U iwl_init_channel_map Ch. 157 [5.2GHz] VALID WIDE (0x21 16dBm): A=
d-Hoc not supported
iwl4965: U iwl_init_channel_map Ch. 161 [5.2GHz] VALID WIDE (0x21 16dBm): A=
d-Hoc not supported
iwl4965: U iwl_init_channel_map Ch. 165 [5.2GHz] VALID WIDE (0x21 16dBm): A=
d-Hoc not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 1 [2.4GHz] (0x00 0dBm): Ad-Hoc=
 not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 5 [2.4GHz] (0x00 0dBm): Ad-Hoc=
 not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 2 [2.4GHz] (0x00 0dBm): Ad-Hoc=
 not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 6 [2.4GHz] (0x00 0dBm): Ad-Hoc=
 not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 3 [2.4GHz] (0x00 0dBm): Ad-Hoc=
 not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 7 [2.4GHz] (0x00 0dBm): Ad-Hoc=
 not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 4 [2.4GHz] (0x00 0dBm): Ad-Hoc=
 not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 8 [2.4GHz] (0x00 0dBm): Ad-Hoc=
 not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 5 [2.4GHz] (0x00 0dBm): Ad-Hoc=
 not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 9 [2.4GHz] (0x00 0dBm): Ad-Hoc=
 not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 6 [2.4GHz] (0x00 0dBm): Ad-Hoc=
 not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 10 [2.4GHz] (0x00 0dBm): Ad-Ho=
c not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 7 [2.4GHz] (0x00 0dBm): Ad-Hoc=
 not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 11 [2.4GHz] (0x00 0dBm): Ad-Ho=
c not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 36 [5.2GHz] WIDE (0x21 13dBm):=
 Ad-Hoc not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 40 [5.2GHz] WIDE (0x21 13dBm):=
 Ad-Hoc not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 44 [5.2GHz] WIDE (0x21 15dBm):=
 Ad-Hoc not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 48 [5.2GHz] WIDE (0x21 15dBm):=
 Ad-Hoc not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 52 [5.2GHz] RADAR WIDE (0x31 1=
5dBm): Ad-Hoc not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 56 [5.2GHz] RADAR WIDE (0x31 1=
5dBm): Ad-Hoc not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 60 [5.2GHz] RADAR WIDE (0x31 1=
4dBm): Ad-Hoc not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 64 [5.2GHz] RADAR WIDE (0x31 1=
4dBm): Ad-Hoc not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 149 [5.2GHz] WIDE (0x21 16dBm)=
: Ad-Hoc not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 153 [5.2GHz] WIDE (0x21 16dBm)=
: Ad-Hoc not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 157 [5.2GHz] WIDE (0x21 16dBm)=
: Ad-Hoc not supported
iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 161 [5.2GHz] WIDE (0x21 16dBm)=
: Ad-Hoc not supported
iwl4965: U iwl4965_init_geos Channel 1 Freq=3D2412[2.4GHz] valid flag=3D00
iwl4965: U iwl4965_init_geos Channel 2 Freq=3D2417[2.4GHz] valid flag=3D00
iwl4965: U iwl4965_init_geos Channel 3 Freq=3D2422[2.4GHz] valid flag=3D00
iwl4965: U iwl4965_init_geos Channel 4 Freq=3D2427[2.4GHz] valid flag=3D00
iwl4965: U iwl4965_init_geos Channel 5 Freq=3D2432[2.4GHz] valid flag=3D00
iwl4965: U iwl4965_init_geos Channel 6 Freq=3D2437[2.4GHz] valid flag=3D00
iwl4965: U iwl4965_init_geos Channel 7 Freq=3D2442[2.4GHz] valid flag=3D00
iwl4965: U iwl4965_init_geos Channel 8 Freq=3D2447[2.4GHz] valid flag=3D00
iwl4965: U iwl4965_init_geos Channel 9 Freq=3D2452[2.4GHz] valid flag=3D00
iwl4965: U iwl4965_init_geos Channel 10 Freq=3D2457[2.4GHz] valid flag=3D00
iwl4965: U iwl4965_init_geos Channel 11 Freq=3D2462[2.4GHz] valid flag=3D00
iwl4965: U iwl4965_init_geos Channel 36 Freq=3D5180[5.2GHz] valid flag=3D06
iwl4965: U iwl4965_init_geos Channel 40 Freq=3D5200[5.2GHz] valid flag=3D06
iwl4965: U iwl4965_init_geos Channel 44 Freq=3D5220[5.2GHz] valid flag=3D06
iwl4965: U iwl4965_init_geos Channel 48 Freq=3D5240[5.2GHz] valid flag=3D06
iwl4965: U iwl4965_init_geos Channel 52 Freq=3D5260[5.2GHz] valid flag=3D0E
iwl4965: U iwl4965_init_geos Channel 56 Freq=3D5280[5.2GHz] valid flag=3D0E
iwl4965: U iwl4965_init_geos Channel 60 Freq=3D5300[5.2GHz] valid flag=3D0E
iwl4965: U iwl4965_init_geos Channel 64 Freq=3D5320[5.2GHz] valid flag=3D0E
iwl4965: U iwl4965_init_geos Channel 149 Freq=3D5745[5.2GHz] valid flag=3D06
iwl4965: U iwl4965_init_geos Channel 153 Freq=3D5765[5.2GHz] valid flag=3D06
iwl4965: U iwl4965_init_geos Channel 157 Freq=3D5785[5.2GHz] valid flag=3D06
iwl4965: U iwl4965_init_geos Channel 161 Freq=3D5805[5.2GHz] valid flag=3D06
iwl4965: U iwl4965_init_geos Channel 165 Freq=3D5825[5.2GHz] valid flag=3D06
iwl4965: Tunable channels: 11 802.11bg, 13 802.11a channels
phy5: Selected rate control algorithm 'iwl-4965-rs'
input: 4965AGN as /class/input/input15
iwl4965: U iwl4965_mac_start enter
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
iwl4965: U iwl4965_read_ucode Got firmware 'iwlwifi-4965-1.ucode' file (185=
764 bytes) from disk
iwl4965: U iwl4965_read_ucode f/w package hdr ucode version =3D 0x0
iwl4965: U iwl4965_read_ucode f/w package hdr runtime inst size =3D 0
iwl4965: U iwl4965_read_ucode f/w package hdr runtime data size =3D 0
iwl4965: U iwl4965_read_ucode f/w package hdr init inst size =3D 0
iwl4965: U iwl4965_read_ucode f/w package hdr init data size =3D 0
iwl4965: U iwl4965_read_ucode f/w package hdr boot inst size =3D 0
iwl4965: U iwl4965_read_ucode Copying (but not loading) uCode instr len 0
iwl4965: U iwl4965_read_ucode uCode instr buf vaddr =3D 0x00000000, paddr =
=3D 0x00000000
iwl4965: U iwl4965_read_ucode Copying (but not loading) uCode data len 0
iwl4965: U iwl4965_read_ucode Copying (but not loading) boot instr len 0
iwl4965: ucode not available for device bringup
iwl4965: U iwl4965_mac_start leave - failed
iwl4965: U iwl4965_mac_start enter
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
iwl4965: U iwl4965_read_ucode Got firmware 'iwlwifi-4965-1.ucode' file (185=
764 bytes) from disk
iwl4965: U iwl4965_read_ucode f/w package hdr ucode version =3D 0xb8818803
iwl4965: U iwl4965_read_ucode f/w package hdr runtime inst size =3D 4869757=
47
iwl4965: U iwl4965_read_ucode f/w package hdr runtime data size =3D 3707774=
082
iwl4965: U iwl4965_read_ucode f/w package hdr init inst size =3D 2058345986
iwl4965: U iwl4965_read_ucode f/w package hdr init data size =3D 1911124106
iwl4965: U iwl4965_read_ucode f/w package hdr boot inst size =3D 604664682
iwl4965: U iwl4965_read_ucode uCode file size 185764 too small
iwl4965: Could not read microcode: -22
iwl4965: U iwl4965_mac_start leave - failed
iwl4965: U iwl4965_mac_start enter
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
iwl4965: U iwl4965_read_ucode Got firmware 'iwlwifi-4965-1.ucode' file (185=
764 bytes) from disk
iwl4965: U iwl4965_read_ucode f/w package hdr ucode version =3D 0x42c0114
iwl4965: U iwl4965_read_ucode f/w package hdr runtime inst size =3D 92720
iwl4965: U iwl4965_read_ucode f/w package hdr runtime data size =3D 40960
iwl4965: U iwl4965_read_ucode f/w package hdr init inst size =3D 10312
iwl4965: U iwl4965_read_ucode f/w package hdr init data size =3D 40960
iwl4965: U iwl4965_read_ucode f/w package hdr boot inst size =3D 788
iwl4965: U iwl4965_read_ucode Copying (but not loading) uCode instr len 927=
20
iwl4965: U iwl4965_read_ucode uCode instr buf vaddr =3D 0xf6960000, paddr =
=3D 0x36960000
iwl4965: U iwl4965_read_ucode Copying (but not loading) uCode data len 40960
iwl4965: U iwl4965_read_ucode Copying (but not loading) init instr len 10312
iwl4965: U iwl4965_read_ucode Copying (but not loading) init data len 40960
iwl4965: U iwl4965_read_ucode Copying (but not loading) boot instr len 788
iwl4965: U iwl4965_power_init_handle Initialize power=20
iwl4965: U iwl4965_power_init_handle adjust power command flags
iwl4965: U iwl4965_hw_nic_init HW Revision ID =3D 0x61
iwl4965: U iwl4965_hw_card_show_info 4965ABGN HW Version 0.0.209
iwl4965: U iwl4965_hw_card_show_info 4965ABGN PBA Number 4667005
iwl4965: U iwl4965_load_bsm Begin load bsm
iwl4965: U iwl4965_verify_bsm Begin verify bsm
iwl4965: U iwl4965_verify_bsm BSM bootstrap uCode image OK
iwl4965: U iwl4965_load_bsm BSM write complete, poll 1 iterations
iwl4965: U __iwl4965_up iwl4965 is coming up
iwl4965: U iwl4965_mac_start Start UP work done.
iwl4965: Wait for START_ALIVE timeout after 2000ms.
iwl4965: U iwl4965_mac_start leave - failed
iwl4965: U iwl4965_mac_start enter
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
iwl4965: U iwl4965_power_init_handle Initialize power=20
iwl4965: U iwl4965_power_init_handle adjust power command flags
iwl4965: U iwl4965_hw_nic_init HW Revision ID =3D 0x61
iwl4965: U iwl4965_hw_card_show_info 4965ABGN HW Version 0.0.209
iwl4965: U iwl4965_hw_card_show_info 4965ABGN PBA Number 4667005
iwl4965: U iwl4965_load_bsm Begin load bsm
iwl4965: U iwl4965_verify_bsm Begin verify bsm
iwl4965: U iwl4965_verify_bsm BSM bootstrap uCode image OK
iwl4965: U iwl4965_load_bsm BSM write complete, poll 1 iterations
iwl4965: U __iwl4965_up iwl4965 is coming up
iwl4965: U iwl4965_mac_start Start UP work done.
iwl4965: Wait for START_ALIVE timeout after 2000ms.
iwl4965: U iwl4965_mac_start leave - failed

-m
--=20
Mike Kershaw/Dragorn <dragorn@kismetwireless.net>
GPG Fingerprint: 3546 89DF 3C9D ED80 3381  A661 D7B2 8822 738B BDB1

Experts in ancient Greek culture say that people back then didn't see their
thoughts as belonging to them.  When they had a thought, it occurred to them
as a god or goddess giving them an order.  Apollo was telling them to be
brave.  Athena was telling them to fall in love.

Now people hear a commercial for sour cream potato chips and rush out to bu=
y.
	-- Chuck Palahniuk

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkgBk+wACgkQ17KIInOLvbHuwgCcDbqPTJuKlP+ks1nw5jdZWTqa
FAgAn3pyR/jG7E+Urd/QIHsh3auAlniR
=nJlE
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
