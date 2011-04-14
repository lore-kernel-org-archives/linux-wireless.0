Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54253 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759095Ab1DNPLA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 11:11:00 -0400
Received: by bwz15 with SMTP id 15so1454897bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 08:10:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTin9Xp0oNkLANM0pkr7dyOCpEwow+g@mail.gmail.com>
References: <BANLkTimreffpSdBUogakk=E6Hn1Lf6KJ_w@mail.gmail.com>
 <BANLkTi=BgKRJXqM+8idBr-txCDPGFQSFhw@mail.gmail.com> <BANLkTi=Dtbhz=kGUSdH57JRG1DoRFP7kLw@mail.gmail.com>
 <201104131843.57676.chunkeey@googlemail.com> <BANLkTi=xyrWoYMeYCJjGhHgi=2W-CCBF7w@mail.gmail.com>
 <BANLkTi=mK2r_ZSStDhMSeHcFrx-jx=pN3A@mail.gmail.com> <BANLkTi=gTS5DvT+JMr35Q4puaqUaUy5Bww@mail.gmail.com>
 <BANLkTingZRChrOtSPbat6D69_nW=6DpADw@mail.gmail.com> <BANLkTin9Xp0oNkLANM0pkr7dyOCpEwow+g@mail.gmail.com>
From: Damian Lesiuk <lesiuk@gmail.com>
Date: Thu, 14 Apr 2011 17:10:19 +0200
Message-ID: <BANLkTi=ZyhsQDnhKBCfPbfqdYsqHXYpxtg@mail.gmail.com>
Subject: Re: carl9170: TP-LINK TL-WN822N slow connection speeds (16 mbps)
 MASTER MODE
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Btw I have that in dmesg.

------------[ cut here ]------------
WARNING: at /home/lesiuk/carl9170/compat-wireless-2011-03-31/drivers/net/wireless/ath/carl9170/tx.c:1301
carl9170_op_tx+0x4b2/0x663 [carl9170]()
Hardware name: hp t5000 series
Modules linked in: ipv6 iptable_filter ipt_MASQUERADE iptable_nat
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 ipt_addrtype xt_dscp xt_string
xt_multiport xt_hashlimit xt_conntrack xt_DSCP xt_NFQUEUE xt_mark
xt_connmark nf_conntrack ip_tables x_tables aes_i586 aes_generic arc4
ecb snd_intel8x0 ar9170usb snd_ac97_codec ac97_bus tpm_tis snd_pcm
carl9170 mac80211 ath cfg80211 sis_agp rfkill tpm snd_timer thermal
via_rhine tpm_bios ppdev rtc_cmos shpchp i2c_sis96x snd processor fan
i2c_core rtc_core thermal_sys parport_pc pcspkr snd_page_alloc
serio_raw pci_hotplug mii agpgart rtc_lib button tg3 libphy e1000 fuse
xfs exportfs nfs auth_rpcgss nfs_acl lockd sunrpc jfs raid10
dm_snapshot dm_crypt dm_mirror dm_region_hash dm_log dm_mod
scsi_wait_scan sl811_hcd usbhid ohci_hcd ssb mmc_core uhci_hcd
usb_storage ehci_hcd usbcore aic94xx libsas lpfc qla2xxx megaraid_sas
megaraid_mbox megaraid_mm megaraid aacraid sx8 DAC960 cciss 3w_9xxx
3w_xxxx mptsas scsi_transport_sas mptfc scsi_transport_fc scsi_tgt
mptspi mptscsih mptbase atp870u dc395x qla1280 imm parport dmx3191d
sym53c8xx qlogicfas408 gdth advansys initio BusLogic arcmsr aic7xxx
aic79xx scsi_transport_spi sg pdc_adma sata_inic162x sata_mv ata_piix
ahci libahci sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv
sata_via sata_svw sata_sil24 sata_sil sata_promise pata_pcmcia pcmcia
pcmcia_core
Pid: 12166, comm: rtorrent Not tainted 2.6.38-gentoo-r1 #1
Call Trace:
 [<c012ee27>] ? warn_slowpath_common+0x65/0x7a
 [<cf8e7197>] ? carl9170_op_tx+0x4b2/0x663 [carl9170]
 [<c012ee4b>] ? warn_slowpath_null+0xf/0x13
 [<cf8e7197>] ? carl9170_op_tx+0x4b2/0x663 [carl9170]
 [<cfb059ff>] ? __ieee80211_tx+0x140/0x184 [mac80211]
 [<cfb05aa3>] ? ieee80211_tx+0x60/0x6d [mac80211]
 [<cfb065b0>] ? ieee80211_tx_pending+0xe0/0x1a3 [mac80211]
 [<c013321f>] ? tasklet_action+0x67/0xcd
 [<c0133fee>] ? __do_softirq+0x9c/0x146
 [<c0133f52>] ? __do_softirq+0x0/0x146
 <IRQ>  [<c0133c16>] ? irq_exit+0x29/0x2b
 [<c01037cf>] ? do_IRQ+0x7c/0x90
 [<c0102d69>] ? common_interrupt+0x29/0x30
