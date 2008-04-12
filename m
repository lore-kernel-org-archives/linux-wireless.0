Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from durandal.kismetwireless.net ([199.201.145.179]:54955 "EHLO
	durandal.nerv-un.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbYDLPfM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Apr 2008 11:35:12 -0400
Date: Sat, 12 Apr 2008 11:34:17 -0400
From: Mike Kershaw <dragorn@kismetwireless.net>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Kismet shows no clients (drivers iwl3945.ko or p54pci.ko)
Message-ID: <20080412153417.GA11886@drd1813.lan> (sfid-20080412_163606_530291_CAD0F4D5)
Reply-To: Mike Kershaw <dragorn@kismetwireless.net>
References: <47FDF732.7000304@interia.pl> <20080410181612.GB23971@drd1813.lan> <D936D925018D154694D8A362EEB089200428A22D@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
In-Reply-To: <D936D925018D154694D8A362EEB089200428A22D@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 11, 2008 at 07:50:33AM -0700, Chatre, Reinette wrote:
> Could you please load the driver with debugging (modprobe iwl4965
> debug=3D0x43fff) to help us get a better idea what is going on.

Tried the tests with v2.6.25-rc8-4580-g814c885, dmesg follows.
Rfmon doesn't work, but no kernel panic.  With this git tree, reloading
the module works to restore managed mode, instead of crashing.

[ Boot, wpa_supplicant starting ]

EXT3-fs: mounted filesystem with ordered data mode.
ACPI: PCI interrupt for device 0000:03:00.0 disabled
iwl4965: No space for Tx
iwl4965: Error sending REPLY_CARD_STATE_CMD: enqueue_hcmd failed: -28
iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.2.26kds
iwl4965: Copyright(c) 2003-2008 Intel Corporation
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:03:00.0 to 64
iwl4965: U iwl4965_pci_probe pci_resource_len =3D 0x00002000
iwl4965: U iwl4965_pci_probe pci_resource_base =3D f8a60000
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
phy1: Selected rate control algorithm 'iwl-4965-rs'
input: 4965AGN as /class/input/input11
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
iwl4965: U iwl4965_read_ucode uCode instr buf vaddr =3D 0xf6240000, paddr =
=3D 0x36240000
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
iwl4965: I iwl4965_rx_handle r =3D 1, i =3D 0, REPLY_ALIVE, 0x01
iwl4965: I iwl4965_rx_reply_alive Alive ucode status 0x00000001 revision 0x=
1 0x9
iwl4965: I iwl4965_rx_reply_alive Initialization Alive received.
iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 788
iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 10312
iwl4965: U iwl4965_verify_ucode Initialize uCode is good in inst SRAM
iwl4965: U iwl4965_get_temperature Running temperature calibration
iwl4965: U iwl4965_get_temperature Calib values R[1-3]: -144 13424 -13590 R=
4: -3218
iwl4965: U iwl4965_get_temperature Calibrated temperature: 318K, 45C
iwl4965: U iwl4965_init_alive_start Initialization Alive received.
iwl4965: U iwl4965_set_ucode_ptrs Runtime uCode pointers are set.
iwl4965: I iwl4965_rx_handle r =3D 2, i =3D 1, REPLY_ALIVE, 0x01
iwl4965: I iwl4965_rx_reply_alive Alive ucode status 0x00000001 revision 0x=
1 0x0
iwl4965: I iwl4965_rx_reply_alive Runtime Alive received.
iwl4965: U iwl4965_alive_start Runtime Alive received.
iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 788
iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 10312
iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 92720
iwl4965: U iwl4965_verify_ucode Runtime uCode is good in inst SRAM
iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 0 on AC 3
iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 1 on AC 2
iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 2 on AC 1
iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 3 on AC 0
iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 4 on AC 4
iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 5 on AC 5
iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 6 on AC 6
iwl4965: U iwl4965_update_power_cmd Flags value =3D 0x00000000
iwl4965: U iwl4965_update_power_cmd Tx timeout =3D 0
iwl4965: U iwl4965_update_power_cmd Rx timeout =3D 0
iwl4965: U iwl4965_update_power_cmd Sleep interval vector =3D { 0 , 0 , 0 ,=
 0 , 0 }
iwl4965: U iwl4965_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq:=
 0x0400, 40 bytes at 0[0]:4
iwl4965: I iwl4965_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD,=
 0x77
iwl4965: U iwl4965_set_rxon_chain rx chain 280E
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq:=
 0x0401, 16 bytes at 1[1]:4
iwl4965: I iwl4965_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG,=
 0x9b
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0402, 28 bytes at 2[2]:4
iwl4965: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:00:00:00:00:00
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x04=
03, 48 bytes at 3[3]:4
iwl4965: I iwl4965_rx_handle r 5 i 4 No handler needed for SENSITIVITY_CMD,=
 0xa8
iwl4965: I iwl4965_rx_handle r 6 i 5 No handler needed for REPLY_RXON, 0x10
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0404, 28 bytes at 4[4]:4
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97=
), seq: 0x0405, 140 bytes at 5[5]:4
iwl4965: I iwl4965_rx_handle r 8 i 6 No handler needed for SENSITIVITY_CMD,=
 0xa8
iwl4965: I iwl4965_rx_handle r 8 i 7 No handler needed for REPLY_TX_PWR_TAB=
LE_CMD, 0x97
iwl4965: U iwl4965_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0=
x0406, 72 bytes at 6[6]:4
iwl4965: I iwl4965_rx_handle r =3D 9, i =3D 8, REPLY_ADD_STA, 0x18
iwl4965: U iwl4965_send_add_station REPLY_ADD_STA PASSED
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (=
#4e), seq: 0x0407, 92 bytes at 7[7]:4
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_CT_KILL_CONFIG_CMD (#=
a4), seq: 0x0408, 16 bytes at 8[8]:4
iwl4965: I iwl4965_rx_handle r 11 i 9 No handler needed for REPLY_TX_LINK_Q=
UALITY_CMD, 0x4e
iwl4965: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x=
00000000)
iwl4965: I iwl4965_rx_handle r 11 i 10 No handler needed for REPLY_CT_KILL_=
CONFIG_CMD, 0xa4
iwl4965: U iwl4965_rf_kill_ct_config REPLY_CT_KILL_CONFIG_CMD succeeded
iwl4965: U iwl4965_alive_start ALIVE processing complete.
iwl4965: U iwl4965_mac_start leave
iwl4965: U iwl4965_mac_add_interface enter: type 2
Registered led device: iwl-phy1:radio
Registered led device: iwl-phy1:assoc
Registered led device: iwl-phy1:RX
Registered led device: iwl-phy1:TX
iwl4965: U iwl4965_mac_add_interface Set 00:13:e8:92:3f:cb
iwl4965: U iwl4965_set_rxon_chain rx chain 280E
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0409, 28 bytes at 9[9]:4
iwl4965: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:00:00:00:00:00
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x04=
0A, 48 bytes at 10[10]:4
iwl4965: I iwl4965_rx_handle r 13 i 11 No handler needed for SENSITIVITY_CM=
D, 0xa8
iwl4965: I iwl4965_rx_handle r 13 i 12 No handler needed for REPLY_RXON, 0x=
10
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x040B, 28 bytes at 11[11]:4
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97=
), seq: 0x040C, 140 bytes at 12[12]:4
iwl4965: I iwl4965_rx_handle r 15 i 13 No handler needed for SENSITIVITY_CM=
D, 0xa8
iwl4965: I iwl4965_rx_handle r 15 i 14 No handler needed for REPLY_TX_PWR_T=
ABLE_CMD, 0x97
iwl4965: U iwl4965_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0=
x040D, 72 bytes at 13[13]:4
iwl4965: I iwl4965_rx_handle r =3D 16, i =3D 15, REPLY_ADD_STA, 0x18
iwl4965: U iwl4965_send_add_station REPLY_ADD_STA PASSED
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (=
#4e), seq: 0x040E, 92 bytes at 14[14]:4
iwl4965: U iwl4965_mac_add_interface leave
iwl4965: U iwl4965_mac_config_interface bssid: 00:00:00:00:00:00
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x040F, 28 bytes at 15[15]:4
iwl4965: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:00:00:00:00:00
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x04=
10, 48 bytes at 16[16]:4
iwl4965: I iwl4965_rx_handle r 19 i 16 No handler needed for REPLY_TX_LINK_=
QUALITY_CMD, 0x4e
iwl4965: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x=
00000000)
iwl4965: I iwl4965_rx_handle r 19 i 17 No handler needed for SENSITIVITY_CM=
D, 0xa8
iwl4965: I iwl4965_rx_handle r 19 i 18 No handler needed for REPLY_RXON, 0x=
10
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0411, 28 bytes at 17[17]:4
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97=
), seq: 0x0412, 140 bytes at 18[18]:4
iwl4965: I iwl4965_rx_handle r 21 i 19 No handler needed for SENSITIVITY_CM=
D, 0xa8
iwl4965: I iwl4965_rx_handle r 21 i 20 No handler needed for REPLY_TX_PWR_T=
ABLE_CMD, 0x97
iwl4965: U iwl4965_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0=
x0413, 72 bytes at 19[19]:4
iwl4965: I iwl4965_rx_handle r =3D 22, i =3D 21, REPLY_ADD_STA, 0x18
iwl4965: U iwl4965_send_add_station REPLY_ADD_STA PASSED
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (=
#4e), seq: 0x0414, 92 bytes at 20[20]:4
iwl4965: U iwl4965_mac_config_interface leave
iwl4965: U iwl4965_mac_config enter to channel 1
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0415, 28 bytes at 21[21]:4
iwl4965: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:00:00:00:00:00
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x04=
16, 48 bytes at 22[22]:4
iwl4965: I iwl4965_rx_handle r 25 i 22 No handler needed for REPLY_TX_LINK_=
QUALITY_CMD, 0x4e
iwl4965: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x=
00000000)
iwl4965: I iwl4965_rx_handle r 25 i 23 No handler needed for SENSITIVITY_CM=
D, 0xa8
iwl4965: I iwl4965_rx_handle r 25 i 24 No handler needed for REPLY_RXON, 0x=
10
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0417, 28 bytes at 23[23]:4
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97=
), seq: 0x0418, 140 bytes at 24[24]:4
iwl4965: I iwl4965_rx_handle r 27 i 25 No handler needed for SENSITIVITY_CM=
D, 0xa8
iwl4965: I iwl4965_rx_handle r 27 i 26 No handler needed for REPLY_TX_PWR_T=
ABLE_CMD, 0x97
iwl4965: U iwl4965_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0=
x0419, 72 bytes at 25[25]:4
iwl4965: I iwl4965_rx_handle r =3D 28, i =3D 27, REPLY_ADD_STA, 0x18
iwl4965: U iwl4965_send_add_station REPLY_ADD_STA PASSED
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (=
#4e), seq: 0x041A, 92 bytes at 26[26]:4
iwl4965: U iwl4965_mac_config leave
ADDRCONF(NETDEV_UP): wlan0: link is not ready
iwl4965: I iwl4965_rx_handle r 29 i 28 No handler needed for REPLY_TX_LINK_=
QUALITY_CMD, 0x4e
iwl4965: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x=
00000000)
iwl4965: U iwl4965_mac_hw_scan enter
iwl4965: U iwl4965_scan_initiate Starting scan...
iwl4965: U iwl4965_mac_hw_scan leave
iwl4965: U iwl4965_bg_request_scan Initiating indirect scan.
iwl4965: U iwl4965_get_channels_for_scan Scanning 1 [PASSIVE 120]
iwl4965: U iwl4965_get_channels_for_scan Scanning 2 [PASSIVE 120]
iwl4965: U iwl4965_get_channels_for_scan Scanning 3 [PASSIVE 120]
iwl4965: U iwl4965_get_channels_for_scan Scanning 4 [PASSIVE 120]
iwl4965: U iwl4965_get_channels_for_scan Scanning 5 [PASSIVE 120]
iwl4965: U iwl4965_get_channels_for_scan Scanning 6 [PASSIVE 120]
iwl4965: U iwl4965_get_channels_for_scan Scanning 7 [PASSIVE 120]
iwl4965: U iwl4965_get_channels_for_scan Scanning 8 [PASSIVE 120]
iwl4965: U iwl4965_get_channels_for_scan Scanning 9 [PASSIVE 120]
iwl4965: U iwl4965_get_channels_for_scan Scanning 10 [PASSIVE 120]
iwl4965: U iwl4965_get_channels_for_scan Scanning 11 [PASSIVE 120]
iwl4965: U iwl4965_get_channels_for_scan total channels to scan 11=20
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: =
0x441B, 382 bytes at 27[32]:4
iwl4965: I iwl4965_rx_handle r =3D 32, i =3D 29, REPLY_SCAN_CMD, 0x80
iwl4965: I iwl4965_rx_handle r =3D 32, i =3D 30, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: =
0x041C, 12 bytes at 28[28]:4
iwl4965: I iwl4965_get_temperature Running temperature calibration
iwl4965: I iwl4965_get_temperature Calib values R[1-3]: -144 13424 -13590 R=
4: -3218
iwl4965: I iwl4965_get_temperature Calibrated temperature: 318K, 45C
iwl4965: I iwl4965_rx_handle r =3D 32, i =3D 31, SCAN_START_NOTIFICATION, 0=
x82
iwl4965: I iwl4965_rx_scan_start_notif Scan start: 1 [802.11bg] (TSF: 0x000=
00000:0002A308) - 1 (beacon timer 4226296)
iwl4965: I iwl4965_rx_handle r 33 i 32 No handler needed for REPLY_LEDS_CMD=
, 0x48
iwl4965: I iwl4965_rx_handle r =3D 36, i =3D 33, SCAN_RESULTS_NOTIFICATION,=
 0x83
