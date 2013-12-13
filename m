Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:50142 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3LMLkS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 06:40:18 -0500
Received: by mail-pb0-f41.google.com with SMTP id jt11so2452525pbb.14
        for <linux-wireless@vger.kernel.org>; Fri, 13 Dec 2013 03:40:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52AA7A57.9090902@gmail.com>
References: <CANUDGG3bU9PkQgZYKFYAb31sN7xzvtAM0+xsasXpSgR5Q1CmHw@mail.gmail.com>
	<52AA7A57.9090902@gmail.com>
Date: Fri, 13 Dec 2013 06:40:17 -0500
Message-ID: <CANUDGG1y3Qy5yqpwB2UzLthCm7P9Rk+zgHD4xoNzk9XuHkAo+w@mail.gmail.com> (sfid-20131213_124028_237119_368A83BB)
Subject: Re: Microcode crashes on Intel 7260
From: David Williams <xflow7@gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Emmanuel,

Thanks for the quick reply.  Output below as requested.

Best Regards,

Dave Williams

--------------------------------------------------------------------------------------------
> iw list
Wiphy phy0
    Band 1:
        Capabilities: 0x1062
            HT20/HT40
            Static SM Power Save
            RX HT20 SGI
            RX HT40 SGI
            No RX STBC
            Max AMSDU length: 3839 bytes
            DSSS/CCK HT40
        Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
        Minimum RX AMPDU time spacing: 4 usec (0x05)
        HT TX/RX MCS rate indexes supported: 0-15, 32
        Frequencies:
            * 2412 MHz [1] (0.0 dBm)
            * 2417 MHz [2] (0.0 dBm)
            * 2422 MHz [3] (0.0 dBm)
            * 2427 MHz [4] (0.0 dBm)
            * 2432 MHz [5] (0.0 dBm)
            * 2437 MHz [6] (0.0 dBm)
            * 2442 MHz [7] (0.0 dBm)
            * 2447 MHz [8] (0.0 dBm)
            * 2452 MHz [9] (0.0 dBm)
            * 2457 MHz [10] (0.0 dBm)
            * 2462 MHz [11] (0.0 dBm)
            * 2467 MHz [12] (0.0 dBm) (passive scanning, no IBSS)
            * 2472 MHz [13] (0.0 dBm) (passive scanning, no IBSS)
        Bitrates (non-HT):
            * 1.0 Mbps
            * 2.0 Mbps (short preamble supported)
            * 5.5 Mbps (short preamble supported)
            * 11.0 Mbps (short preamble supported)
            * 6.0 Mbps
            * 9.0 Mbps
            * 12.0 Mbps
            * 18.0 Mbps
            * 24.0 Mbps
            * 36.0 Mbps
            * 48.0 Mbps
            * 54.0 Mbps
    max # scan SSIDs: 20
    max scan IEs length: 195 bytes
    Coverage class: 0 (up to 0m)
    Supported Ciphers:
        * WEP40 (00-0f-ac:1)
        * WEP104 (00-0f-ac:5)
        * TKIP (00-0f-ac:2)
        * CCMP (00-0f-ac:4)
        * CMAC (00-0f-ac:6)
    Available Antennas: TX 0 RX 0
    Supported interface modes:
         * managed
         * AP
         * AP/VLAN
         * monitor
         * P2P-client
         * P2P-GO
         * Unknown mode (10)
    software interface modes (can always be added):
         * AP/VLAN
         * monitor
    valid interface combinations:
         * #{ managed, AP } <= 1, #{ P2P-client, P2P-GO } <= 1, #{
Unknown mode (10) } <= 1,
           total <= 3, #channels <= 1
    Supported commands:
         * new_interface
         * set_interface
         * new_key
         * start_ap
         * new_station
         * new_mpath
         * set_mesh_config
         * set_bss
         * authenticate
         * associate
         * deauthenticate
         * disassociate
         * join_ibss
         * join_mesh
         * remain_on_channel
         * set_tx_bitrate_mask
         * frame
         * frame_wait_cancel
         * set_wiphy_netns
         * set_channel
         * set_wds_peer
         * probe_client
         * set_noack_map
         * register_beacons
         * Unknown command (89)
         * Unknown command (92)
         * connect
         * disconnect
    Supported TX frame types:
         * IBSS: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90
0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
         * managed: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90
0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
         * AP: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0
0xb0 0xc0 0xd0 0xe0 0xf0
         * AP/VLAN: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90
0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
         * mesh point: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80
0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
         * P2P-client: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80
0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
         * P2P-GO: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90
