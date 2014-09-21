Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:64497 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbaIULla (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2014 07:41:30 -0400
Message-ID: <541EB95C.2040903@gmx.de> (sfid-20140921_134144_751197_D7270A8F)
Date: Sun, 21 Sep 2014 13:41:16 +0200
From: Andreas <andreas-mrosek@gmx.de>
MIME-Version: 1.0
To: johannes.berg@intel.com, ilw@linux.intel.com,
	linux-wireless@vger.kernel.org
CC: christopher.m.penalver@gmail.com
Subject: Bug reported in Launchpad: Asus TP300LA no wifi with Intel AC 7260
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

on my Asus TP300 LA-C 4023H Wifi with the Intel Ac 7260 dosnt work. I 
have reported the Problem in Launchpad 
bugs.launchpad.net/ubuntu/+source/linux/+bug/1369701 
<launchpad.net/ubuntu/+source/linux/+bug/1369701>.

cat /proc/version
Linux version 3.17.0-031700rc5-generic (apw@gomeisa) (gcc version 4.6.3 
(Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201409151105 SMP Mon Sep 15 15:08:10 
UTC 2014


lsb_release -rd
Description:    Ubuntu 14.04.1 LTS
Release:    14.04



sh ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux r2d2 3.17.0-031700rc5-generic #201409151105 SMP Mon Sep 15 
15:08:10 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

Gnu C                  4.8
Gnu make               3.81
binutils               2.24
util-linux             2.20.1
mount                  support
module-init-tools      15
e2fsprogs              1.42.9
pcmciautils            018
Linux C Library        2.19
Dynamic linker (ldd)   2.19
Procps                 3.3.9
Net-tools              1.60
Kbd                    1.15.5
Sh-utils               8.21
wireless-tools         30
Modules Loaded         ctr ccm dm_crypt rfcomm bnep arc4 intel_rapl 
x86_pkg_temp_thermal intel_powerclamp coretemp asus_nb_wmi kvm_intel 
rtl8192cu asus_wmi sparse_keymap joydev nls_iso8859_1 rtl_usb 
snd_hda_codec_realtek rtlwifi kvm rtl8192c_common snd_hda_codec_generic 
mac80211 snd_hda_codec_hdmi crct10dif_pclmul crc32_pclmul 
ghash_clmulni_intel uvcvideo aesni_intel videobuf2_vmalloc 
videobuf2_memops snd_soc_rt5640 snd_hda_intel snd_hda_controller 
snd_soc_rl6231 aes_x86_64 videobuf2_core lrw snd_hda_codec gf128mul 
cfg80211 glue_helper ablk_helper cryptd v4l2_common snd_soc_core 
snd_hwdep videodev snd_compress snd_pcm_dmaengine btusb media bluetooth 
serio_raw snd_pcm hid_multitouch lpc_ich snd_seq_midi mei_me 
snd_seq_midi_event mei snd_rawmidi snd_seq snd_seq_device snd_timer 
ak8975 snd i2c_hid snd_soc_sst_acpi industrialio soundcore dw_dmac 
dw_dmac_core 8250_dw spi_pxa2xx_platform i2c_designware_platform 
i2c_designware_core mac_hid parport_pc ppdev lp parport hid_generic 
usbhid hid i915 i2c_algo_bit drm_kms_helper psmouse ahci drm libahci wmi 
video sdhci_acpi sdhci
augustus@r2d2:/usr/src/linux-headers-3.17.0-031700rc5-generic/scripts$


cat /proc/cpuinfo
processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 69
model name    : Intel(R) Core(TM) i5-4210U CPU @ 1.70GHz
stepping    : 1
microcode    : 0x17
cpu MHz        : 2400.093
cache size    : 3072 KB
physical id    : 0
siblings    : 4
core id        : 0
cpu cores    : 2
apicid        : 0
initial apicid    : 0
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall 
nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl 
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor 
ds_cpl vmx est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 movbe 
popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm ida arat 
epb pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase 
tsc_adjust bmi1 avx2 smep bmi2 erms invpcid xsaveopt
bugs        :
bogomips    : 4789.24
clflush size    : 64
cache_alignment    : 64
address sizes    : 39 bits physical, 48 bits virtual
power management:

processor    : 1
vendor_id    : GenuineIntel
cpu family    : 6
model        : 69
model name    : Intel(R) Core(TM) i5-4210U CPU @ 1.70GHz
stepping    : 1
microcode    : 0x17
cpu MHz        : 2499.468
cache size    : 3072 KB
physical id    : 0
siblings    : 4
core id        : 1
cpu cores    : 2
apicid        : 2
initial apicid    : 2
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall 
nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl 
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor 
ds_cpl vmx est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 movbe 
popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm ida arat 
epb pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase 
tsc_adjust bmi1 avx2 smep bmi2 erms invpcid xsaveopt
bugs        :
bogomips    : 4789.24
clflush size    : 64
cache_alignment    : 64
address sizes    : 39 bits physical, 48 bits virtual
power management:

processor    : 2
vendor_id    : GenuineIntel
cpu family    : 6
model        : 69
model name    : Intel(R) Core(TM) i5-4210U CPU @ 1.70GHz
stepping    : 1
microcode    : 0x17
cpu MHz        : 2400.187
cache size    : 3072 KB
physical id    : 0
siblings    : 4
core id        : 0
cpu cores    : 2
apicid        : 1
initial apicid    : 1
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall 
nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl 
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor 
ds_cpl vmx est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 movbe 
popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm ida arat 
epb pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase 
tsc_adjust bmi1 avx2 smep bmi2 erms invpcid xsaveopt
bugs        :
bogomips    : 4789.24
clflush size    : 64
cache_alignment    : 64
address sizes    : 39 bits physical, 48 bits virtual
power management:

processor    : 3
vendor_id    : GenuineIntel
cpu family    : 6
model        : 69
model name    : Intel(R) Core(TM) i5-4210U CPU @ 1.70GHz
stepping    : 1
microcode    : 0x17
cpu MHz        : 2413.406
cache size    : 3072 KB
physical id    : 0
siblings    : 4
core id        : 1
cpu cores    : 2
apicid        : 3
initial apicid    : 3
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall 
nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl 
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor 
ds_cpl vmx est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 movbe 
popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm ida arat 
epb pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase 
tsc_adjust bmi1 avx2 smep bmi2 erms invpcid xsaveopt
bugs        :
bogomips    : 4789.24
clflush size    : 64
cache_alignment    : 64
address sizes    : 39 bits physical, 48 bits virtual
power management:

augustus@r2d2:~$


cat /proc/modules
ctr 13193 2 - Live 0x0000000000000000
ccm 17856 2 - Live 0x0000000000000000
dm_crypt 23456 0 - Live 0x0000000000000000
rfcomm 75114 0 - Live 0x0000000000000000
bnep 19884 2 - Live 0x0000000000000000
arc4 12573 2 - Live 0x0000000000000000
intel_rapl 19196 0 - Live 0x0000000000000000
x86_pkg_temp_thermal 14312 0 - Live 0x0000000000000000
intel_powerclamp 19099 0 - Live 0x0000000000000000
coretemp 13638 0 - Live 0x0000000000000000
asus_nb_wmi 21128 0 - Live 0x0000000000000000
kvm_intel 149257 0 - Live 0x0000000000000000
rtl8192cu 68579 0 - Live 0x0000000000000000
asus_wmi 24697 1 asus_nb_wmi, Live 0x0000000000000000
sparse_keymap 13890 1 asus_wmi, Live 0x0000000000000000
joydev 17587 0 - Live 0x0000000000000000
nls_iso8859_1 12713 1 - Live 0x0000000000000000
rtl_usb 22809 1 rtl8192cu, Live 0x0000000000000000
snd_hda_codec_realtek 78564 1 - Live 0x0000000000000000
rtlwifi 69157 2 rtl8192cu,rtl_usb, Live 0x0000000000000000
kvm 468567 1 kvm_intel, Live 0x0000000000000000
rtl8192c_common 58270 1 rtl8192cu, Live 0x0000000000000000
snd_hda_codec_generic 70087 1 snd_hda_codec_realtek, Live 0x0000000000000000
mac80211 696913 3 rtl8192cu,rtl_usb,rtlwifi, Live 0x0000000000000000
snd_hda_codec_hdmi 52620 1 - Live 0x0000000000000000
crct10dif_pclmul 14268 0 - Live 0x0000000000000000
crc32_pclmul 13180 0 - Live 0x0000000000000000
ghash_clmulni_intel 13230 0 - Live 0x0000000000000000
uvcvideo 86628 0 - Live 0x0000000000000000
aesni_intel 165515 4 - Live 0x0000000000000000
videobuf2_vmalloc 13216 1 uvcvideo, Live 0x0000000000000000
videobuf2_memops 13362 1 videobuf2_vmalloc, Live 0x0000000000000000
snd_soc_rt5640 93123 0 - Live 0x0000000000000000
snd_hda_intel 30783 5 - Live 0x0000000000000000
snd_hda_controller 32234 1 snd_hda_intel, Live 0x0000000000000000
snd_soc_rl6231 13037 1 snd_soc_rt5640, Live 0x0000000000000000
aes_x86_64 17131 1 aesni_intel, Live 0x0000000000000000
videobuf2_core 59907 1 uvcvideo, Live 0x0000000000000000
lrw 13323 1 aesni_intel, Live 0x0000000000000000
snd_hda_codec 145035 5 
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_controller, 
Live 0x0000000000000000
gf128mul 14951 1 lrw, Live 0x0000000000000000
cfg80211 514757 2 rtlwifi,mac80211, Live 0x0000000000000000
glue_helper 14095 1 aesni_intel, Live 0x0000000000000000
ablk_helper 13597 1 aesni_intel, Live 0x0000000000000000
cryptd 20531 3 ghash_clmulni_intel,aesni_intel,ablk_helper, Live 
0x0000000000000000
v4l2_common 15715 1 videobuf2_core, Live 0x0000000000000000
snd_soc_core 207547 1 snd_soc_rt5640, Live 0x0000000000000000
snd_hwdep 17709 1 snd_hda_codec, Live 0x0000000000000000
videodev 163831 3 uvcvideo,videobuf2_core,v4l2_common, Live 
0x0000000000000000
snd_compress 19435 1 snd_soc_core, Live 0x0000000000000000
snd_pcm_dmaengine 15229 1 snd_soc_core, Live 0x0000000000000000
btusb 32408 0 - Live 0x0000000000000000
media 22008 2 uvcvideo,videodev, Live 0x0000000000000000
bluetooth 477455 11 rfcomm,bnep,btusb, Live 0x0000000000000000
serio_raw 13483 0 - Live 0x0000000000000000
snd_pcm 105052 7 
snd_hda_codec_hdmi,snd_soc_rt5640,snd_hda_intel,snd_hda_controller,snd_hda_codec,snd_soc_core,snd_pcm_dmaengine, 
Live 0x0000000000000000
hid_multitouch 17657 0 - Live 0x0000000000000000
lpc_ich 21176 0 - Live 0x0000000000000000
snd_seq_midi 13564 0 - Live 0x0000000000000000
mei_me 19524 0 - Live 0x0000000000000000
snd_seq_midi_event 14899 1 snd_seq_midi, Live 0x0000000000000000
mei 88810 1 mei_me, Live 0x0000000000000000
snd_rawmidi 31197 1 snd_seq_midi, Live 0x0000000000000000
snd_seq 63540 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
snd_seq_device 14497 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 
0x0000000000000000
snd_timer 30118 2 snd_pcm,snd_seq, Live 0x0000000000000000
ak8975 13391 0 - Live 0x0000000000000000
snd 84025 23 
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_soc_core,snd_hwdep,snd_compress,snd_pcm,snd_rawmidi,snd_seq,snd_seq_device,snd_timer, 
Live 0x0000000000000000
i2c_hid 19065 0 - Live 0x0000000000000000
snd_soc_sst_acpi 13007 0 - Live 0x0000000000000000
industrialio 55409 1 ak8975, Live 0x0000000000000000
soundcore 15091 2 snd_hda_codec,snd, Live 0x0000000000000000
dw_dmac 12835 0 - Live 0x0000000000000000
dw_dmac_core 28566 1 dw_dmac, Live 0x0000000000000000
8250_dw 13474 0 - Live 0x0000000000000000
spi_pxa2xx_platform 23302 0 - Live 0x0000000000000000
i2c_designware_platform 13025 0 - Live 0x0000000000000000
i2c_designware_core 14990 1 i2c_designware_platform, Live 0x0000000000000000
mac_hid 13275 0 - Live 0x0000000000000000
parport_pc 32906 0 - Live 0x0000000000000000
ppdev 17711 0 - Live 0x0000000000000000
lp 17799 0 - Live 0x0000000000000000
parport 42481 3 parport_pc,ppdev,lp, Live 0x0000000000000000
hid_generic 12559 0 - Live 0x0000000000000000
usbhid 53122 0 - Live 0x0000000000000000
hid 110572 4 hid_multitouch,i2c_hid,hid_generic,usbhid, Live 
0x0000000000000000
i915 993210 6 - Live 0x0000000000000000
i2c_algo_bit 13564 1 i915, Live 0x0000000000000000
drm_kms_helper 99872 1 i915, Live 0x0000000000000000
psmouse 118039 0 - Live 0x0000000000000000
ahci 30167 4 - Live 0x0000000000000000
drm 318542 5 i915,drm_kms_helper, Live 0x0000000000000000
libahci 32533 1 ahci, Live 0x0000000000000000
wmi 19379 1 asus_wmi, Live 0x0000000000000000
video 20569 2 asus_wmi,i915, Live 0x0000000000000000
sdhci_acpi 13395 0 - Live 0x0000000000000000
sdhci 44159 1 sdhci_acpi, Live 0x0000000000000000
augustus@r2d2:~$


cat /proc/ioports
0000-0cf7 : PCI Bus 0000:00
   0000-001f : dma1
   0020-0021 : pic1
   0040-0043 : timer0
   0050-0053 : timer1
   0060-0060 : keyboard
   0062-0062 : PNP0C09:00
     0062-0062 : EC data
   0064-0064 : keyboard
   0066-0066 : PNP0C09:00
     0066-0066 : EC cmd
   0070-0077 : rtc0
   0080-008f : dma page reg
   00a0-00a1 : pic2
   00c0-00df : dma2
   00f0-00ff : fpu
   0240-0259 : pnp 00:05
   04d0-04d1 : pnp 00:04
   0680-069f : pnp 00:01
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
   164e-164f : pnp 00:01
   1800-1803 : ACPI PM1a_EVT_BLK
   1804-1805 : ACPI PM1a_CNT_BLK
   1808-180b : ACPI PM_TMR
   1810-1815 : ACPI CPU throttle
   1830-1833 : iTCO_wdt
   1850-1850 : ACPI PM2_CNT_BLK
   1854-1857 : pnp 00:03
   1860-187f : iTCO_wdt
   1880-189f : ACPI GPE0_BLK
   1c00-1fff : INT33C7:00
     1c00-1fff : lp-gpio
   f000-f03f : 0000:00:02.0
   f040-f05f : 0000:00:1f.3
   f060-f07f : 0000:00:1f.2
     f060-f07f : ahci
   f080-f083 : 0000:00:1f.2
     f080-f083 : ahci
   f090-f097 : 0000:00:1f.2
     f090-f097 : ahci
   f0a0-f0a3 : 0000:00:1f.2
     f0a0-f0a3 : ahci
   f0b0-f0b7 : 0000:00:1f.2
     f0b0-f0b7 : ahci
   ffff-ffff : pnp 00:01
     ffff-ffff : pnp 00:01
       ffff-ffff : pnp 00:01
augustus@r2d2:~$


cat /proc/iomem
00000000-00000fff : reserved
00001000-00057fff : System RAM
00058000-00058fff : reserved
00059000-0009dfff : System RAM
0009e000-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000c3fff : PCI Bus 0000:00
000c4000-000c7fff : PCI Bus 0000:00
000c8000-000cbfff : PCI Bus 0000:00
000cc000-000cffff : PCI Bus 0000:00
000d0000-000d3fff : PCI Bus 0000:00
000d4000-000d7fff : PCI Bus 0000:00
000d8000-000dbfff : PCI Bus 0000:00
000dc000-000dffff : PCI Bus 0000:00
000e0000-000e3fff : PCI Bus 0000:00
000e4000-000e7fff : PCI Bus 0000:00
000e8000-000ebfff : PCI Bus 0000:00
000ec000-000effff : PCI Bus 0000:00
000f0000-000fffff : System ROM
00100000-c9ab8fff : System RAM
   02000000-027a96f7 : Kernel code
   027a96f8-02d1e1ff : Kernel data
   02e80000-02fc6fff : Kernel bss
c9ab9000-c9abffff : ACPI Non-volatile Storage
c9ac0000-ca316fff : System RAM
ca317000-ca595fff : reserved
ca596000-d9917fff : System RAM
d9918000-d9b1ffff : reserved
d9b20000-d9e5dfff : System RAM
d9e5e000-dab29fff : ACPI Non-volatile Storage
dab2a000-daf53fff : reserved
daf54000-daffefff : reserved
dafff000-daffffff : System RAM
db000000-dbbfffff : RAM buffer
dbc00000-dfdfffff : reserved
   dbe00000-dfdfffff : Graphics Stolen Memory
dfe00000-feafffff : PCI Bus 0000:00
   e0000000-efffffff : 0000:00:02.0
   f7800000-f7bfffff : 0000:00:02.0
   f7c00000-f7cfffff : PCI Bus 0000:02
     f7c00000-f7c01fff : 0000:02:00.0
   f7d00000-f7d0ffff : 0000:00:14.0
     f7d00000-f7d0ffff : xhci_hcd
   f7d10000-f7d17fff : 0000:00:04.0
   f7d18000-f7d1bfff : 0000:00:1b.0
     f7d18000-f7d1bfff : ICH HD audio
   f7d1c000-f7d1ffff : 0000:00:03.0
     f7d1c000-f7d1ffff : ICH HD audio
   f7d21000-f7d210ff : 0000:00:1f.3
   f7d22000-f7d227ff : 0000:00:1f.2
     f7d22000-f7d227ff : ahci
   f7d23000-f7d233ff : 0000:00:1d.0
     f7d23000-f7d233ff : ehci_hcd
   f7d25000-f7d2501f : 0000:00:16.0
     f7d25000-f7d2501f : mei_me
   f7fdf000-f7fdffff : pnp 00:09
   f7fe0000-f7feffff : pnp 00:09
   f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]
     f8000000-fbffffff : reserved
       f8000000-fbffffff : pnp 00:09
   fe103000-fe103fff : INT33C2:00
     fe103000-fe103fff : INT33C2:00
   fe104000-fe104fff : pnp 00:08
fec00000-fec00fff : reserved
   fec00000-fec003ff : IOAPIC 0
fed00000-fed03fff : reserved
   fed00000-fed003ff : HPET 0
     fed00000-fed003ff : PNP0103:00
fed10000-fed17fff : pnp 00:09
fed18000-fed18fff : pnp 00:09
fed19000-fed19fff : pnp 00:09
fed1c000-fed1ffff : reserved
   fed1c000-fed1ffff : pnp 00:09
     fed1f410-fed1f414 : iTCO_wdt
fed20000-fed3ffff : pnp 00:09
fed40000-fed44fff : pnp 00:00
fed45000-fed8ffff : pnp 00:09
fed90000-fed93fff : pnp 00:09
fee00000-fee00fff : Local APIC
   fee00000-fee00fff : reserved
ff000000-ffffffff : reserved
   ff000000-ffffffff : INT0800:00
     ff000000-ffffffff : pnp 00:09
100000000-21f1fffff : System RAM
21f200000-21fffffff : RAM buffer
augustus@r2d2:~$


sudo lspci -vvv
[sudo] password for augustus:
00:00.0 Host bridge: Intel Corporation Haswell-ULT DRAM Controller (rev 0b)
     Subsystem: ASUSTeK Computer Inc. Device 165d
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR- INTx-
     Latency: 0
     Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:02.0 VGA compatible controller: Intel Corporation Haswell-ULT 
Integrated Graphics Controller (rev 0b) (prog-if 00 [VGA controller])
     Subsystem: ASUSTeK Computer Inc. Device 165d
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 42
     Region 0: Memory at f7800000 (64-bit, non-prefetchable) [size=4M]
     Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
     Region 4: I/O ports at f000 [size=64]
     Expansion ROM at <unassigned> [disabled]
     Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee0f00c  Data: 41c1
     Capabilities: [d0] Power Management version 2
         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [a4] PCI Advanced Features
         AFCap: TP+ FLR+
         AFCtrl: FLR-
         AFStatus: TP-
     Kernel driver in use: i915

00:03.0 Audio device: Intel Corporation Haswell-ULT HD Audio Controller 
(rev 0b)
     Subsystem: Intel Corporation Device 2010
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 44
     Region 0: Memory at f7d1c000 (64-bit, non-prefetchable) [size=16K]
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee0f00c  Data: 4122
     Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, 
MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0
             ExtTag- RBE-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
     Kernel driver in use: snd_hda_intel

00:04.0 Signal processing controller: Intel Corporation Device 0a03 (rev 0b)
     Subsystem: Intel Corporation Device 2010
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 255
     Region 0: Memory at f7d10000 (64-bit, non-prefetchable) [size=32K]
     Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit-
         Address: 00000000  Data: 0000
     Capabilities: [d0] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:14.0 USB controller: Intel Corporation Lynx Point-LP USB xHCI HC (rev 
04) (prog-if 30 [XHCI])
     Subsystem: ASUSTeK Computer Inc. Device 165d
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 40
     Region 0: Memory at f7d00000 (64-bit, non-prefetchable) [size=64K]
     Capabilities: [70] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
         Address: 00000000fee0500c  Data: 41a1
     Kernel driver in use: xhci_hcd

00:16.0 Communication controller: Intel Corporation Lynx Point-LP HECI 
#0 (rev 04)
     Subsystem: ASUSTeK Computer Inc. Device 165d
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 43
     Region 0: Memory at f7d25000 (64-bit, non-prefetchable) [size=32]
     Capabilities: [50] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Address: 00000000fee0f00c  Data: 41e1
     Kernel driver in use: mei_me

00:1b.0 Audio device: Intel Corporation Lynx Point-LP HD Audio 
Controller (rev 04)
     Subsystem: ASUSTeK Computer Inc. Device 129f
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 45
     Region 0: Memory at f7d18000 (64-bit, non-prefetchable) [size=16K]
     Capabilities: [50] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Address: 00000000fee0f00c  Data: 4152
     Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, 
MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0
             ExtTag- RBE-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
     Capabilities: [100 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed- WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
             Status:    NegoPending- InProgress-
         VC1:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable- ID=2 ArbSelect=Fixed TC/VC=04
             Status:    NegoPending- InProgress-
     Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation Lynx Point-LP PCI Express Root 
Port 1 (rev e4) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
     I/O behind bridge: 0000f000-00000fff
     Memory behind bridge: fff00000-000fffff
     Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [40] Express (v2) Root Port (Slot-), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0
             ExtTag- RBE+
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Exit 
Latency L0s <1us, L1 <4us
             ClockPM- Surprise- LLActRep+ BwNot+
         LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         DevCap2: Completion Timeout: Range ABC, TimeoutDis+, LTR+, OBFF 
Via WAKE# ARIFwd-
         DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, 
OBFF Disabled ARIFwd-
         LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
              Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
              Compliance De-emphasis: -6dB
         LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete-, EqualizationPhase1-
              EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
     Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
         Address: 00000000  Data: 0000
     Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 165d
     Capabilities: [a0] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation Lynx Point-LP PCI Express Root 
Port 4 (rev e4) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
     I/O behind bridge: 0000f000-00000fff
     Memory behind bridge: f7c00000-f7cfffff
     Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0
             ExtTag- RBE+
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Exit 
Latency L0s <512ns, L1 <16us
             ClockPM- Surprise- LLActRep+ BwNot+
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- 
Surprise-
             Slot #3, PowerLimit 10.000W; Interlock- NoCompl+
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ 
Interlock-
             Changed: MRL- PresDet- LinkState-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         DevCap2: Completion Timeout: Range ABC, TimeoutDis+, LTR+, OBFF 
Not Supported ARIFwd-
         DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, 
OBFF Disabled ARIFwd-
         LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
              Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
              Compliance De-emphasis: -6dB
         LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete-, EqualizationPhase1-
              EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
     Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
         Address: 00000000  Data: 0000
     Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 165d
     Capabilities: [a0] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [100 v0] #00
     Capabilities: [200 v1] L1 PM Substates
         L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ 
L1_PM_Substates+
               PortCommonModeRestoreTime=40us PortTPowerOnTime=10us
     Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation Lynx Point-LP USB EHCI #1 (rev 
04) (prog-if 20 [EHCI])
     Subsystem: ASUSTeK Computer Inc. Device 165d
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 23
     Region 0: Memory at f7d23000 (32-bit, non-prefetchable) [size=1K]
     Capabilities: [50] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] Debug port: BAR=1 offset=00a0
     Capabilities: [98] PCI Advanced Features
         AFCap: TP+ FLR+
         AFCtrl: FLR-
         AFStatus: TP-
     Kernel driver in use: ehci-pci

00:1f.0 ISA bridge: Intel Corporation Lynx Point-LP LPC Controller (rev 04)
     Subsystem: ASUSTeK Computer Inc. Device 165d
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Capabilities: [e0] Vendor Specific Information: Len=0c <?>
     Kernel driver in use: lpc_ich

00:1f.2 SATA controller: Intel Corporation Lynx Point-LP SATA Controller 
1 [AHCI mode] (rev 04) (prog-if 01 [AHCI 1.0])
     Subsystem: ASUSTeK Computer Inc. Device 165d
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin B routed to IRQ 41
     Region 0: I/O ports at f0b0 [size=8]
     Region 1: I/O ports at f0a0 [size=4]
     Region 2: I/O ports at f090 [size=8]
     Region 3: I/O ports at f080 [size=4]
     Region 4: I/O ports at f060 [size=32]
     Region 5: Memory at f7d22000 (32-bit, non-prefetchable) [size=2K]
     Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee0500c  Data: 41b1
     Capabilities: [70] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
     Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation Lynx Point-LP SMBus Controller (rev 04)
     Subsystem: ASUSTeK Computer Inc. Device 165d
     Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Interrupt: pin C routed to IRQ 255
     Region 0: Memory at f7d21000 (64-bit, non-prefetchable) [size=256]
     Region 4: I/O ports at f040 [size=32]

02:00.0 Network controller: Intel Corporation Wireless 7260 (rev cb)
     Subsystem: Intel Corporation Device 4c70
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 255
     Region 0: Memory at f7c00000 (64-bit, non-prefetchable) [size=8K]
     Capabilities: [c8] Power Management version 3
         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
         Address: 0000000000000000  Data: 0000
     Capabilities: [40] Express (v2) Endpoint, MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<512ns, L1 unlimited
             ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr+ NoSnoop+ FLReset-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit 
Latency L0s <4us, L1 <32us
             ClockPM+ Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         DevCap2: Completion Timeout: Range B, TimeoutDis+, LTR+, OBFF 
Via WAKE#
         DevCtl2: Completion Timeout: 16ms to 55ms, TimeoutDis-, LTR+, 
OBFF Disabled
         LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
              Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
              Compliance De-emphasis: -6dB
         LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete-, EqualizationPhase1-
              EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
         AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
     Capabilities: [140 v1] Device Serial Number f8-16-54-ff-ff-24-fb-8a
     Capabilities: [14c v1] Latency Tolerance Reporting
         Max snoop latency: 3145728ns
         Max no snoop latency: 3145728ns
     Capabilities: [154 v1] Vendor Specific Information: ID=cafe Rev=1 
Len=014 <?>

augustus@r2d2:~$


cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: SanDisk SD6SB1M1 Rev: 600
   Type:   Direct-Access                    ANSI  SCSI revision: 05
augustus@r2d2:~$


ls /proc
1     147   1836  2003  2517  37    4906  8          devices net
10    1494  1846  2062  2564  38    5     800        diskstats pagetypeinfo
1004  15    1848  2071  26    3823  5013  816        dma partitions
1006  16    1850  2080  2652  39    5022  821        driver sched_debug
1047  1637  1854  2082  2667  3910  5023  823        execdomains schedstat
11    1639  1855  2083  28    40    509   875        fb scsi
1129  17    1860  2088  2815  408   5156  878        filesystems self
1137  1704  1863  2092  2820  41    520   882        fs slabinfo
1138  1712  1870  2097  2847  42    524   89         interrupts softirqs
1154  1720  1887  21    29    423   53    9          iomem stat
1193  1727  1890  2140  3     426   54    90         ioports swaps
1199  1743  1892  2154  30    43    55    929        irq sys
12    1745  19    2222  31    44    570   933        kallsyms sysrq-trigger
1204  1747  1903  2230  3110  45    610   939        kcore sysvipc
1248  1749  1913  2235  3260  46    624   940        keys thread-self
1296  1751  1955  2240  328   4696  635   943        key-users timer_list
13    1769  1963  2246  3296  47    67    985        kmsg timer_stats
1315  1772  1968  2262  33    4702  671   990        kpagecount tty
137   1781  197   2298  3344  4703  68    acpi       kpageflags uptime
14    1785  1970  23    3355  4704  7     asound     loadavg version
140   1787  198   2351  34    478   70    buddyinfo  locks vmallocinfo
141   1788  1990  2360  342   48    705   bus        mdstat vmstat
142   1791  1994  24    3448  4832  710   cgroups    meminfo zoneinfo
143   1794  1996  2491  3488  4838  711   cmdline    misc
144   18    2     25    3491  485   732   consoles   modules
145   1803  20    2501  35    4860  756   cpuinfo    mounts
146   1811  2001  2513  36    488   799   crypto     mtrr
augustus@r2d2:~$


please tell me when you need more informations


thank you

Andreas