iwl4965: I iwl4965_rx_scan_results_notif Scan ch.res: 1 [802.11bg] (TSF: 0x=
00000000:0004832E) - 0 elapsed=3D122918 usec (-226492ms since last)
iwl4965: I iwl4965_rx_handle r =3D 36, i =3D 34, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 36, i =3D 35, SCAN_START_NOTIFICATION, 0=
x82
iwl4965: I iwl4965_rx_scan_start_notif Scan start: 2 [802.11bg] (TSF: 0x000=
00000:00048492) - 1 (beacon timer 8399726)
iwl4965: I iwl4965_rx_handle r =3D 39, i =3D 36, SCAN_RESULTS_NOTIFICATION,=
 0x83
iwl4965: I iwl4965_rx_scan_results_notif Scan ch.res: 2 [802.11bg] (TSF: 0x=
00000000:000664BC) - 0 elapsed=3D122922 usec (123ms since last)
iwl4965: I iwl4965_rx_handle r =3D 39, i =3D 37, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 39, i =3D 38, SCAN_START_NOTIFICATION, 0=
x82
iwl4965: I iwl4965_rx_scan_start_notif Scan start: 3 [802.11bg] (TSF: 0x000=
00000:00066620) - 1 (beacon timer 16869856)
iwl4965: I iwl4965_rx_handle r =3D 42, i =3D 39, SCAN_RESULTS_NOTIFICATION,=
 0x83
iwl4965: I iwl4965_rx_scan_results_notif Scan ch.res: 3 [802.11bg] (TSF: 0x=
00000000:00084643) - 0 elapsed=3D122915 usec (123ms since last)
iwl4965: I iwl4965_rx_handle r =3D 42, i =3D 40, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 42, i =3D 41, SCAN_START_NOTIFICATION, 0=
x82
iwl4965: I iwl4965_rx_scan_start_notif Scan start: 4 [802.11bg] (TSF: 0x000=
00000:000847A7) - 1 (beacon timer 21043289)
iwl4965: I iwl4965_rx_handle r =3D 43, i =3D 42, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 44, i =3D 43, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 47, i =3D 44, SCAN_RESULTS_NOTIFICATION,=
 0x83
iwl4965: I iwl4965_rx_scan_results_notif Scan ch.res: 4 [802.11bg] (TSF: 0x=
00000000:000A29E3) - 2 elapsed=3D123452 usec (124ms since last)
iwl4965: I iwl4965_rx_handle r =3D 47, i =3D 45, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 47, i =3D 46, SCAN_START_NOTIFICATION, 0=
x82
iwl4965: I iwl4965_rx_scan_start_notif Scan start: 5 [802.11bg] (TSF: 0x000=
00000:000A2B47) - 1 (beacon timer 25216185)
iwl4965: I iwl4965_rx_handle r =3D 48, i =3D 47, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 49, i =3D 48, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 52, i =3D 49, SCAN_RESULTS_NOTIFICATION,=
 0x83
iwl4965: I iwl4965_rx_scan_results_notif Scan ch.res: 5 [802.11bg] (TSF: 0x=
00000000:000C0B6D) - 2 elapsed=3D122918 usec (123ms since last)
iwl4965: I iwl4965_rx_handle r =3D 52, i =3D 50, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 52, i =3D 51, SCAN_START_NOTIFICATION, 0=
x82
iwl4965: I iwl4965_rx_scan_start_notif Scan start: 6 [802.11bg] (TSF: 0x000=
00000:000C0CD1) - 1 (beacon timer 29389615)
iwl4965: I iwl4965_rx_handle r =3D 53, i =3D 52, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 54, i =3D 53, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 55, i =3D 54, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 58, i =3D 55, SCAN_RESULTS_NOTIFICATION,=
 0x83
iwl4965: I iwl4965_rx_scan_results_notif Scan ch.res: 6 [802.11bg] (TSF: 0x=
00000000:000DECEB) - 3 elapsed=3D122906 usec (124ms since last)
iwl4965: I iwl4965_rx_handle r =3D 58, i =3D 56, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 58, i =3D 57, SCAN_START_NOTIFICATION, 0=
x82
iwl4965: I iwl4965_rx_scan_start_notif Scan start: 7 [802.11bg] (TSF: 0x000=
00000:000DEE4F) - 1 (beacon timer 33563057)
iwl4965: I iwl4965_rx_handle r =3D 59, i =3D 58, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 60, i =3D 59, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 61, i =3D 60, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 62, i =3D 61, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 65, i =3D 62, SCAN_RESULTS_NOTIFICATION,=
 0x83
iwl4965: I iwl4965_rx_scan_results_notif Scan ch.res: 7 [802.11bg] (TSF: 0x=
00000000:000FCE77) - 4 elapsed=3D122920 usec (123ms since last)
iwl4965: I iwl4965_rx_handle r =3D 65, i =3D 63, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 65, i =3D 64, SCAN_START_NOTIFICATION, 0=
x82
iwl4965: I iwl4965_rx_scan_start_notif Scan start: 8 [802.11bg] (TSF: 0x000=
00000:000FCFDB) - 1 (beacon timer 42033189)
iwl4965: I iwl4965_rx_handle r =3D 66, i =3D 65, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 67, i =3D 66, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 70, i =3D 67, SCAN_RESULTS_NOTIFICATION,=
 0x83
iwl4965: I iwl4965_rx_scan_results_notif Scan ch.res: 8 [802.11bg] (TSF: 0x=
00000000:0011AFF3) - 2 elapsed=3D122904 usec (123ms since last)
iwl4965: I iwl4965_rx_handle r =3D 70, i =3D 68, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 70, i =3D 69, SCAN_START_NOTIFICATION, 0=
x82
iwl4965: I iwl4965_rx_scan_start_notif Scan start: 9 [802.11bg] (TSF: 0x000=
00000:0011B157) - 1 (beacon timer 46206633)
iwl4965: I iwl4965_rx_handle r =3D 73, i =3D 70, SCAN_RESULTS_NOTIFICATION,=
 0x83
