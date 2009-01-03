Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:43108 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758339AbZACS6q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jan 2009 13:58:46 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LJBhr-0004pR-PR
	for linux-wireless@vger.kernel.org; Sat, 03 Jan 2009 18:58:43 +0000
Received: from 77.21.169.220 ([77.21.169.220])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 03 Jan 2009 18:58:43 +0000
Received: from feldmann_markus by 77.21.169.220 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 03 Jan 2009 18:58:43 +0000
To: linux-wireless@vger.kernel.org
From: feldmaus <feldmann_markus@gmx.de>
Subject: Re: Do not get BCM4303 to work
Date: Sat, 03 Jan 2009 20:00:04 +0100
Message-ID: <gjocgr$g7$1@ger.gmane.org> (sfid-20090103_195849_255215_82E762C6)
References: <ga2fra$9q$1@ger.gmane.org> <gjob72$t2j$1@ger.gmane.org> <gjobt8$v22$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
In-Reply-To: <gjobt8$v22$1@ger.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I forgot to send my loaded modules.

The following Modules are loaded:
Module                  Size  Used by
nvidia               4699728  22
rfkill_input            4352  0
rfcomm                 29460  0
l2cap                  16772  5 rfcomm
bluetooth              45284  4 rfcomm,l2cap
ipv6                  221120  12
ipt_LOG                 4864  1
ipt_MASQUERADE          2560  1
xt_tcpudp               2816  33
xt_state                2048  4
ppdev                   6404  0
lp                      7916  0
powernow_k8            10764  0
cpufreq_userspace       2712  0
cpufreq_stats           3076  0
cpufreq_powersave       1536  0
cpufreq_ondemand        6016  1
freq_table              4100  3 powernow_k8,cpufreq_stats,cpufreq_ondemand
cpufreq_conservative     5280  0
iptable_filter          2560  1
nls_utf8                1792  1
nls_cp437               5504  1
vfat                    8832  1
fat                    42268  1 vfat
nls_base                6400  4 nls_utf8,nls_cp437,vfat,fat
iptable_nat             4868  1
ip_tables               9744  2 iptable_filter,iptable_nat
nf_nat                 15884  2 ipt_MASQUERADE,iptable_nat
x_tables               13060  6 
ipt_LOG,ipt_MASQUERADE,xt_tcpudp,xt_state,iptable_nat,ip_tables
nf_conntrack_ipv4      11532  7 iptable_nat,nf_nat
nf_conntrack           55744  5 
ipt_MASQUERADE,xt_state,iptable_nat,nf_nat,nf_conntrack_ipv4
nf_defrag_ipv4          1920  1 nf_conntrack_ipv4
loop                   12556  0
joydev                  8512  0
arc4                    1792  2
ecb                     2560  2
b43legacy              99356  0
rfkill                  9648  3 rfkill_input,b43legacy
rng_core                3844  1 b43legacy
mac80211              134172  1 b43legacy
snd_intel8x0m          12172  0
snd_pcm_oss            31776  0
snd_mixer_oss          12160  1 snd_pcm_oss
psmouse                37520  0
snd_intel8x0           25884  1
snd_ac97_codec         91556  2 snd_intel8x0m,snd_intel8x0
ac97_bus                1664  1 snd_ac97_codec
snd_pcm                61192  4 
snd_intel8x0m,snd_pcm_oss,snd_intel8x0,snd_ac97_codec
parport_pc             22160  1
parport                30024  3 ppdev,lp,parport_pc
serio_raw               4740  0
cfg80211               26640  1 mac80211
led_class               3844  1 b43legacy
input_polldev           3720  1 b43legacy
pcspkr                  2304  0
yenta_socket           21388  2
rsrc_nonstatic          9728  1 yenta_socket
wmi                     6568  0
video                  16528  0
output                  2816  1 video
battery                10116  0
snd_seq_dummy           2692  0
container               3456  0
ac                      4100  0
button                  6032  0
snd_seq_oss            25236  0
k8temp                  3968  0
snd_seq_midi            5792  0
snd_rawmidi            18720  1 snd_seq_midi
shpchp                 27156  0
snd_seq_midi_event      6528  2 snd_seq_oss,snd_seq_midi
snd_seq                42144  6 
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
pci_hotplug            23456  1 shpchp
snd_timer              17540  2 snd_pcm,snd_seq
snd_seq_device          6412  5 
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
snd                    44980  13 
snd_intel8x0m,snd_pcm_oss,snd_mixer_oss,snd_intel8x0,snd_ac97_codec,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
amd64_agp               9096  1
soundcore               5956  1 snd
snd_page_alloc          8072  3 snd_intel8x0m,snd_intel8x0,snd_pcm
i2c_nforce2             6144  0
i2c_core               20880  2 nvidia,i2c_nforce2
agpgart                30128  2 nvidia,amd64_agp
evdev                   8068  7
ext2                   52104  2
mbcache                 6784  1 ext2
ide_cd_mod             31496  0
ide_gd_mod             13060  5
cdrom                  29848  1 ide_cd_mod
ata_generic             4612  0
libata                149472  1 ata_generic
scsi_mod              136208  1 libata
ide_pci_generic         3588  0
b44                    22800  0
usbhid                 28244  0
hid                    33868  1 usbhid
ssb                    34692  2 b43legacy,b44
8139too                21120  0
ohci1394               25776  0
pcmcia                 30388  1 ssb
pcmcia_core            30992  4 yenta_socket,rsrc_nonstatic,ssb,pcmcia
8139cp                 17664  0
mii                     4864  3 b44,8139too,8139cp
ieee1394               74684  1 ohci1394
amd74xx                 5640  4
ide_core               94748  4 
ide_cd_mod,ide_gd_mod,ide_pci_generic,amd74xx
ehci_hcd               29964  0
ohci_hcd               20240  0
usbcore               121408  4 usbhid,ehci_hcd,ohci_hcd
thermal                15260  0
processor              35376  3 powernow_k8,thermal
fan                     4356  0
thermal_sys            10528  4 video,thermal,processor,fan

Regards Markus

