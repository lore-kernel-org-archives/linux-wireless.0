Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:41450 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753023AbeFDN2w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Jun 2018 09:28:52 -0400
Received: from t19.piap.pl (OSB1819.piap.pl [10.0.9.19])
        by ni.piap.pl (Postfix) with ESMTP id 6EEC44403A0
        for <linux-wireless@vger.kernel.org>; Mon,  4 Jun 2018 15:19:06 +0200 (CEST)
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-wireless@vger.kernel.org
Subject: Linux 4.17 iwlwifi IBSS AC 8265 Microcode SW error detected.  Restarting 0x2000000
Date: Mon, 04 Jun 2018 15:19:06 +0200
Message-ID: <m3r2lmn0z9.fsf@t19.piap.pl> (sfid-20180604_152857_927540_48BF08B2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm unable to make this setup work:
Linux x86-64 4.17
iwlwifi-8265-36.ucode, 2498044 bytes

iw dev wlan0 set type ibss
ip link set up dev wlan0
iw dev wlan0 set bitrates legacy-2.4 6 ht-mcs-2.4 8
iw dev wlan0 ibss join xyz 2462

Any ideas?

I have removed irrelevant parts, but everything is available on request.

iwlwifi 0000:01:00.0: Detected Intel(R) Dual Band Wireless AC 8265, REV=0x230
iwlwifi 0000:01:00.0: base HW address: d4:6d:6d:b1:f1:25
ieee80211 phy6: Selected rate control algorithm 'iwl-mvm-rs'
thermal thermal_zone1: failed to read out thermal zone (-61)
wlan0: Trigger new scan to find an IBSS to join
...
wlan0: Creating new IBSS network, BSSID f2:b6:b4:b7:1d:4b
iwlwifi 0000:01:00.0: regular scan timed out
iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting 0x2000000.
iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
iwlwifi 0000:01:00.0: Status: 0x00000100, count: 6
iwlwifi 0000:01:00.0: Loaded firmware version: 36.e91976c0.0
iwlwifi 0000:01:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN
iwlwifi 0000:01:00.0: 0x000002F0 | trm_hw_status0
iwlwifi 0000:01:00.0: 0x00000000 | trm_hw_status1
iwlwifi 0000:01:00.0: 0x000248DC | branchlink2
iwlwifi 0000:01:00.0: 0x0003A7DA | interruptlink1
iwlwifi 0000:01:00.0: 0x0003A7DA | interruptlink2
iwlwifi 0000:01:00.0: 0x00000000 | data1
iwlwifi 0000:01:00.0: 0x00000080 | data2
iwlwifi 0000:01:00.0: 0x07830000 | data3
iwlwifi 0000:01:00.0: 0xFFE27F31 | beacon time
iwlwifi 0000:01:00.0: 0x01CE58A0 | tsf low
iwlwifi 0000:01:00.0: 0x00000000 | tsf hi
iwlwifi 0000:01:00.0: 0x00000000 | time gp1
iwlwifi 0000:01:00.0: 0x02744DB0 | time gp2
iwlwifi 0000:01:00.0: 0x00000001 | uCode revision type
iwlwifi 0000:01:00.0: 0x00000024 | uCode version major
iwlwifi 0000:01:00.0: 0xE91976C0 | uCode version minor
iwlwifi 0000:01:00.0: 0x00000230 | hw version
iwlwifi 0000:01:00.0: 0x18489000 | board version
iwlwifi 0000:01:00.0: 0x0000001C | hcmd
iwlwifi 0000:01:00.0: 0x00022000 | isr0
iwlwifi 0000:01:00.0: 0x00800000 | isr1
iwlwifi 0000:01:00.0: 0x08005802 | isr2
iwlwifi 0000:01:00.0: 0x00415CC0 | isr3
iwlwifi 0000:01:00.0: 0x00000000 | isr4
iwlwifi 0000:01:00.0: 0x8032FB03 | last cmd Id
iwlwifi 0000:01:00.0: 0x00000000 | wait_event
iwlwifi 0000:01:00.0: 0x00006E99 | l2p_control
iwlwifi 0000:01:00.0: 0x00000020 | l2p_duration
iwlwifi 0000:01:00.0: 0x00000003 | l2p_mhvalid
iwlwifi 0000:01:00.0: 0x00000020 | l2p_addr_match
iwlwifi 0000:01:00.0: 0x0000000D | lmpm_pmg_sel
iwlwifi 0000:01:00.0: 0x28031619 | timestamp
iwlwifi 0000:01:00.0: 0x00348898 | flow_handler
iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
iwlwifi 0000:01:00.0: Status: 0x00000100, count: 7
iwlwifi 0000:01:00.0: 0x00000070 | ADVANCED_SYSASSERT
iwlwifi 0000:01:00.0: 0x00000000 | umac branchlink1
iwlwifi 0000:01:00.0: 0xC008689C | umac branchlink2
iwlwifi 0000:01:00.0: 0xC0083A94 | umac interruptlink1
iwlwifi 0000:01:00.0: 0xC0083A94 | umac interruptlink2
iwlwifi 0000:01:00.0: 0x00000800 | umac data1
iwlwifi 0000:01:00.0: 0xC0083A94 | umac data2
iwlwifi 0000:01:00.0: 0xDEADBEEF | umac data3
iwlwifi 0000:01:00.0: 0x00000024 | umac major
iwlwifi 0000:01:00.0: 0xE91976C0 | umac minor
iwlwifi 0000:01:00.0: 0xC088628C | frame pointer
iwlwifi 0000:01:00.0: 0xC088628C | stack pointer
iwlwifi 0000:01:00.0: 0x0033010D | last host cmd
iwlwifi 0000:01:00.0: 0x00000000 | isr status reg
ieee80211 phy6: Hardware restart was requested
------------[ cut here ]------------
Changing inactive MAC d4:6d:6d:b1:f1:25/1
WARNING: CPU: 2 PID: 304 at drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c:1326 iwl_mvm_mac_ctxt_changed+0x73/0x90 [iwlmvm]
Hardware name: GETAC F110G4/F110G4, BIOS R1.08.070520 03/07/2018
RIP: 0010:iwl_mvm_mac_ctxt_changed+0x73/0x90 [iwlmvm]
Call Trace:
 iwl_mvm_bss_info_changed+0x494/0x6a0 [iwlmvm]
 ? iwl_mvm_assign_vif_chanctx+0x40/0x50 [iwlmvm]
 ieee80211_bss_info_change_notify+0x78/0xc0
 ieee80211_reconfig+0x61a/0xc50
 ieee80211_restart_work+0x9e/0xd0
 process_one_work+0x15c/0x300
 worker_thread+0x30/0x3a0
 ? process_one_work+0x300/0x300
 kthread+0x10d/0x130
 ? kthread_flush_work_fn+0x10/0x10
 ret_from_fork+0x1f/0x30
---[ end trace d84041e0ec387e49 ]---
iwlwifi 0000:01:00.0: failed to update MAC d4:6d:6d:b1:f1:25
iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting 0x2000000.
iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
iwlwifi 0000:01:00.0: Status: 0x00000100, count: 6
iwlwifi 0000:01:00.0: Loaded firmware version: 36.e91976c0.0
iwlwifi 0000:01:00.0: 0x00003018 | ADVANCED_SYSASSERT
iwlwifi 0000:01:00.0: 0x00A002F1 | trm_hw_status0
iwlwifi 0000:01:00.0: 0x00000000 | trm_hw_status1
iwlwifi 0000:01:00.0: 0x000248DC | branchlink2
iwlwifi 0000:01:00.0: 0x0003A7DA | interruptlink1
iwlwifi 0000:01:00.0: 0x00000000 | interruptlink2
iwlwifi 0000:01:00.0: 0x00000000 | data1
iwlwifi 0000:01:00.0: 0x00000080 | data2
iwlwifi 0000:01:00.0: 0x00000000 | data3
iwlwifi 0000:01:00.0: 0x00000000 | beacon time
iwlwifi 0000:01:00.0: 0x0000AC17 | tsf low
iwlwifi 0000:01:00.0: 0x00000000 | tsf hi
iwlwifi 0000:01:00.0: 0x00000000 | time gp1
iwlwifi 0000:01:00.0: 0x0000AC17 | time gp2
iwlwifi 0000:01:00.0: 0x00000001 | uCode revision type
iwlwifi 0000:01:00.0: 0x00000024 | uCode version major
iwlwifi 0000:01:00.0: 0xE91976C0 | uCode version minor
iwlwifi 0000:01:00.0: 0x00000230 | hw version
iwlwifi 0000:01:00.0: 0x18489000 | board version
iwlwifi 0000:01:00.0: 0x0026012C | hcmd
iwlwifi 0000:01:00.0: 0x00122080 | isr0
iwlwifi 0000:01:00.0: 0x00000000 | isr1
iwlwifi 0000:01:00.0: 0x08201802 | isr2
iwlwifi 0000:01:00.0: 0x004000C0 | isr3
iwlwifi 0000:01:00.0: 0x00000000 | isr4
iwlwifi 0000:01:00.0: 0x0025019F | last cmd Id
iwlwifi 0000:01:00.0: 0x00000000 | wait_event
iwlwifi 0000:01:00.0: 0x00006E99 | l2p_control
iwlwifi 0000:01:00.0: 0x00000820 | l2p_duration
iwlwifi 0000:01:00.0: 0x00000000 | l2p_mhvalid
iwlwifi 0000:01:00.0: 0x00000000 | l2p_addr_match
iwlwifi 0000:01:00.0: 0x0000000D | lmpm_pmg_sel
iwlwifi 0000:01:00.0: 0x28031619 | timestamp
iwlwifi 0000:01:00.0: 0x00002030 | flow_handler
iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
iwlwifi 0000:01:00.0: Status: 0x00000100, count: 7
iwlwifi 0000:01:00.0: 0x00000070 | ADVANCED_SYSASSERT
iwlwifi 0000:01:00.0: 0x00000000 | umac branchlink1
iwlwifi 0000:01:00.0: 0xC008689C | umac branchlink2
iwlwifi 0000:01:00.0: 0xC0083A94 | umac interruptlink1
iwlwifi 0000:01:00.0: 0xC0083A94 | umac interruptlink2
iwlwifi 0000:01:00.0: 0x00000800 | umac data1
iwlwifi 0000:01:00.0: 0xC0083A94 | umac data2
iwlwifi 0000:01:00.0: 0xDEADBEEF | umac data3
iwlwifi 0000:01:00.0: 0x00000024 | umac major
iwlwifi 0000:01:00.0: 0xE91976C0 | umac minor
iwlwifi 0000:01:00.0: 0xC088628C | frame pointer
iwlwifi 0000:01:00.0: 0xC088628C | stack pointer
iwlwifi 0000:01:00.0: 0x0026012C | last host cmd
iwlwifi 0000:01:00.0: 0x00000000 | isr status reg
ieee80211 phy6: Hardware restart was requested
iwlwifi 0000:01:00.0: iwlwifi transaction failed, dumping registers
iwlwifi 0000:01:00.0: iwlwifi device config registers:
iwlwifi 0000:01:00.0: 00000000: 24fd8086 00100406 02800078 00000010 b1000004 00000000 00000000 00000000
iwlwifi 0000:01:00.0: 00000020: 00000000 00000000 00000000 00108086 00000000 000000c8 00000000 000001ff
iwlwifi 0000:01:00.0: iwlwifi device memory mapped registers:
iwlwifi 0000:01:00.0: 00000000: 18489000 0000ff40 00000000 ba00008b 00000000 00000000 00000010 00000000
iwlwifi 0000:01:00.0: 00000020: 00000000 08040005 00000230 d55555d5 d55555d5 d55555d5 80008040 041f0042
iwlwifi 0000:01:00.0: iwlwifi device AER capability structure:
iwlwifi 0000:01:00.0: 00000000: 14010001 00000000 00000000 00462031 00000000 00002000 00000000 00000000
iwlwifi 0000:01:00.0: 00000020: 00000000 00000000 00000000
iwlwifi 0000:01:00.0: iwlwifi parent port (0000:00:1c.0) config registers:
iwlwifi 0000:00:1c.0: 00000000: 9d128086 00100407 060400f1 00810010 00000000 00000000 00010100 200000f0
iwlwifi 0000:00:1c.0: 00000020: b100b100 0001fff1 00000000 00000000 00000000 00000040 00000000 000003ff
iwlwifi 0000:01:00.0: iwlwifi root port (0000:00:1c.0) AER cap structure:
iwlwifi 0000:00:1c.0: 00000000: 14010001 00000000 00010000 00060011 00000000 00002000 00000014 40000001
iwlwifi 0000:00:1c.0: 00000020: 01001e0f fee002d8 00000000 00000007 00000000 00000000
iwlwifi 0000:01:00.0: FW error in SYNC CMD TIME_QUOTA_CMD

-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