iwl4965: I iwl4965_rx_scan_results_notif Scan ch.res: 9 [802.11bg] (TSF: 0x=
00000000:00139174) - 0 elapsed=3D122909 usec (124ms since last)
iwl4965: I iwl4965_rx_handle r =3D 73, i =3D 71, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 73, i =3D 72, SCAN_START_NOTIFICATION, 0=
x82
iwl4965: I iwl4965_rx_scan_start_notif Scan start: 10 [802.11bg] (TSF: 0x00=
000000:001392D8) - 1 (beacon timer 50380072)
iwl4965: I iwl4965_rx_handle r =3D 74, i =3D 73, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 77, i =3D 74, SCAN_RESULTS_NOTIFICATION,=
 0x83
iwl4965: I iwl4965_rx_scan_results_notif Scan ch.res: 10 [802.11bg] (TSF: 0=
x00000000:001572FA) - 1 elapsed=3D122914 usec (123ms since last)
iwl4965: I iwl4965_rx_handle r =3D 77, i =3D 75, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 77, i =3D 76, SCAN_START_NOTIFICATION, 0=
x82
iwl4965: I iwl4965_rx_scan_start_notif Scan start: 11 [802.11bg] (TSF: 0x00=
000000:0015745F) - 1 (beacon timer 54553505)
iwl4965: I iwl4965_rx_handle r =3D 78, i =3D 77, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 81, i =3D 78, SCAN_RESULTS_NOTIFICATION,=
 0x83
iwl4965: I iwl4965_rx_scan_results_notif Scan ch.res: 11 [802.11bg] (TSF: 0=
x00000000:0017547C) - 1 elapsed=3D122909 usec (123ms since last)
iwl4965: I iwl4965_rx_handle r =3D 81, i =3D 79, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 81, i =3D 80, SCAN_COMPLETE_NOTIFICATION=
, 0x84
iwl4965: I iwl4965_rx_scan_complete_notif Scan complete: 11 channels (TSF 0=
x001755FD:00000000) - 1
iwl4965: I iwl4965_rx_scan_complete_notif Scan pass on 2.4GHz took 1357ms
iwl4965: U iwl4965_bg_request_scan Initiating indirect scan.
iwl4965: U iwl4965_get_channels_for_scan Scanning 36 [PASSIVE 110]
iwl4965: U iwl4965_get_channels_for_scan Scanning 40 [PASSIVE 110]
iwl4965: U iwl4965_get_channels_for_scan Scanning 44 [PASSIVE 110]
iwl4965: U iwl4965_get_channels_for_scan Scanning 48 [PASSIVE 110]
iwl4965: U iwl4965_get_channels_for_scan Scanning 52 [PASSIVE 110]
iwl4965: U iwl4965_get_channels_for_scan Scanning 56 [PASSIVE 110]
iwl4965: U iwl4965_get_channels_for_scan Scanning 60 [PASSIVE 110]
iwl4965: U iwl4965_get_channels_for_scan Scanning 64 [PASSIVE 110]
iwl4965: U iwl4965_get_channels_for_scan Scanning 149 [PASSIVE 110]
iwl4965: U iwl4965_get_channels_for_scan Scanning 153 [PASSIVE 110]
iwl4965: U iwl4965_get_channels_for_scan Scanning 157 [PASSIVE 110]
iwl4965: U iwl4965_get_channels_for_scan Scanning 161 [PASSIVE 110]
iwl4965: U iwl4965_get_channels_for_scan Scanning 165 [PASSIVE 110]
iwl4965: U iwl4965_get_channels_for_scan total channels to scan 13=20
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: =
0x441D, 398 bytes at 29[32]:4
iwl4965: I iwl4965_rx_handle r =3D 84, i =3D 81, REPLY_SCAN_CMD, 0x80
iwl4965: I iwl4965_rx_handle r =3D 84, i =3D 82, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 84, i =3D 83, SCAN_START_NOTIFICATION, 0=
x82
iwl4965: I iwl4965_rx_scan_start_notif Scan start: 36 [802.11a] (TSF: 0x000=
00000:00175968) - 1 (beacon timer 58726040)
iwl4965: I iwl4965_rx_handle r =3D 87, i =3D 84, SCAN_RESULTS_NOTIFICATION,=
 0x83
iwl4965: I iwl4965_rx_scan_results_notif Scan ch.res: 36 [802.11a] (TSF: 0x=
00000000:00191190) - 0 elapsed=3D112680 usec (114ms since last)
iwl4965: I iwl4965_rx_handle r =3D 87, i =3D 85, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 87, i =3D 86, SCAN_START_NOTIFICATION, 0=
x82
iwl4965: I iwl4965_rx_scan_start_notif Scan start: 40 [802.11a] (TSF: 0x000=
00000:001912F3) - 1 (beacon timer 67206413)
iwl4965: I iwl4965_rx_handle r =3D 90, i =3D 87, SCAN_RESULTS_NOTIFICATION,=
 0x83
iwl4965: I iwl4965_rx_scan_results_notif Scan ch.res: 40 [802.11a] (TSF: 0x=
00000000:001ACB1D) - 0 elapsed=3D112682 usec (113ms since last)
iwl4965: I iwl4965_rx_handle r =3D 90, i =3D 88, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 90, i =3D 89, SCAN_START_NOTIFICATION, 0=
x82
iwl4965: I iwl4965_rx_scan_start_notif Scan start: 44 [802.11a] (TSF: 0x000=
00000:001ACC80) - 1 (beacon timer 71390080)
iwl4965: I iwl4965_rx_handle r =3D 93, i =3D 90, SCAN_RESULTS_NOTIFICATION,=
 0x83
iwl4965: I iwl4965_rx_scan_results_notif Scan ch.res: 44 [802.11a] (TSF: 0x=
00000000:001C84AA) - 0 elapsed=3D112682 usec (113ms since last)
iwl4965: I iwl4965_rx_handle r =3D 93, i =3D 91, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 93, i =3D 92, SCAN_START_NOTIFICATION, 0=
x82
iwl4965: I iwl4965_rx_scan_start_notif Scan start: 48 [802.11a] (TSF: 0x000=
00000:001C860D) - 1 (beacon timer 75573747)
iwl4965: I iwl4965_rx_handle r =3D 96, i =3D 93, SCAN_RESULTS_NOTIFICATION,=
 0x83
iwl4965: I iwl4965_rx_scan_results_notif Scan ch.res: 48 [802.11a] (TSF: 0x=
00000000:001E3E38) - 0 elapsed=3D112683 usec (113ms since last)
iwl4965: I iwl4965_rx_handle r =3D 96, i =3D 94, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 96, i =3D 95, SCAN_START_NOTIFICATION, 0=
x82
iwl4965: I iwl4965_rx_scan_start_notif Scan start: 52 [802.11a] (TSF: 0x000=
00000:001E3F9C) - 1 (beacon timer 79757412)
iwl4965: I iwl4965_rx_handle r =3D 99, i =3D 96, SCAN_RESULTS_NOTIFICATION,=
 0x83
iwl4965: I iwl4965_rx_scan_results_notif Scan ch.res: 52 [802.11a] (TSF: 0x=
00000000:001FF7C6) - 0 elapsed=3D112682 usec (113ms since last)
iwl4965: I iwl4965_rx_handle r =3D 99, i =3D 97, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 99, i =3D 98, SCAN_START_NOTIFICATION, 0=
x82
iwl4965: I iwl4965_rx_scan_start_notif Scan start: 56 [802.11a] (TSF: 0x000=
00000:001FF92A) - 1 (beacon timer 83941078)
iwl4965: I iwl4965_rx_handle r =3D 102, i =3D 99, SCAN_RESULTS_NOTIFICATION=
, 0x83
iwl4965: I iwl4965_rx_scan_results_notif Scan ch.res: 56 [802.11a] (TSF: 0x=
00000000:0021B154) - 0 elapsed=3D112682 usec (113ms since last)
iwl4965: I iwl4965_rx_handle r =3D 102, i =3D 100, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 102, i =3D 101, SCAN_START_NOTIFICATION,=
 0x82
iwl4965: I iwl4965_rx_scan_start_notif Scan start: 60 [802.11a] (TSF: 0x000=
00000:0021B2B8) - 1 (beacon timer 88124744)
iwl4965: I iwl4965_rx_handle r =3D 105, i =3D 102, SCAN_RESULTS_NOTIFICATIO=
N, 0x83
iwl4965: I iwl4965_rx_scan_results_notif Scan ch.res: 60 [802.11a] (TSF: 0x=
00000000:00236AE2) - 0 elapsed=3D112682 usec (113ms since last)
iwl4965: I iwl4965_rx_handle r =3D 105, i =3D 103, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 105, i =3D 104, SCAN_START_NOTIFICATION,=
 0x82
iwl4965: I iwl4965_rx_scan_start_notif Scan start: 64 [802.11a] (TSF: 0x000=
00000:00236C46) - 1 (beacon timer 92308410)
iwl4965: I iwl4965_rx_handle r =3D 108, i =3D 105, SCAN_RESULTS_NOTIFICATIO=
N, 0x83
iwl4965: I iwl4965_rx_scan_results_notif Scan ch.res: 64 [802.11a] (TSF: 0x=
00000000:00252470) - 0 elapsed=3D112682 usec (113ms since last)
iwl4965: I iwl4965_rx_handle r =3D 108, i =3D 106, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 108, i =3D 107, SCAN_START_NOTIFICATION,=
 0x82
iwl4965: I iwl4965_rx_scan_start_notif Scan start: 149 [802.11a] (TSF: 0x00=
000000:002525D6) - 1 (beacon timer 96492074)
iwl4965: I iwl4965_rx_handle r =3D 111, i =3D 108, SCAN_RESULTS_NOTIFICATIO=
N, 0x83
iwl4965: I iwl4965_rx_scan_results_notif Scan ch.res: 149 [802.11a] (TSF: 0=
x00000000:0026DDFA) - 0 elapsed=3D112676 usec (113ms since last)
iwl4965: I iwl4965_rx_handle r =3D 111, i =3D 109, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 111, i =3D 110, SCAN_START_NOTIFICATION,=
 0x82