0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
         * Unknown mode (10): 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
    Supported RX frame types:
         * IBSS: 0x40 0xb0 0xc0 0xd0
         * managed: 0x40 0xd0
         * AP: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
         * AP/VLAN: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
         * mesh point: 0xb0 0xc0 0xd0
         * P2P-client: 0x40 0xd0
         * P2P-GO: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
         * Unknown mode (10): 0x40 0xd0
    Device supports RSN-IBSS.
    WoWLAN support:
         * wake up on disconnect
         * wake up on magic packet
         * wake up on pattern match, up to 20 patterns of 16-128 bytes
         * can do GTK rekeying
         * wake up on GTK rekey failure
         * wake up on EAP identity request
         * wake up on 4-way handshake
         * wake up on rfkill release
    HT Capability overrides:
         * MCS: ff ff ff ff ff ff ff ff ff ff
         * maximum A-MSDU length
         * supported channel width
         * short GI for 40 MHz
         * max A-MPDU length exponent
         * min MPDU start spacing
    Device supports TX status socket option.
    Device supports HT-IBSS.

--------------------------------------------------------------------------------------------

> dmesg
<snip>
[  979.313250] iwlwifi 0000:02:00.0: Microcode SW error detected.
Restarting 0x2000000.
[  979.313256] iwlwifi 0000:02:00.0: CSR values:
[  979.313258] iwlwifi 0000:02:00.0: (2nd byte of CSR_INT_COALESCING
is CSR_INT_PERIODIC_REG)
[  979.313264] iwlwifi 0000:02:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489204
[  979.313269] iwlwifi 0000:02:00.0:          CSR_INT_COALESCING: 0X0000ff40
[  979.313273] iwlwifi 0000:02:00.0:                     CSR_INT: 0X00000000
[  979.313278] iwlwifi 0000:02:00.0:                CSR_INT_MASK: 0X00000000
[  979.313282] iwlwifi 0000:02:00.0:           CSR_FH_INT_STATUS: 0X00000000
[  979.313286] iwlwifi 0000:02:00.0:                 CSR_GPIO_IN: 0X00000000
[  979.313291] iwlwifi 0000:02:00.0:                   CSR_RESET: 0X00000000
[  979.313296] iwlwifi 0000:02:00.0:                CSR_GP_CNTRL: 0X080403c5
[  979.313301] iwlwifi 0000:02:00.0:                  CSR_HW_REV: 0X00000144
[  979.313305] iwlwifi 0000:02:00.0:              CSR_EEPROM_REG: 0X00000000
[  979.313310] iwlwifi 0000:02:00.0:               CSR_EEPROM_GP: 0X80000000
[  979.313314] iwlwifi 0000:02:00.0:              CSR_OTP_GP_REG: 0X803a0000
[  979.313318] iwlwifi 0000:02:00.0:                 CSR_GIO_REG: 0X00080044
[  979.313323] iwlwifi 0000:02:00.0:            CSR_GP_UCODE_REG: 0X00000000
[  979.313327] iwlwifi 0000:02:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[  979.313331] iwlwifi 0000:02:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[  979.313336] iwlwifi 0000:02:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[  979.313340] iwlwifi 0000:02:00.0:                 CSR_LED_REG: 0X00000060
[  979.313345] iwlwifi 0000:02:00.0:        CSR_DRAM_INT_TBL_REG: 0X8819734e
[  979.313349] iwlwifi 0000:02:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[  979.313354] iwlwifi 0000:02:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[  979.313358] iwlwifi 0000:02:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[  979.313362] iwlwifi 0000:02:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[  979.313364] iwlwifi 0000:02:00.0: FH register values:
[  979.313377] iwlwifi 0000:02:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X19191a00
[  979.313391] iwlwifi 0000:02:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01919190
[  979.313406] iwlwifi 0000:02:00.0:
FH_RSCSR_CHNL0_WPTR: 0X00000060
[  979.313420] iwlwifi 0000:02:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
[  979.313433] iwlwifi 0000:02:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  979.313447] iwlwifi 0000:02:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[  979.313462] iwlwifi 0000:02:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  979.313476] iwlwifi 0000:02:00.0:
FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  979.313489] iwlwifi 0000:02:00.0:
FH_TSSR_TX_ERROR_REG: 0X00000000
[  979.313623] iwlwifi 0000:02:00.0: Start IWL Error Log Dump:
[  979.313625] iwlwifi 0000:02:00.0: Status: 0x00000000, count: 6
[  979.313627] iwlwifi 0000:02:00.0: 0x000014FC | ADVANCED_SYSASSERT
[  979.313629] iwlwifi 0000:02:00.0: 0x00000220 | uPc
[  979.313631] iwlwifi 0000:02:00.0: 0x00000000 | branchlink1
[  979.313633] iwlwifi 0000:02:00.0: 0x00000C8A | branchlink2
[  979.313634] iwlwifi 0000:02:00.0: 0x00014078 | interruptlink1
[  979.313636] iwlwifi 0000:02:00.0: 0x00D5ECD8 | interruptlink2
[  979.313638] iwlwifi 0000:02:00.0: 0x00000000 | data1
[  979.313639] iwlwifi 0000:02:00.0: 0x00000000 | data2
[  979.313641] iwlwifi 0000:02:00.0: 0x00010000 | data3
[  979.313643] iwlwifi 0000:02:00.0: 0x07C0AA65 | beacon time
[  979.313644] iwlwifi 0000:02:00.0: 0x1014F427 | tsf low
[  979.313646] iwlwifi 0000:02:00.0: 0x00000044 | tsf hi
[  979.313648] iwlwifi 0000:02:00.0: 0x00000000 | time gp1
[  979.313649] iwlwifi 0000:02:00.0: 0x38A617AD | time gp2
[  979.313651] iwlwifi 0000:02:00.0: 0x00000000 | time gp3
[  979.313653] iwlwifi 0000:02:00.0: 0x00321600 | uCode version
[  979.313654] iwlwifi 0000:02:00.0: 0x00000144 | hw version
[  979.313656] iwlwifi 0000:02:00.0: 0x00489204 | board version
[  979.313658] iwlwifi 0000:02:00.0: 0x029E001C | hcmd
[  979.313659] iwlwifi 0000:02:00.0: 0x24022000 | isr0
[  979.313661] iwlwifi 0000:02:00.0: 0x00000000 | isr1
[  979.313663] iwlwifi 0000:02:00.0: 0x00000002 | isr2
[  979.313664] iwlwifi 0000:02:00.0: 0x0041FCC0 | isr3
[  979.313666] iwlwifi 0000:02:00.0: 0x00000000 | isr4
[  979.313667] iwlwifi 0000:02:00.0: 0x00000110 | isr_pref
[  979.313669] iwlwifi 0000:02:00.0: 0x00014D9A | wait_event
[  979.313671] iwlwifi 0000:02:00.0: 0x000000D4 | l2p_control
[  979.313672] iwlwifi 0000:02:00.0: 0x00018010 | l2p_duration
[  979.313674] iwlwifi 0000:02:00.0: 0x00000007 | l2p_mhvalid
[  979.313676] iwlwifi 0000:02:00.0: 0x00000081 | l2p_addr_match
[  979.313677] iwlwifi 0000:02:00.0: 0x00000005 | lmpm_pmg_sel
[  979.313679] iwlwifi 0000:02:00.0: 0x17061625 | timestamp
[  979.313681] iwlwifi 0000:02:00.0: 0x00006070 | flow_handler
[  980.721081] iwlwifi 0000:02:00.0: Failed to send MAC context (action:2): -5
[  980.721087] iwlwifi 0000:02:00.0: failed to update MAC 0c:8b:fd:bf:e7:58
[  980.721090] iwlwifi 0000:02:00.0: failed to update power mode
[  980.731014] wlan0: failed to remove key (0, 00:14:bf:3f:21:75) from
hardware (-5)
[  980.731025] iwlwifi 0000:02:00.0: Failed to send flush command (-5)
[  980.731026] ------------[ cut here ]------------
[  980.731040] WARNING: at net/mac80211/sta_info.c:835
__sta_info_destroy+0x21b/0x310 [mac80211]()
[  980.731042] Modules linked in: ipv6 cpufreq_ondemand lp ppdev
parport_pc parport fuse i2c_dev keucr(C) usb_storage uvcvideo
videobuf2_vmalloc videobuf2_memops videobuf2_core videodev joydev
btusb bluetooth i915 iwlmvm mac80211 coretemp acpi_cpufreq mperf
i2c_i801 intel_agp intel_gtt drm_kms_helper drm agpgart video
processor thermal i2c_algo_bit i2c_core alx ehci_pci xhci_hcd psmouse
thermal_sys freq_table iwlwifi ehci_hcd serio_raw evdev hwmon lpc_ich
mei_me mei sparse_keymap mdio kvm_intel kvm mxm_wmi crc32_pclmul
toshiba_bluetooth wmi battery button ac snd_hda_codec_idt cfg80211
rfkill crc32c_intel snd_hda_codec_hdmi snd_hda_intel snd_hda_codec
snd_hwdep snd_pcm snd_page_alloc snd_timer snd soundcore
ghash_clmulni_intel microcode loop
[  980.731097] CPU: 1 PID: 1693 Comm: kworker/u8:2 Tainted: G
C   3.10.17 #2
[  980.731099] Hardware name: TOSHIBA Satellite P55-A/VG10ST, BIOS
1.40 10/09/2013
[  980.731107] Workqueue: phy0 ieee80211_iface_work [mac80211]
[  980.731110]  0000000000000009 ffff88015003dbb8 ffffffff81b66dc6
ffff88015003dbf0
[  980.731113]  ffffffff81056f51 ffff88019786e640 ffff8801920be800
ffff8801920be800
[  980.731116]  00000000fffffffb ffff88018925f000 ffff88015003dc00
ffffffff8105702a
[  980.731119] Call Trace:
[  980.731127]  [<ffffffff81b66dc6>] dump_stack+0x19/0x1b
[  980.731133]  [<ffffffff81056f51>] warn_slowpath_common+0x61/0x80
[  980.731136]  [<ffffffff8105702a>] warn_slowpath_null+0x1a/0x20
[  980.731144]  [<ffffffffa08d0a7b>] __sta_info_destroy+0x21b/0x310 [mac80211]
[  980.731151]  [<ffffffffa08d0cb5>] sta_info_flush_defer+0x85/0xb0 [mac80211]
[  980.731161]  [<ffffffffa090700f>] ieee80211_set_disassoc+0xaf/0x3b0
[mac80211]
[  980.731169]  [<ffffffffa090820e>]
ieee80211_sta_connection_lost.isra.22+0x3e/0x80 [mac80211]
[  980.731177]  [<ffffffffa0909352>] ieee80211_sta_work+0x1d2/0xf90 [mac80211]
[  980.731185]  [<ffffffffa08dbb19>] ieee80211_iface_work+0x2c9/0x360 [mac80211]
[  980.731189]  [<ffffffff8107430f>] process_one_work+0x17f/0x430
[  980.731192]  [<ffffffff81074f41>] worker_thread+0x121/0x3a0
[  980.731196]  [<ffffffff81074e20>] ? manage_workers.isra.27+0x2a0/0x2a0
[  980.731200]  [<ffffffff8107ac60>] kthread+0xc0/0xd0
[  980.731204]  [<ffffffff8107aba0>] ? kthread_create_on_node+0x120/0x120
[  980.731208]  [<ffffffff81b6f6dc>] ret_from_fork+0x7c/0xb0
[  980.731212]  [<ffffffff8107aba0>] ? kthread_create_on_node+0x120/0x120
[  980.731214] ---[ end trace 7a7fa89d23055b3a ]---
[  980.731227] iwlwifi 0000:02:00.0: Failed to send MAC context (action:2): -5
[  980.731231] iwlwifi 0000:02:00.0: failed to update MAC 0c:8b:fd:bf:e7:58
[  980.731234] iwlwifi 0000:02:00.0: Failed to remove station. Id=1
[  980.731237] iwlwifi 0000:02:00.0: failed to remove AP station
[  980.731243] iwlwifi 0000:02:00.0: Failed to send MAC context (action:2): -5
[  980.731247] iwlwifi 0000:02:00.0: failed to update MAC 0c:8b:fd:bf:e7:58
[  980.731251] iwlwifi 0000:02:00.0: Failed to send binding (action:3): -5
[  980.731255] iwlwifi 0000:02:00.0: Failed to send PHY remove: ctxt id=1
[  980.736066] cfg80211: Calling CRDA to update world regulatory domain
[  980.737986] cfg80211: World regulatory domain updated:
[  980.737989] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  980.737992] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  980.737994] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[  980.737996] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[  980.737998] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  980.738013] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  980.831505] iwlwifi 0000:02:00.0: Scan failed! status 0x1 ret -5
[  981.832267] iwlwifi 0000:02:00.0: Scan failed! status 0x1 ret -5
[  982.832935] iwlwifi 0000:02:00.0: Scan failed! status 0x1 ret -5
<snip>


On Thu, Dec 12, 2013 at 10:09 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>
>
> On 12/12/2013 10:38 PM, David Williams wrote:
>> Hello,
>>
>> I am a victim of the bug causing microcode crashes on Intel 7260.  I
>> understand that new firmware is in the works that should resolve this.  I
>> have two questions:
>
> Please share iw list output and dmesg output
>
>>
>> 1) Is there any indication as to whether the new firmware/driver will make
>> it into the 3.10 or 3.12 kernels?
>>
>
> It is most probably a firmware issue - I'll know after you send the
> output I mentioned above.
>
>> 2) Is there a workaround using the existing firmware in the meantime?
>>
>
> I am not aware of any microcode error we can workaround in the driver.
> But you might be facing an issue I have never seen - please send the
> output and we'll see.
>
>> Thanks,
>>
>> Dave Williams
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