---[ end trace 44624f1ffb767c43 ]---
------------[ cut here ]------------
WARNING: at /home/lesiuk/carl9170/compat-wireless-2011-03-31/drivers/net/wireless/ath/carl9170/tx.c:1305
carl9170_op_tx+0x4f2/0x663 [carl9170]()
Hardware name: hp t5000 series
Modules linked in: ipv6 iptable_filter ipt_MASQUERADE iptable_nat
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 ipt_addrtype xt_dscp xt_string
xt_multiport xt_hashlimit xt_conntrack xt_DSCP xt_NFQUEUE xt_mark
xt_connmark nf_conntrack ip_tables x_tables aes_i586 aes_generic arc4
ecb snd_intel8x0 ar9170usb snd_ac97_codec ac97_bus tpm_tis snd_pcm
carl9170 mac80211 ath cfg80211 sis_agp rfkill tpm snd_timer thermal
via_rhine tpm_bios ppdev rtc_cmos shpchp i2c_sis96x snd processor fan
i2c_core rtc_core thermal_sys parport_pc pcspkr snd_page_alloc
serio_raw pci_hotplug mii agpgart rtc_lib button tg3 libphy e1000 fuse
xfs exportfs nfs auth_rpcgss nfs_acl lockd sunrpc jfs raid10
dm_snapshot dm_crypt dm_mirror dm_region_hash dm_log dm_mod
scsi_wait_scan sl811_hcd usbhid ohci_hcd ssb mmc_core uhci_hcd
usb_storage ehci_hcd usbcore aic94xx libsas lpfc qla2xxx megaraid_sas
megaraid_mbox megaraid_mm megaraid aacraid sx8 DAC960 cciss 3w_9xxx
3w_xxxx mptsas scsi_transport_sas mptfc scsi_transport_fc scsi_tgt
mptspi mptscsih mptbase atp870u dc395x qla1280 imm parport dmx3191d
sym53c8xx qlogicfas408 gdth advansys initio BusLogic arcmsr aic7xxx
aic79xx scsi_transport_spi sg pdc_adma sata_inic162x sata_mv ata_piix
ahci libahci sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv
sata_via sata_svw sata_sil24 sata_sil sata_promise pata_pcmcia pcmcia
pcmcia_core
Pid: 12166, comm: rtorrent Tainted: G        W   2.6.38-gentoo-r1 #1
Call Trace:
 [<c012ee27>] ? warn_slowpath_common+0x65/0x7a
 [<cf8e71d7>] ? carl9170_op_tx+0x4f2/0x663 [carl9170]
 [<c012ee4b>] ? warn_slowpath_null+0xf/0x13
 [<cf8e71d7>] ? carl9170_op_tx+0x4f2/0x663 [carl9170]
 [<cfb059ff>] ? __ieee80211_tx+0x140/0x184 [mac80211]
 [<cfb05aa3>] ? ieee80211_tx+0x60/0x6d [mac80211]
 [<cfb065b0>] ? ieee80211_tx_pending+0xe0/0x1a3 [mac80211]
 [<c013321f>] ? tasklet_action+0x67/0xcd
 [<c0133fee>] ? __do_softirq+0x9c/0x146
 [<c0133f52>] ? __do_softirq+0x0/0x146
 <IRQ>  [<c0133c16>] ? irq_exit+0x29/0x2b
 [<c01037cf>] ? do_IRQ+0x7c/0x90
 [<c0102d69>] ? common_interrupt+0x29/0x30
---[ end trace 44624f1ffb767c44 ]---

2011/4/14 Damian Lesiuk <lesiuk@gmail.com>:
> I have draft N router next to that device.
> He is working at 1 channel. I can easily reach 100 mbps with him.
>
> I changed channel to 11 and I have MSC 5.
>
> I have Azurewave NB290 in my notebook.
> But I tested it also with Atheros 9280 and connection here was very
> bad (8 mbps).
>
> 2011/4/14 Helmut Schaa <helmut.schaa@googlemail.com>:
>> On Thu, Apr 14, 2011 at 4:40 PM, Damian Lesiuk <lesiuk@gmail.com> wrote:
>>> uniwersytecka-server ~ # iw wlan0 station dump
>>> Station 74:f0:6d:33:ea:00 (on wlan0)
>>>       inactive time:  20 ms
>>>       rx bytes:       5043668
>>>       rx packets:     9305
>>>       tx bytes:       13762256
>>>       tx packets:     11634
>>>       signal:         -31 dBm
>>>       tx bitrate:     65.0 MBit/s MCS 7
>>>
>>> So it helped in some way.
>>> Why that network isn't 300 mbps?
>>
>> 300mbps is only possible in HT40 mode. However, hostapd will disable
>> HT40 if it detects
>> an other HT40 AP on an overlapping channel (in your case anything
>> !=7). This is also
>> in accordance with 802.11n-2009.
>>
>> Hostapd will print "40 MHz pri/sec mismatch with BSS ..." in that case.
>>
>> Furthermore, it seems that the station 74:f0:6d:33:ea:00 isn't capable
>> of using multiple
>> spacial streams and thus is limited to MCS7. What client device is this?
>>
>> Helmut
>>
>