iwl4965: I iwl4965_rx_scan_start_notif Scan start: 153 [802.11a] (TSF: 0x00=
000000:0026DF60) - 1 (beacon timer 100675744)
iwl4965: I iwl4965_rx_handle r =3D 112, i =3D 111, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 113, i =3D 112, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 116, i =3D 113, SCAN_RESULTS_NOTIFICATIO=
N, 0x83
iwl4965: I iwl4965_rx_scan_results_notif Scan ch.res: 153 [802.11a] (TSF: 0=
x00000000:00289781) - 2 elapsed=3D112673 usec (113ms since last)
iwl4965: I iwl4965_rx_handle r =3D 116, i =3D 114, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 116, i =3D 115, SCAN_START_NOTIFICATION,=
 0x82
iwl4965: I iwl4965_rx_scan_start_notif Scan start: 157 [802.11a] (TSF: 0x00=
000000:002898E7) - 1 (beacon timer 104859417)
iwl4965: I iwl4965_rx_handle r =3D 119, i =3D 116, SCAN_RESULTS_NOTIFICATIO=
N, 0x83
iwl4965: I iwl4965_rx_scan_results_notif Scan ch.res: 157 [802.11a] (TSF: 0=
x00000000:002A5111) - 0 elapsed=3D112682 usec (113ms since last)
iwl4965: I iwl4965_rx_handle r =3D 119, i =3D 117, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 119, i =3D 118, SCAN_START_NOTIFICATION,=
 0x82
iwl4965: I iwl4965_rx_scan_start_notif Scan start: 161 [802.11a] (TSF: 0x00=
000000:002A5277) - 1 (beacon timer 113339785)
iwl4965: I iwl4965_rx_handle r =3D 122, i =3D 119, SCAN_RESULTS_NOTIFICATIO=
N, 0x83
iwl4965: I iwl4965_rx_scan_results_notif Scan ch.res: 161 [802.11a] (TSF: 0=
x00000000:002C0AA1) - 0 elapsed=3D112682 usec (113ms since last)
iwl4965: I iwl4965_rx_handle r =3D 122, i =3D 120, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 122, i =3D 121, SCAN_START_NOTIFICATION,=
 0x82
iwl4965: I iwl4965_rx_scan_start_notif Scan start: 165 [802.11a] (TSF: 0x00=
000000:002C0C07) - 1 (beacon timer 117523449)
iwl4965: I iwl4965_rx_handle r =3D 125, i =3D 122, SCAN_RESULTS_NOTIFICATIO=
N, 0x83
iwl4965: I iwl4965_rx_scan_results_notif Scan ch.res: 165 [802.11a] (TSF: 0=
x00000000:002DC432) - 0 elapsed=3D112683 usec (114ms since last)
iwl4965: I iwl4965_rx_handle r =3D 125, i =3D 123, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 125, i =3D 124, SCAN_COMPLETE_NOTIFICATI=
ON, 0x84
iwl4965: I iwl4965_rx_scan_complete_notif Scan complete: 13 channels (TSF 0=
x002DC5B2:00000000) - 1
iwl4965: I iwl4965_rx_scan_complete_notif Scan pass on 5.2GHz took 1471ms
iwl4965: I iwl4965_rx_scan_complete_notif Setting scan to off
iwl4965: I iwl4965_rx_scan_complete_notif Scan took 2828ms
iwl4965: U iwl4965_bg_scan_completed SCAN complete scan
iwl4965: U iwl4965_mac_config enter to channel 1
iwl4965: U iwl4965_mac_config No re-sending same RXON configuration.
iwl4965: U iwl4965_mac_config leave
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97=
), seq: 0x041E, 140 bytes at 30[30]:4
iwl4965: U iwl4965_mac_set_key enter
iwl4965: U iwl4965_mac_set_key leave - hwcrypto disabled
iwl4965: I iwl4965_rx_handle r 126 i 125 No handler needed for REPLY_TX_PWR=
_TABLE_CMD, 0x97
iwl4965: U iwl4965_mac_config enter to channel 6
iwl4965: U iwlcore_set_rxon_channel Staging channel set to 6 [0]
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x041F, 28 bytes at 31[31]:4
iwl4965: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 6
* bssid =3D 00:00:00:00:00:00
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x04=
20, 48 bytes at 32[0]:4
iwl4965: I iwl4965_rx_handle r 128 i 126 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r 128 i 127 No handler needed for REPLY_RXON, =
0x10
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0421, 28 bytes at 33[1]:4
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97=
), seq: 0x0422, 140 bytes at 34[2]:4
iwl4965: I iwl4965_rx_handle r 130 i 128 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r 130 i 129 No handler needed for REPLY_TX_PWR=
_TABLE_CMD, 0x97
iwl4965: U iwl4965_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0=
x0423, 72 bytes at 35[3]:4
iwl4965: I iwl4965_rx_handle r =3D 131, i =3D 130, REPLY_ADD_STA, 0x18
iwl4965: U iwl4965_send_add_station REPLY_ADD_STA PASSED
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (=
#4e), seq: 0x0424, 92 bytes at 36[4]:4
iwl4965: U iwl4965_mac_config leave
iwl4965: U iwl4965_mac_config_interface bssid: 00:13:10:18:a8:47
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0425, 28 bytes at 37[5]:4
iwl4965: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 6
* bssid =3D 00:13:10:18:a8:47
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x04=
26, 48 bytes at 38[6]:4
iwl4965: I iwl4965_rx_handle r 134 i 131 No handler needed for REPLY_TX_LIN=
K_QUALITY_CMD, 0x4e
iwl4965: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x=
00000000)
iwl4965: I iwl4965_rx_handle r 134 i 132 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r 134 i 133 No handler needed for REPLY_RXON, =
0x10
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0427, 28 bytes at 39[7]:4
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97=
), seq: 0x0428, 140 bytes at 40[8]:4
iwl4965: I iwl4965_rx_handle r 136 i 134 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r 136 i 135 No handler needed for REPLY_TX_PWR=
_TABLE_CMD, 0x97
iwl4965: U iwl4965_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0=
x0429, 72 bytes at 41[9]:4
iwl4965: I iwl4965_rx_handle r =3D 137, i =3D 136, REPLY_ADD_STA, 0x18
iwl4965: U iwl4965_send_add_station REPLY_ADD_STA PASSED
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (=
#4e), seq: 0x042A, 92 bytes at 42[10]:4
iwl4965: U iwl4965_mac_config_interface leave
iwl4965: U iwl4965_mac_conf_tx enter
iwl4965: U iwl4965_mac_conf_tx leave
iwl4965: U iwl4965_mac_conf_tx enter
iwl4965: U iwl4965_mac_conf_tx leave
iwl4965: U iwl4965_mac_conf_tx enter
iwl4965: U iwl4965_mac_conf_tx leave
iwl4965: U iwl4965_mac_conf_tx enter
iwl4965: U iwl4965_mac_conf_tx leave
iwl4965: U iwl4965_mac_conf_tx enter
iwl4965: U iwl4965_mac_conf_tx leave - queue >=3D AC_NUM 4
iwl4965: U iwl4965_mac_conf_tx enter
iwl4965: U iwl4965_mac_conf_tx leave - queue >=3D AC_NUM 5
iwl4965: U iwl4965_mac_reset_tsf enter
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x042B, 28 bytes at 43[11]:4
iwl4965: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 6
* bssid =3D 00:13:10:18:a8:47
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x04=
2C, 48 bytes at 44[12]:4
iwl4965: I iwl4965_rx_handle r 140 i 137 No handler needed for REPLY_TX_LIN=
K_QUALITY_CMD, 0x4e
iwl4965: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x=
00000000)
iwl4965: I iwl4965_rx_handle r 140 i 138 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r 140 i 139 No handler needed for REPLY_RXON, =
0x10
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x042D, 28 bytes at 45[13]:4
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97=
), seq: 0x042E, 140 bytes at 46[14]:4
iwl4965: I iwl4965_rx_handle r 142 i 140 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r 142 i 141 No handler needed for REPLY_TX_PWR=
_TABLE_CMD, 0x97
iwl4965: U iwl4965_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0=
x042F, 72 bytes at 47[15]:4
iwl4965: I iwl4965_rx_handle r =3D 143, i =3D 142, REPLY_ADD_STA, 0x18
iwl4965: U iwl4965_send_add_station REPLY_ADD_STA PASSED
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (=
#4e), seq: 0x0430, 92 bytes at 48[16]:4
iwl4965: U iwl4965_mac_reset_tsf leave - not in IBSS
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:13:10:18:a8:47
iwl4965: I iwl4965_mac_tx enter
iwl4965: I iwl4965_mac_tx leave
wlan0: privacy configuration mismatch and mixed-cell disabled - disassociate
iwl4965: U iwl4965_mac_config enter to channel 6
iwl4965: U iwl4965_mac_config No re-sending same RXON configuration.
iwl4965: I iwl4965_mac_tx enter
iwl4965: U iwl4965_mac_config leave
iwl4965: I iwl4965_mac_tx leave
iwl4965: U iwl4965_mac_config_interface bssid: 00:16:b6:cf:57:17
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0431, 28 bytes at 49[17]:4
iwl4965: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 6
* bssid =3D 00:16:b6:cf:57:17
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x04=
32, 48 bytes at 50[18]:4
iwl4965: I iwl4965_rx_handle r 144 i 143 No handler needed for REPLY_TX_LIN=
K_QUALITY_CMD, 0x4e
iwl4965: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x=
00000000)
iwl4965: I iwl4965_rx_handle r 146 i 144 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r 146 i 145 No handler needed for REPLY_RXON, =
0x10
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0433, 28 bytes at 51[19]:4
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97=
), seq: 0x0434, 140 bytes at 52[20]:4
iwl4965: I iwl4965_rx_handle r 150 i 146 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r 150 i 147 No handler needed for REPLY_TX_PWR=
_TABLE_CMD, 0x97
iwl4965: I iwl4965_rx_handle r =3D 150, i =3D 148, REPLY_TX, 0x1c
iwl4965: I iwl4965_rx_handle r =3D 150, i =3D 149, REPLY_TX, 0x1c
iwl4965: U iwl4965_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0=
x0435, 72 bytes at 53[21]:4
iwl4965: I iwl4965_rx_handle r =3D 152, i =3D 150, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 152, i =3D 151, REPLY_ADD_STA, 0x18
iwl4965: U iwl4965_send_add_station REPLY_ADD_STA PASSED
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (=
#4e), seq: 0x0436, 92 bytes at 54[22]:4
iwl4965: U iwl4965_mac_config_interface leave
iwl4965: U iwl4965_mac_reset_tsf enter
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0437, 28 bytes at 55[23]:4
iwl4965: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 6
* bssid =3D 00:16:b6:cf:57:17
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x04=
38, 48 bytes at 56[24]:4
iwl4965: I iwl4965_rx_handle r =3D 155, i =3D 152, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r 155 i 153 No handler needed for REPLY_TX_LIN=
K_QUALITY_CMD, 0x4e
iwl4965: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x=
00000000)
iwl4965: I iwl4965_rx_handle r 155 i 154 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r 156 i 155 No handler needed for REPLY_RXON, =
0x10
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0439, 28 bytes at 57[25]:4
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97=
), seq: 0x043A, 140 bytes at 58[26]:4
iwl4965: I iwl4965_rx_handle r 158 i 156 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r 158 i 157 No handler needed for REPLY_TX_PWR=
_TABLE_CMD, 0x97
iwl4965: U iwl4965_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0=
x043B, 72 bytes at 59[27]:4
iwl4965: I iwl4965_rx_handle r =3D 160, i =3D 158, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 160, i =3D 159, REPLY_ADD_STA, 0x18
iwl4965: U iwl4965_send_add_station REPLY_ADD_STA PASSED
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (=
#4e), seq: 0x043C, 92 bytes at 60[28]:4
iwl4965: U iwl4965_mac_reset_tsf leave - not in IBSS
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:16:b6:cf:57:17
iwl4965: I iwl4965_mac_tx enter
iwl4965: I iwl4965_mac_tx leave
iwl4965: U iwl4965_mac_reset_tsf enter
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x043D, 28 bytes at 61[29]:4
iwl4965: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 6
* bssid =3D 00:16:b6:cf:57:17
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x04=
3E, 48 bytes at 62[30]:4
iwl4965: I iwl4965_rx_handle r 164 i 160 No handler needed for REPLY_TX_LIN=
K_QUALITY_CMD, 0x4e
iwl4965: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x=
00000000)
iwl4965: I iwl4965_rx_handle r 164 i 161 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r 164 i 162 No handler needed for REPLY_RXON, =
0x10
iwl4965: I iwl4965_rx_handle r =3D 164, i =3D 163, REPLY_TX, 0x1c
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x043F, 28 bytes at 63[31]:4
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97=
), seq: 0x0440, 140 bytes at 64[0]:4
iwl4965: I iwl4965_rx_handle r 166 i 164 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r 166 i 165 No handler needed for REPLY_TX_PWR=
_TABLE_CMD, 0x97
iwl4965: U iwl4965_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0=
x0441, 72 bytes at 65[1]:4
iwl4965: I iwl4965_rx_handle r =3D 167, i =3D 166, REPLY_ADD_STA, 0x18
iwl4965: U iwl4965_send_add_station REPLY_ADD_STA PASSED
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (=
#4e), seq: 0x0442, 92 bytes at 66[2]:4
iwl4965: U iwl4965_mac_reset_tsf leave - not in IBSS
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:16:b6:cf:57:17
iwl4965: I iwl4965_mac_tx enter
iwl4965: I iwl4965_mac_tx leave
iwl4965: I iwl4965_rx_handle r 168 i 167 No handler needed for REPLY_TX_LIN=
K_QUALITY_CMD, 0x4e
iwl4965: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x=
00000000)
iwl4965: I iwl4965_rx_handle r =3D 169, i =3D 168, REPLY_TX, 0x1c
iwl4965: I iwl4965_rx_handle r =3D 170, i =3D 169, REPLY_RX, 0xc3
wlan0: RX authentication from 00:16:b6:cf:57:17 (alg=3D0 transaction=3D2 st=
atus=3D0)
wlan0: authenticated
wlan0: associate with AP 00:16:b6:cf:57:17
iwl4965: I iwl4965_mac_tx enter
iwl4965: I iwl4965_mac_tx leave
iwl4965: I iwl4965_rx_handle r =3D 171, i =3D 170, REPLY_TX, 0x1c
iwl4965: I iwl4965_rx_handle r =3D 172, i =3D 171, REPLY_RX, 0xc3
wlan0: RX AssocResp from 00:16:b6:cf:57:17 (capab=3D0x411 status=3D0 aid=3D=
2)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
iwl4965: I iwl4965_mac_tx enter
iwl4965: I iwl4965_tx_skb Dropping - !iwl4965_is_associated
iwl4965: I iwl4965_mac_tx leave
iwl4965: I iwl4965_rx_handle r =3D 173, i =3D 172, REPLY_RX, 0xc3
iwl4965: U iwl4965_bg_post_associate Associated as 2 to: 00:16:b6:cf:57:17
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0443, 28 bytes at 67[3]:4
iwl4965: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 6
* bssid =3D 00:16:b6:cf:57:17
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x04=
44, 48 bytes at 68[4]:4
iwl4965: I iwl4965_rx_handle r 175 i 173 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r 175 i 174 No handler needed for REPLY_RXON, =
0x10
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0445, 28 bytes at 69[5]:4
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97=
), seq: 0x0446, 140 bytes at 70[6]:4
iwl4965: I iwl4965_rx_handle r 177 i 175 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r 177 i 176 No handler needed for REPLY_TX_PWR=
_TABLE_CMD, 0x97
iwl4965: U iwl4965_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0=
x0447, 72 bytes at 71[7]:4
iwl4965: I iwl4965_rx_handle r =3D 178, i =3D 177, REPLY_ADD_STA, 0x18
iwl4965: U iwl4965_send_add_station REPLY_ADD_STA PASSED
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (=
#4e), seq: 0x0448, 92 bytes at 72[8]:4
iwl4965: U iwl4965_setup_rxon_timing beacon interval 100 beacon timer 10201=
1 beacon tim 0
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_RXON_TIMING (#14), se=
q: 0x0449, 24 bytes at 73[9]:4
iwl4965: I iwl4965_rx_handle r 180 i 178 No handler needed for REPLY_TX_LIN=
K_QUALITY_CMD, 0x4e
iwl4965: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x=
00000000)
iwl4965: I iwl4965_rx_handle r 180 i 179 No handler needed for REPLY_RXON_T=
IMING, 0x14
iwl4965: U iwl4965_set_rxon_chain rx chain 280E
iwl4965: U iwl4965_bg_post_associate assoc id 2 beacon interval 100
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x044A, 28 bytes at 74[10]:4
iwl4965: U iwl4965_commit_rxon Sending RXON
* with RXON_FILTER_ASSOC_MSK
* channel =3D 6
* bssid =3D 00:16:b6:cf:57:17
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x04=
4B, 48 bytes at 75[11]:4
iwl4965: I iwl4965_rx_handle r 182 i 180 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r 182 i 181 No handler needed for REPLY_RXON, =
0x10
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x044C, 28 bytes at 76[12]:4
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97=
), seq: 0x044D, 140 bytes at 77[13]:4
iwl4965: I iwl4965_rx_handle r 184 i 182 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r 184 i 183 No handler needed for REPLY_TX_PWR=
_TABLE_CMD, 0x97
iwl4965: U iwl4965_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0=
x044E, 72 bytes at 78[14]:4
iwl4965: I iwl4965_rx_handle r =3D 185, i =3D 184, REPLY_ADD_STA, 0x18
iwl4965: U iwl4965_send_add_station REPLY_ADD_STA PASSED
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (=
#4e), seq: 0x044F, 92 bytes at 79[15]:4
iwl4965: U iwl4965_add_station_flags Add STA ID 0: 00:16:b6:cf:57:17
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0=
x0450, 72 bytes at 80[16]:4
iwl4965: I iwl4965_rx_handle r 187 i 185 No handler needed for REPLY_TX_LIN=
K_QUALITY_CMD, 0x4e
iwl4965: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x=
00000000)
iwl4965: I iwl4965_rx_handle r =3D 187, i =3D 186, REPLY_ADD_STA, 0x18
iwl4965: U iwl4965_send_add_station REPLY_ADD_STA PASSED
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (=
#4e), seq: 0x0451, 92 bytes at 81[17]:4
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_PHY_CALIBRATION_CMD (=
#b0), seq: 0x0452, 12 bytes at 82[18]:4
iwl4965: I iwl4965_rx_handle r 189 i 187 No handler needed for REPLY_TX_LIN=
K_QUALITY_CMD, 0x4e
iwl4965: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x=
00000000)
iwl4965: I iwl4965_rx_handle r 189 i 188 No handler needed for REPLY_PHY_CA=
LIBRATION_CMD, 0xb0
iwl4965: I iwl_generic_cmd_callback back from REPLY_PHY_CALIBRATION_CMD (0x=
00000000)
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_QOS_PARAM (#13), seq:=
 0x0453, 40 bytes at 83[19]:4
iwl4965: I iwl4965_rx_handle r 190 i 189 No handler needed for REPLY_QOS_PA=
RAM, 0x13
iwl4965: I iwl4965_rx_handle r =3D 191, i =3D 190, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 192, i =3D 191, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_get_temperature Running temperature calibration
iwl4965: I iwl4965_get_temperature Calib values R[1-3]: -144 13424 -13590 R=
4: -3390
iwl4965: I iwl4965_get_temperature Calibrated temperature: 321K, 48C
iwl4965: I iwl4965_hw_rx_statistics Temperature changed from 45C to 48C
iwl4965: I iwl4965_is_temp_calib_needed Getting warmer, delta 321,=20
iwl4965: I iwl4965_is_temp_calib_needed Thermal txpower calib needed
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97=
), seq: 0x0454, 140 bytes at 84[20]:4
iwl4965: I iwl4965_rx_handle r 193 i 192 No handler needed for REPLY_TX_PWR=
_TABLE_CMD, 0x97
iwl4965: I iwl4965_rx_handle r =3D 194, i =3D 193, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 195, i =3D 194, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0455, 28 bytes at 85[21]:4
iwl4965: I iwl4965_rx_handle r 196 i 195 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r =3D 198, i =3D 196, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 198, i =3D 197, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0456, 28 bytes at 86[22]:4
iwl4965: I iwl4965_rx_handle r 199 i 198 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r =3D 201, i =3D 199, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 201, i =3D 200, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0457, 28 bytes at 87[23]:4
iwl4965: I iwl4965_rx_handle r =3D 203, i =3D 201, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r 203 i 202 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r =3D 204, i =3D 203, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 205, i =3D 204, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0458, 28 bytes at 88[24]:4
iwl4965: I iwl4965_rx_handle r 206 i 205 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r =3D 207, i =3D 206, MISSED_BEACONS_NOTIFICAT=
ION, 0xa2
iwl4965: I iwl4965_rx_handle r =3D 208, i =3D 207, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 209, i =3D 208, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0459, 28 bytes at 89[25]:4
iwl4965: I iwl4965_rx_handle r =3D 211, i =3D 209, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r 211 i 210 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r =3D 212, i =3D 211, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 213, i =3D 212, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 214, i =3D 213, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x045A, 28 bytes at 90[26]:4
iwl4965: I iwl4965_rx_handle r 215 i 214 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r =3D 216, i =3D 215, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 217, i =3D 216, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x045B, 28 bytes at 91[27]:4
iwl4965: I iwl4965_rx_handle r 218 i 217 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_mac_tx enter
iwl4965: I iwl4965_mac_tx leave
iwl4965: I iwl4965_rx_handle r =3D 219, i =3D 218, REPLY_TX, 0x1c
iwl4965: I iwl4965_mac_tx enter
iwl4965: I iwl4965_mac_tx leave
iwl4965: I iwl4965_rx_handle r =3D 220, i =3D 219, REPLY_TX, 0x1c
iwl4965: I iwl4965_rx_handle r =3D 222, i =3D 220, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 222, i =3D 221, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x045C, 28 bytes at 92[28]:4
iwl4965: I iwl4965_rx_handle r =3D 224, i =3D 222, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_reply_rx Dropping (non network): 33:33:ff:92:3f:cb, 0=
0:16:b6:cf:57:17, 00:13:e8:92:3f:cb
iwl4965: I iwl4965_rx_handle r 224 i 223 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r =3D 225, i =3D 224, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:ff:ff, 0=
0:16:b6:cf:57:17, 00:13:e8:92:3f:cb
iwl4965: I iwl4965_rx_handle r =3D 227, i =3D 225, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 227, i =3D 226, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: =
0x045D, 12 bytes at 93[29]:4
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x045E, 28 bytes at 94[30]:4
iwl4965: I iwl4965_rx_handle r 229 i 227 No handler needed for REPLY_LEDS_C=
MD, 0x48
iwl4965: I iwl4965_rx_handle r 229 i 228 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r =3D 230, i =3D 229, MISSED_BEACONS_NOTIFICAT=
ION, 0xa2
iwl4965: I iwl4965_rx_handle r =3D 232, i =3D 230, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 232, i =3D 231, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 234, i =3D 232, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 234, i =3D 233, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 236, i =3D 234, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 236, i =3D 235, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 238, i =3D 236, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 238, i =3D 237, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 239, i =3D 238, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 241, i =3D 239, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 241, i =3D 240, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 242, i =3D 241, MISSED_BEACONS_NOTIFICAT=
ION, 0xa2
iwl4965: I iwl4965_rx_handle r =3D 244, i =3D 242, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 244, i =3D 243, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 245, i =3D 244, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 247, i =3D 245, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 247, i =3D 246, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 249, i =3D 247, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 249, i =3D 248, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 250, i =3D 249, REPLY_RX, 0xc3
iwl4965: I iwl4965_mac_tx enter
iwl4965: I iwl4965_mac_tx leave
iwl4965: I iwl4965_rx_handle r =3D 251, i =3D 250, REPLY_TX, 0x1c
iwl4965: I iwl4965_rx_handle r =3D 253, i =3D 251, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 253, i =3D 252, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 254, i =3D 253, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_reply_rx Dropping (non network): 33:33:00:00:00:02, 0=
0:16:b6:cf:57:17, 00:13:e8:92:3f:cb
iwl4965: I iwl4965_rx_handle r =3D 0, i =3D 254, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 0, i =3D 255, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_PHY_CALIBRATION_CMD (=
#b0), seq: 0x045F, 12 bytes at 95[31]:4
iwl4965: I iwl4965_rx_handle r 1 i 0 No handler needed for REPLY_PHY_CALIBR=
ATION_CMD, 0xb0
iwl4965: I iwl4965_rx_handle r =3D 2, i =3D 1, MISSED_BEACONS_NOTIFICATION,=
 0xa2
iwl4965: I iwl4965_rx_handle r =3D 4, i =3D 2, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 4, i =3D 3, STATISTICS_NOTIFICATION, 0x9d
iwl4965: I iwl4965_rx_handle r =3D 6, i =3D 4, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 6, i =3D 5, STATISTICS_NOTIFICATION, 0x9d
iwl4965: I iwl4965_rx_handle r =3D 8, i =3D 6, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 8, i =3D 7, STATISTICS_NOTIFICATION, 0x9d
iwl4965: I iwl4965_rx_handle r =3D 9, i =3D 8, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 11, i =3D 9, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 11, i =3D 10, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 13, i =3D 11, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 13, i =3D 12, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 14, i =3D 13, MISSED_BEACONS_NOTIFICATIO=
N, 0xa2
iwl4965: I iwl4965_rx_handle r =3D 16, i =3D 14, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 16, i =3D 15, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 17, i =3D 16, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 19, i =3D 17, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 19, i =3D 18, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 21, i =3D 19, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 21, i =3D 20, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 22, i =3D 21, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 24, i =3D 22, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 24, i =3D 23, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 26, i =3D 24, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 26, i =3D 25, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 27, i =3D 26, MISSED_BEACONS_NOTIFICATIO=
N, 0xa2
iwl4965: I iwl4965_rx_handle r =3D 29, i =3D 27, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 29, i =3D 28, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: =
0x0460, 12 bytes at 96[0]:4
iwl4965: I iwl4965_rx_handle r 30 i 29 No handler needed for REPLY_LEDS_CMD=
, 0x48
iwl4965: I iwl4965_rx_handle r =3D 32, i =3D 30, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 32, i =3D 31, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 34, i =3D 32, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 34, i =3D 33, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 36, i =3D 34, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 36, i =3D 35, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 38, i =3D 36, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 38, i =3D 37, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 39, i =3D 38, MISSED_BEACONS_NOTIFICATIO=
N, 0xa2
iwl4965: I iwl4965_rx_handle r =3D 41, i =3D 39, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 41, i =3D 40, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 43, i =3D 41, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 43, i =3D 42, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 44, i =3D 43, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 46, i =3D 44, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 46, i =3D 45, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_mac_tx enter
iwl4965: I iwl4965_mac_tx leave
iwl4965: I iwl4965_rx_handle r =3D 47, i =3D 46, REPLY_TX, 0x1c
iwl4965: I iwl4965_rx_handle r =3D 49, i =3D 47, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 49, i =3D 48, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 50, i =3D 49, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:ff:ff, 0=
0:16:b6:cf:57:17, 00:13:e8:92:3f:cb
iwl4965: I iwl4965_rx_handle r =3D 52, i =3D 50, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 52, i =3D 51, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0461, 28 bytes at 97[1]:4
iwl4965: I iwl4965_rx_handle r 53 i 52 No handler needed for SENSITIVITY_CM=
D, 0xa8
iwl4965: I iwl4965_rx_handle r =3D 54, i =3D 53, MISSED_BEACONS_NOTIFICATIO=
N, 0xa2
iwl4965: I iwl4965_rx_handle r =3D 56, i =3D 54, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 56, i =3D 55, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 58, i =3D 56, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 58, i =3D 57, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 60, i =3D 58, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 60, i =3D 59, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 62, i =3D 60, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 62, i =3D 61, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 64, i =3D 62, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 64, i =3D 63, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 65, i =3D 64, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 66, i =3D 65, MISSED_BEACONS_NOTIFICATIO=
N, 0xa2
iwl4965: I iwl4965_rx_handle r =3D 68, i =3D 66, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 68, i =3D 67, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 69, i =3D 68, REPLY_RX, 0xc3
iwl4965: I iwl4965_mac_tx enter
iwl4965: I iwl4965_mac_tx leave
dhcpcd[8948]: wlan0: offered 10.10.100.156 from 10.10.100.1
iwl4965: I iwl4965_rx_handle r =3D 70, i =3D 69, REPLY_TX, 0x1c
iwl4965: I iwl4965_rx_handle r =3D 71, i =3D 70, REPLY_RX, 0xc3
dhcpcd[8948]: wlan0: got subsequent offer of 10.10.100.156, ignoring=20
iwl4965: I iwl4965_rx_handle r =3D 73, i =3D 71, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 73, i =3D 72, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 74, i =3D 73, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:ff:ff, 0=
0:16:b6:cf:57:17, 00:13:e8:92:3f:cb
iwl4965: I iwl4965_rx_handle r =3D 76, i =3D 74, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 76, i =3D 75, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: =
0x0462, 12 bytes at 98[2]:4
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0463, 28 bytes at 99[3]:4
iwl4965: I iwl4965_rx_handle r 78 i 76 No handler needed for REPLY_LEDS_CMD=
, 0x48
iwl4965: I iwl4965_rx_handle r 78 i 77 No handler needed for SENSITIVITY_CM=
D, 0xa8
iwl4965: I iwl4965_rx_handle r =3D 79, i =3D 78, REPLY_RX, 0xc3
dhcpcd[8948]: wlan0: checking 10.10.100.156 is available on attached networ=
ks
iwl4965: I iwl4965_mac_tx enter
iwl4965: I iwl4965_mac_tx leave
iwl4965: I iwl4965_rx_handle r =3D 80, i =3D 79, REPLY_TX, 0x1c
iwl4965: I iwl4965_rx_handle r =3D 82, i =3D 80, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 82, i =3D 81, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 83, i =3D 82, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:ff:ff, 0=
0:16:b6:cf:57:17, 00:13:e8:92:3f:cb
iwl4965: I iwl4965_rx_handle r =3D 85, i =3D 83, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 85, i =3D 84, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_mac_tx enter
iwl4965: I iwl4965_mac_tx leave
iwl4965: I iwl4965_rx_handle r =3D 86, i =3D 85, REPLY_TX, 0x1c
iwl4965: I iwl4965_rx_handle r =3D 87, i =3D 86, MISSED_BEACONS_NOTIFICATIO=
N, 0xa2
iwl4965: I iwl4965_rx_handle r =3D 89, i =3D 87, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 89, i =3D 88, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 90, i =3D 89, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:ff:ff, 0=
0:16:b6:cf:57:17, 00:13:e8:92:3f:cb
iwl4965: I iwl4965_rx_handle r =3D 92, i =3D 90, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 92, i =3D 91, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_mac_tx enter
iwl4965: I iwl4965_mac_tx leave
iwl4965: I iwl4965_rx_handle r =3D 93, i =3D 92, REPLY_TX, 0x1c
iwl4965: I iwl4965_rx_handle r =3D 95, i =3D 93, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 95, i =3D 94, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_rx_handle r =3D 96, i =3D 95, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:ff:ff, 0=
0:16:b6:cf:57:17, 00:13:e8:92:3f:cb
iwl4965: I iwl4965_rx_handle r =3D 98, i =3D 96, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 98, i =3D 97, STATISTICS_NOTIFICATION, 0=
x9d
iwl4965: I iwl4965_mac_tx enter
iwl4965: I iwl4965_mac_tx leave
iwl4965: I iwl4965_rx_handle r =3D 99, i =3D 98, REPLY_TX, 0x1c
iwl4965: I iwl4965_rx_handle r =3D 101, i =3D 99, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 101, i =3D 100, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 102, i =3D 101, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:ff:ff, 0=
0:16:b6:cf:57:17, 00:13:e8:92:3f:cb
iwl4965: I iwl4965_rx_handle r =3D 103, i =3D 102, MISSED_BEACONS_NOTIFICAT=
ION, 0xa2
iwl4965: I iwl4965_rx_handle r =3D 105, i =3D 103, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 105, i =3D 104, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_mac_tx enter
iwl4965: I iwl4965_mac_tx leave
iwl4965: I iwl4965_rx_handle r =3D 106, i =3D 105, REPLY_TX, 0x1c
iwl4965: I iwl4965_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (=
#4e), seq: 0x0464, 92 bytes at 100[4]:4
iwl4965: I iwl4965_rx_handle r 107 i 106 No handler needed for REPLY_TX_LIN=
K_QUALITY_CMD, 0x4e
iwl4965: I iwl4965_rx_handle r =3D 108, i =3D 107, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 110, i =3D 108, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:ff:ff, 0=
0:16:b6:cf:57:17, 00:13:e8:92:3f:cb
iwl4965: I iwl4965_rx_handle r =3D 110, i =3D 109, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_mac_tx enter
iwl4965: I iwl4965_mac_tx leave
iwl4965: I iwl4965_rx_handle r =3D 111, i =3D 110, REPLY_TX, 0x1c
iwl4965: I iwl4965_rx_handle r =3D 113, i =3D 111, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 113, i =3D 112, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 114, i =3D 113, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_reply_rx Dropping (non network): 33:33:00:00:00:02, 0=
0:16:b6:cf:57:17, 00:13:e8:92:3f:cb
dhcpcd[8948]: wlan0: leased 10.10.100.156 for 3600 seconds
dhcpcd[8948]: wlan0: adding IP address 10.10.100.156/24
dhcpcd[8948]: wlan0: adding route to 10.10.100.0/24 metric 2000
dhcpcd[8948]: wlan0: removing route to 10.10.100.0/24 metric 0
dhcpcd[8948]: wlan0: adding default route via 10.10.100.1 metric 2000
dhcpcd[8948]: wlan0: exiting
iwl4965: I iwl4965_rx_handle r =3D 116, i =3D 114, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 116, i =3D 115, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 118, i =3D 116, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 118, i =3D 117, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 119, i =3D 118, MISSED_BEACONS_NOTIFICAT=
ION, 0xa2
iwl4965: I iwl4965_rx_handle r =3D 121, i =3D 119, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 121, i =3D 120, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 123, i =3D 121, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 123, i =3D 122, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 125, i =3D 123, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 125, i =3D 124, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 127, i =3D 125, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 127, i =3D 126, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 129, i =3D 127, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 129, i =3D 128, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 130, i =3D 129, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 131, i =3D 130, MISSED_BEACONS_NOTIFICAT=
ION, 0xa2
iwl4965: I iwl4965_rx_handle r =3D 133, i =3D 131, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 133, i =3D 132, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 134, i =3D 133, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 136, i =3D 134, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 136, i =3D 135, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 138, i =3D 136, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 138, i =3D 137, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 140, i =3D 138, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 140, i =3D 139, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: =
0x0465, 12 bytes at 101[5]:4
iwl4965: I iwl4965_rx_handle r 141 i 140 No handler needed for REPLY_LEDS_C=
MD, 0x48
iwl4965: I iwl4965_rx_handle r =3D 143, i =3D 141, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 143, i =3D 142, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 144, i =3D 143, MISSED_BEACONS_NOTIFICAT=
ION, 0xa2
iwl4965: I iwl4965_rx_handle r =3D 146, i =3D 144, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 146, i =3D 145, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 148, i =3D 146, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 148, i =3D 147, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 150, i =3D 148, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 150, i =3D 149, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 152, i =3D 150, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 152, i =3D 151, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 154, i =3D 152, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 154, i =3D 153, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 155, i =3D 154, MISSED_BEACONS_NOTIFICAT=
ION, 0xa2
iwl4965: I iwl4965_rx_handle r =3D 157, i =3D 155, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 157, i =3D 156, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 159, i =3D 157, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 159, i =3D 158, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 161, i =3D 159, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 161, i =3D 160, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 163, i =3D 161, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 163, i =3D 162, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 165, i =3D 163, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 165, i =3D 164, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_mac_tx enter
iwl4965: I iwl4965_mac_tx leave
iwl4965: I iwl4965_rx_handle r =3D 166, i =3D 165, REPLY_TX, 0x1c
iwl4965: I iwl4965_rx_handle r =3D 167, i =3D 166, MISSED_BEACONS_NOTIFICAT=
ION, 0xa2
iwl4965: I iwl4965_rx_handle r =3D 169, i =3D 167, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 169, i =3D 168, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 170, i =3D 169, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_reply_rx Dropping (non network): 33:33:00:00:00:16, 0=
0:16:b6:cf:57:17, 00:13:e8:92:3f:cb
iwl4965: I iwl4965_rx_handle r =3D 172, i =3D 170, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 172, i =3D 171, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 174, i =3D 172, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 174, i =3D 173, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 176, i =3D 174, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 176, i =3D 175, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 178, i =3D 176, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 178, i =3D 177, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 179, i =3D 178, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 180, i =3D 179, MISSED_BEACONS_NOTIFICAT=
ION, 0xa2
iwl4965: I iwl4965_rx_handle r =3D 182, i =3D 180, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 182, i =3D 181, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 184, i =3D 182, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 184, i =3D 183, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 186, i =3D 184, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 186, i =3D 185, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 188, i =3D 186, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 188, i =3D 187, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 190, i =3D 188, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 190, i =3D 189, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: =
0x0466, 12 bytes at 102[6]:4
iwl4965: I iwl4965_rx_handle r 191 i 190 No handler needed for REPLY_LEDS_C=
MD, 0x48
iwl4965: I iwl4965_rx_handle r =3D 192, i =3D 191, MISSED_BEACONS_NOTIFICAT=
ION, 0xa2
iwl4965: I iwl4965_rx_handle r =3D 194, i =3D 192, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 194, i =3D 193, STATISTICS_NOTIFICATION,=
 0x9d

[ Shutting down wpa_supplicant ]

iwl4965: I iwl4965_rx_handle r =3D 195, i =3D 194, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 196, i =3D 195, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 198, i =3D 196, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 198, i =3D 197, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 199, i =3D 198, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 200, i =3D 199, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 201, i =3D 200, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 203, i =3D 201, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 203, i =3D 202, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 204, i =3D 203, MISSED_BEACONS_NOTIFICAT=
ION, 0xa2
iwl4965: I iwl4965_rx_handle r =3D 206, i =3D 204, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 206, i =3D 205, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_mac_tx enter
iwl4965: I iwl4965_mac_tx leave
iwl4965: I iwl4965_rx_handle r =3D 207, i =3D 206, REPLY_TX, 0x1c
iwl4965: I iwl4965_rx_handle r =3D 208, i =3D 207, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 209, i =3D 208, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 210, i =3D 209, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_reply_rx Dropping (non network): 33:33:00:00:00:02, 0=
0:16:b6:cf:57:17, 00:13:e8:92:3f:cb
iwl4965: I iwl4965_rx_handle r =3D 212, i =3D 210, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 212, i =3D 211, STATISTICS_NOTIFICATION,=
 0x9d
dhcpcd[9001]: wlan0: received SIGTERM, stopping
dhcpcd[9001]: wlan0: removing default route via 10.10.100.1 metric 2000
dhcpcd[9001]: wlan0: removing IP address 10.10.100.156/24
dhcpcd[9001]: wlan0: exiting
iwl4965: I iwl4965_rx_handle r =3D 214, i =3D 212, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 214, i =3D 213, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: I iwl4965_rx_handle r =3D 216, i =3D 214, REPLY_RX, 0xc3
iwl4965: I iwl4965_rx_handle r =3D 216, i =3D 215, STATISTICS_NOTIFICATION,=
 0x9d
iwl4965: U iwl4965_mac_remove_interface enter
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0467, 28 bytes at 103[7]:4
iwl4965: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 6
* bssid =3D 00:16:b6:cf:57:17
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x04=
68, 48 bytes at 104[8]:4
iwl4965: I iwl4965_rx_handle r 218 i 216 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r 218 i 217 No handler needed for REPLY_RXON, =
0x10
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0469, 28 bytes at 105[9]:4
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97=
), seq: 0x046A, 140 bytes at 106[10]:4
iwl4965: I iwl4965_rx_handle r 220 i 218 No handler needed for SENSITIVITY_=
CMD, 0xa8
iwl4965: I iwl4965_rx_handle r 220 i 219 No handler needed for REPLY_TX_PWR=
_TABLE_CMD, 0x97
iwl4965: U iwl4965_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0=
x046B, 72 bytes at 107[11]:4
iwl4965: I iwl4965_rx_handle r =3D 221, i =3D 220, REPLY_ADD_STA, 0x18
iwl4965: U iwl4965_send_add_station REPLY_ADD_STA PASSED
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (=
#4e), seq: 0x046C, 92 bytes at 108[12]:4
iwl4965: U iwl4965_mac_remove_interface leave
iwl4965: I iwl4965_rx_handle r 222 i 221 No handler needed for REPLY_TX_LIN=
K_QUALITY_CMD, 0x4e
iwl4965: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x=
00000000)
iwl4965: U iwl4965_mac_stop enter
iwl4965: U __iwl4965_down iwl4965 is going down
wlan0: no IPv6 routers present
iwl4965: U iwl4965_hw_nic_stop_master stop master
iwl4965: U iwl4965_hw_nic_stop_master stop master
iwl4965: U iwl4965_clear_free_frames 0 frames on pre-allocated heap on clea=
r.
iwl4965: U iwl4965_mac_stop leave
wlan0: deauthenticate(reason=3D3)

[ ifconfig wlan0 down ]
[ iwconfig mode monitor ]
[ ifconfig up ]

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
iwl4965: I iwl4965_rx_handle r =3D 1, i =3D 0, REPLY_ALIVE, 0x01
iwl4965: I iwl4965_rx_reply_alive Alive ucode status 0x00000001 revision 0x=
1 0x9
iwl4965: I iwl4965_rx_reply_alive Initialization Alive received.
iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 788
iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 10312
iwl4965: U iwl4965_verify_ucode Initialize uCode is good in inst SRAM
iwl4965: U iwl4965_get_temperature Running temperature calibration
iwl4965: U iwl4965_get_temperature Calib values R[1-3]: -110 13442 -13598 R=
4: -3200
iwl4965: U iwl4965_get_temperature Calibrated temperature: 317K, 44C
iwl4965: U iwl4965_init_alive_start Initialization Alive received.
iwl4965: U iwl4965_set_ucode_ptrs Runtime uCode pointers are set.
iwl4965: I iwl4965_rx_handle r =3D 2, i =3D 1, REPLY_ALIVE, 0x01
iwl4965: I iwl4965_rx_reply_alive Alive ucode status 0x00000001 revision 0x=
1 0x0
iwl4965: I iwl4965_rx_reply_alive Runtime Alive received.
iwl4965: U iwl4965_alive_start Runtime Alive received.
iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 788
iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 10312
iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 92720
iwl4965: U iwl4965_verify_ucode Runtime uCode is good in inst SRAM
iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 0 on AC 3
iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 1 on AC 2
iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 2 on AC 1
iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 3 on AC 0
iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 4 on AC 4
iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 5 on AC 5
iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 6 on AC 6
iwl4965: U iwl4965_update_power_cmd Flags value =3D 0x00000000
iwl4965: U iwl4965_update_power_cmd Tx timeout =3D 0
iwl4965: U iwl4965_update_power_cmd Rx timeout =3D 0
iwl4965: U iwl4965_update_power_cmd Sleep interval vector =3D { 0 , 0 , 0 ,=
 0 , 0 }
iwl4965: U iwl4965_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq:=
 0x0400, 40 bytes at 0[0]:4
iwl4965: I iwl4965_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD,=
 0x77
iwl4965: U iwl4965_set_rxon_chain rx chain 280E
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq:=
 0x0401, 16 bytes at 1[1]:4
iwl4965: I iwl4965_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG,=
 0x9b
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0402, 28 bytes at 2[2]:4
iwl4965: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:00:00:00:00:00
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x04=
03, 48 bytes at 3[3]:4
iwl4965: I iwl4965_rx_handle r 5 i 4 No handler needed for SENSITIVITY_CMD,=
 0xa8
iwl4965: I iwl4965_rx_handle r 6 i 5 No handler needed for REPLY_RXON, 0x10
iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq:=
 0x0404, 28 bytes at 4[4]:4
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97=
), seq: 0x0405, 140 bytes at 5[5]:4
iwl4965: I iwl4965_rx_handle r 8 i 6 No handler needed for SENSITIVITY_CMD,=
 0xa8
iwl4965: I iwl4965_rx_handle r 8 i 7 No handler needed for REPLY_TX_PWR_TAB=
LE_CMD, 0x97
iwl4965: U iwl4965_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0=
x0406, 72 bytes at 6[6]:4
iwl4965: I iwl4965_rx_handle r =3D 9, i =3D 8, REPLY_ADD_STA, 0x18
iwl4965: U iwl4965_send_add_station REPLY_ADD_STA PASSED
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (=
#4e), seq: 0x0407, 92 bytes at 7[7]:4
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_CT_KILL_CONFIG_CMD (#=
a4), seq: 0x0408, 16 bytes at 8[8]:4
iwl4965: I iwl4965_rx_handle r 11 i 9 No handler needed for REPLY_TX_LINK_Q=
UALITY_CMD, 0x4e
iwl4965: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x=
00000000)
iwl4965: I iwl4965_rx_handle r 11 i 10 No handler needed for REPLY_CT_KILL_=
CONFIG_CMD, 0xa4
iwl4965: U iwl4965_rf_kill_ct_config REPLY_CT_KILL_CONFIG_CMD succeeded
iwl4965: U iwl4965_alive_start ALIVE processing complete.
iwl4965: U iwl4965_mac_start leave
Registered led device: iwl-phy1:radio
Registered led device: iwl-phy1:assoc
Registered led device: iwl-phy1:RX
Registered led device: iwl-phy1:TX
iwl4965: U iwl4965_mac_config enter to channel 6
iwl4965: U iwlcore_set_rxon_channel Staging channel set to 6 [0]
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_CARD_STATE_CMD (#a0),=
 seq: 0x0409, 8 bytes at 9[9]:4
iwl4965: I iwl4965_rx_handle r 13 i 11 No handler needed for REPLY_CARD_STA=
TE_CMD, 0xa0
iwl4965: I iwl4965_rx_handle r =3D 13, i =3D 12, CARD_STATE_NOTIFICATION, 0=
xa1
iwl4965: U iwl4965_mac_config leave - radio disabled
ADDRCONF(NETDEV_UP): wlan0: link is not ready

[ tcpdump -eni wlan0 ]

device wlan0 entered promiscuous mode

[ No packets on wlan0 in a busy area ]

device wlan0 left promiscuous mode

[ Give up on tcpdump ]

[ ifconfig down ]

iwl4965: U iwl4965_mac_stop enter
iwl4965: U __iwl4965_down iwl4965 is going down
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: U iwl4965_hw_nic_stop_master stop master
iwl4965: U iwl4965_hw_nic_stop_master stop master
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: U iwl4965_clear_free_frames 0 frames on pre-allocated heap on clea=
r.
iwl4965: U iwl4965_mac_stop leave

[ iwconfig mode managed ]
[ wlan0.start, ie reload wpa_supplicant ]

iwl4965: U iwl4965_mac_start enter
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
iwl4965: Radio disabled by SW RF kill (module parameter)
iwl4965: U iwl4965_mac_start leave - failed
iwl4965: U iwl4965_mac_start enter
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
iwl4965: Radio disabled by SW RF kill (module parameter)
iwl4965: U iwl4965_mac_start leave - failed
iwl4965: U iwl4965_mac_start enter
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
iwl4965: Radio disabled by SW RF kill (module parameter)
iwl4965: U iwl4965_mac_start leave - failed
iwl4965: U iwl4965_mac_start enter
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
iwl4965: Radio disabled by SW RF kill (module parameter)
iwl4965: U iwl4965_mac_start leave - failed

[ ^ Can't come out of rfmon mode cleanly, we're managed but we don't work ]

[ modprobe -r iwl4965 ]

iwl4965: U iwl4965_pci_remove *** UNLOAD DRIVER ***
iwl4965: U __iwl4965_down iwl4965 is going down
iwl4965: U iwl4965_clear_free_frames 0 frames on pre-allocated heap on clea=
r.

[ No crash this time at least ]

--=20
Mike Kershaw/Dragorn <dragorn@kismetwireless.net>
GPG Fingerprint: 3546 89DF 3C9D ED80 3381  A661 D7B2 8822 738B BDB1

the sand remembers
once there was beach and sunshine
but chip is warm too

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkgA1nkACgkQ17KIInOLvbGmkQCfW8T6z/tUSYoBkvoMsqDlJf8C
TUoAn1IdgH8vnX3GtG+vIfG7bI5HoDqU
=6VXi
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
