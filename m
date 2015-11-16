Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34176 "EHLO
	mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbbKPMwF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2015 07:52:05 -0500
Received: by qkdg3 with SMTP id g3so13939663qkd.1
        for <linux-wireless@vger.kernel.org>; Mon, 16 Nov 2015 04:52:04 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 16 Nov 2015 12:52:04 +0000
Message-ID: <CAMvnJCJigJ8amyYB3aDvKzZLQkFTZSTJn4pQ3xjHhH2wssLgEg@mail.gmail.com> (sfid-20151116_135222_396870_AFC856BA)
Subject: 10ec:b723 [HP Notebook - 15-ac106na] Wifi unstable NO HTML
From: Alan <keys84@gmail.com>
To: Larry.Finger@lwfinger.net, wlanfae@realtek.com,
	Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 sorry guys my first bug report
[1.]
Bug #1516251 10ec:b723 [HP Notebook - 15-ac106na] Wifi unstable

[2.]
Networks not detected unless router is within 2feet
weak signal strength, connection dropping [when it does connect]
device dropping [disappearing from NetworkManager]

only affects this wireless device [rtl8723be] all others function as expected

###Irq error for i915 graphics is fixed in 4.2.6 and this error still
occurs in that kernel

bios F.1A [latest]

router:-
Virgin superhub
software version V2.39.02 [latest]
bootcode version 2.3.0beta7

[3.]

[4.]
Linux version 4.4.0-rc1 (al@n) (gcc version 4.9.2 (Ubuntu
4.9.2-10ubuntu13) ) #1 SMP Mon Nov 16 10:52:31 GMT 2015#

[5.]
No oops but i do get this line in dmesg in 4.4-Rc only, possible my
error compiling?? [NOOB]
[   15.734897] rtl8723be 0000:0d:00.0 wlan0: set_features() failed
(-1); wanted 0x0000000000004000, left 0x0000000000004800

[6.]
happens every boot

[7.]
Description:    Ubuntu 15.04
Release:        15.04

[7.1]
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux n 4.4.0-rc1 #1 SMP Mon Nov 16 10:52:31 GMT 2015 x86_64 x86_64
x86_64 GNU/Linux

GNU C                   4.9.2
GNU Make                4.0
Binutils                2.25
Util-linux              2.25.2
Mount                   2.25.2
Module-init-tools       18
E2fsprogs               1.42.12
Pcmciautils             018
PPP                     2.4.6
Linux C Library         2.21
Dynamic linker (ldd)    2.21
Linux C++ Library       6.0.20
Procps                  3.3.9
Net-tools               1.60
Kbd                     1.15.5
Console-tools           1.15.5
Sh-utils                8.23
Udev                    219
Wireless-tools          30
Modules Loaded          8250_dw acpi_pad acpi_thermal_rel ahci arc4
autofs4 binfmt_misc bluetooth bnep btbcm btcoexist btintel btrtl btusb
cfg80211 coretemp crc32_pclmul crct10dif_pclmul drm drm_kms_helper
dw_dmac dw_dmac_core fb_sys_fops fjes hid hid_generic hp_wireless
hp_wmi i2c_algo_bit i2c_designware_core i2c_designware_platform
i2c_hid i915 input_leds int3400_thermal int3402_thermal
int3403_thermal int340x_thermal_zone intel_pch_thermal
intel_powerclamp intel_rapl intel_soc_dts_iosf iosf_mbi irqbypass
joydev kvm kvm_intel libahci lp lpc_ich mac80211 mac_hid media mei
mei_me mii nls_iso8859_1 parport parport_pc ppdev
processor_thermal_device psmouse r8169 rfcomm rtl8723be rtl8723_common
rtl_pci rtlwifi sdhci sdhci_acpi serio_raw shpchp snd snd_hda_codec
snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_codec_realtek
snd_hda_core snd_hda_intel snd_hwdep snd_pcm snd_rawmidi snd_seq
snd_seq_device snd_seq_midi snd_seq_midi_event snd_soc_core
snd_soc_rl6347a snd_soc_rt286 snd_soc_ssm4567 snd_soc_sst_acpi
snd_timer soundcore sparse_keymap spi_pxa2xx_platform syscopyarea
sysfillrect sysimgblt tpm_crb usbhid uvcvideo v4l2_common video
videobuf2_core videobuf2_memops videobuf2_v4l2 videobuf2_vmalloc
videodev wmi x86_pkg_temp_thermal

[7.2]
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 61
model name      : Intel(R) Pentium(R) CPU 3825U @ 1.90GHz
stepping        : 4
microcode       : 0x21
cpu MHz         : 1900.000
cache size      : 2048 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 20
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq
dtes64 monitor ds_cpl vmx est tm2 ssse3 sdbg cx16 xtpr pdcm pcid
sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer xsave rdrand
lahf_lm abm 3dnowprefetch ida arat epb pln pts dtherm intel_pt
tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust erms invpcid
rdseed xsaveopt
bugs            :
bogomips        : 3791.26
clflush size    : 64
cache_alignment : 64
address sizes   : 39 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 61
model name      : Intel(R) Pentium(R) CPU 3825U @ 1.90GHz
stepping        : 4
microcode       : 0x21
cpu MHz         : 1845.152
cache size      : 2048 KB
physical id     : 0
siblings        : 4
core id         : 1
cpu cores       : 2
apicid          : 2
initial apicid  : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 20
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq
dtes64 monitor ds_cpl vmx est tm2 ssse3 sdbg cx16 xtpr pdcm pcid
sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer xsave rdrand
lahf_lm abm 3dnowprefetch ida arat epb pln pts dtherm intel_pt
tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust erms invpcid
rdseed xsaveopt
bugs            :
bogomips        : 3791.26
clflush size    : 64
cache_alignment : 64
address sizes   : 39 bits physical, 48 bits virtual
power management:

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 6
model           : 61
model name      : Intel(R) Pentium(R) CPU 3825U @ 1.90GHz
stepping        : 4
microcode       : 0x21
cpu MHz         : 1900.000
cache size      : 2048 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 20
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq
dtes64 monitor ds_cpl vmx est tm2 ssse3 sdbg cx16 xtpr pdcm pcid
sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer xsave rdrand
lahf_lm abm 3dnowprefetch ida arat epb pln pts dtherm intel_pt
tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust erms invpcid
rdseed xsaveopt
bugs            :
bogomips        : 3791.26
clflush size    : 64
cache_alignment : 64
address sizes   : 39 bits physical, 48 bits virtual
power management:

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model           : 61
model name      : Intel(R) Pentium(R) CPU 3825U @ 1.90GHz
stepping        : 4
microcode       : 0x21
cpu MHz         : 1896.808
cache size      : 2048 KB
physical id     : 0
siblings        : 4
core id         : 1
cpu cores       : 2
apicid          : 3
initial apicid  : 3
fpu             : yes
fpu_exception   : yes
cpuid level     : 20
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq
dtes64 monitor ds_cpl vmx est tm2 ssse3 sdbg cx16 xtpr pdcm pcid
sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer xsave rdrand
lahf_lm abm 3dnowprefetch ida arat epb pln pts dtherm intel_pt
tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust erms invpcid
rdseed xsaveopt
bugs            :
bogomips        : 3791.26
clflush size    : 64
cache_alignment : 64
address sizes   : 39 bits physical, 48 bits virtual
power management:

[7.3]
rfcomm 69632 8 - Live 0x0000000000000000
bnep 20480 2 - Live 0x0000000000000000
binfmt_misc 20480 1 - Live 0x0000000000000000
nls_iso8859_1 16384 1 - Live 0x0000000000000000
btusb 45056 0 - Live 0x0000000000000000
btrtl 16384 1 btusb, Live 0x0000000000000000
arc4 16384 2 - Live 0x0000000000000000
btbcm 16384 1 btusb, Live 0x0000000000000000
btintel 16384 1 btusb, Live 0x0000000000000000
rtl8723be 90112 0 - Live 0x0000000000000000
btcoexist 53248 1 rtl8723be, Live 0x0000000000000000
rtl_pci 28672 1 rtl8723be, Live 0x0000000000000000
bluetooth 516096 25 rfcomm,bnep,btusb,btrtl,btbcm,btintel, Live
0x0000000000000000
rtlwifi 77824 2 rtl8723be,rtl_pci, Live 0x0000000000000000
mac80211 724992 3 rtl8723be,rtl_pci,rtlwifi, Live 0x0000000000000000
snd_hda_codec_realtek 81920 1 - Live 0x0000000000000000
snd_hda_codec_generic 73728 1 snd_hda_codec_realtek, Live 0x0000000000000000
snd_hda_codec_hdmi 53248 1 - Live 0x0000000000000000
snd_hda_intel 36864 7 - Live 0x0000000000000000
snd_hda_codec 135168 4
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_intel,
Live 0x0000000000000000
uvcvideo 90112 0 - Live 0x0000000000000000
snd_soc_ssm4567 20480 0 - Live 0x0000000000000000
snd_soc_rt286 36864 0 - Live 0x0000000000000000
snd_soc_rl6347a 16384 1 snd_soc_rt286, Live 0x0000000000000000
snd_hda_core 65536 5
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,
Live 0x0000000000000000
videobuf2_vmalloc 16384 1 uvcvideo, Live 0x0000000000000000
snd_soc_core 180224 2 snd_soc_ssm4567,snd_soc_rt286, Live 0x0000000000000000
snd_pcm 102400 7
snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_soc_rt286,snd_hda_core,snd_soc_core,
Live 0x0000000000000000
snd_hwdep 16384 1 snd_hda_codec, Live 0x0000000000000000
videobuf2_memops 16384 1 videobuf2_vmalloc, Live 0x0000000000000000
videobuf2_v4l2 28672 1 uvcvideo, Live 0x0000000000000000
videobuf2_core 36864 2 uvcvideo,videobuf2_v4l2, Live 0x0000000000000000
v4l2_common 16384 1 videobuf2_v4l2, Live 0x0000000000000000
intel_rapl 20480 0 - Live 0x0000000000000000
x86_pkg_temp_thermal 16384 0 - Live 0x0000000000000000
snd_seq_midi 16384 0 - Live 0x0000000000000000
snd_seq_midi_event 16384 1 snd_seq_midi, Live 0x0000000000000000
videodev 176128 4 uvcvideo,videobuf2_v4l2,videobuf2_core,v4l2_common,
Live 0x0000000000000000
intel_powerclamp 16384 0 - Live 0x0000000000000000
snd_rawmidi 28672 1 snd_seq_midi, Live 0x0000000000000000
media 24576 2 uvcvideo,videodev, Live 0x0000000000000000
coretemp 16384 0 - Live 0x0000000000000000
kvm_intel 167936 0 - Live 0x0000000000000000
snd_seq 69632 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
cfg80211 548864 2 rtlwifi,mac80211, Live 0x0000000000000000
kvm 524288 1 kvm_intel, Live 0x0000000000000000
hp_wmi 16384 0 - Live 0x0000000000000000
sparse_keymap 16384 1 hp_wmi, Live 0x0000000000000000
snd_timer 32768 2 snd_pcm,snd_seq, Live 0x0000000000000000
rtl8723_common 24576 1 rtl8723be, Live 0x0000000000000000
snd_seq_device 16384 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0x0000000000000000
irqbypass 16384 1 kvm, Live 0x0000000000000000
joydev 20480 0 - Live 0x0000000000000000
input_leds 16384 0 - Live 0x0000000000000000
crct10dif_pclmul 16384 0 - Live 0x0000000000000000
snd 77824 25 snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_soc_core,snd_pcm,snd_hwdep,snd_rawmidi,snd_seq,snd_timer,snd_seq_device,
Live 0x0000000000000000
processor_thermal_device 16384 0 - Live 0x0000000000000000
crc32_pclmul 16384 0 - Live 0x0000000000000000
wmi 20480 1 hp_wmi, Live 0x0000000000000000
serio_raw 16384 0 - Live 0x0000000000000000
mei_me 28672 0 - Live 0x0000000000000000
soundcore 16384 1 snd, Live 0x0000000000000000
dw_dmac 16384 0 - Live 0x0000000000000000
intel_soc_dts_iosf 16384 1 processor_thermal_device, Live 0x0000000000000000
i2c_hid 20480 0 - Live 0x0000000000000000
dw_dmac_core 24576 1 dw_dmac, Live 0x0000000000000000
i2c_designware_platform 16384 0 - Live 0x0000000000000000
mei 102400 1 mei_me, Live 0x0000000000000000
int3403_thermal 16384 0 - Live 0x0000000000000000
snd_soc_sst_acpi 16384 0 - Live 0x0000000000000000
spi_pxa2xx_platform 24576 0 - Live 0x0000000000000000
iosf_mbi 16384 2 intel_rapl,intel_soc_dts_iosf, Live 0x0000000000000000
i2c_designware_core 20480 1 i2c_designware_platform, Live 0x0000000000000000
8250_dw 16384 0 - Live 0x0000000000000000
int3402_thermal 16384 0 - Live 0x0000000000000000
int340x_thermal_zone 16384 3
processor_thermal_device,int3403_thermal,int3402_thermal, Live
0x0000000000000000
int3400_thermal 16384 0 - Live 0x0000000000000000
tpm_crb 16384 0 - Live 0x0000000000000000
intel_pch_thermal 16384 0 - Live 0x0000000000000000
acpi_pad 20480 0 - Live 0x0000000000000000
lpc_ich 24576 0 - Live 0x0000000000000000
hp_wireless 16384 0 - Live 0x0000000000000000
mac_hid 16384 0 - Live 0x0000000000000000
acpi_thermal_rel 16384 1 int3400_thermal, Live 0x0000000000000000
shpchp 36864 0 - Live 0x0000000000000000
parport_pc 36864 0 - Live 0x0000000000000000
ppdev 20480 0 - Live 0x0000000000000000
lp 20480 0 - Live 0x0000000000000000
parport 49152 3 parport_pc,ppdev,lp, Live 0x0000000000000000
autofs4 40960 2 - Live 0x0000000000000000
hid_generic 16384 0 - Live 0x0000000000000000
usbhid 49152 0 - Live 0x0000000000000000
hid 122880 3 i2c_hid,hid_generic,usbhid, Live 0x0000000000000000
i915 1196032 10 - Live 0x0000000000000000
i2c_algo_bit 16384 1 i915, Live 0x0000000000000000
drm_kms_helper 135168 1 i915, Live 0x0000000000000000
syscopyarea 16384 1 drm_kms_helper, Live 0x0000000000000000
sysfillrect 16384 1 drm_kms_helper, Live 0x0000000000000000
sysimgblt 16384 1 drm_kms_helper, Live 0x0000000000000000
fb_sys_fops 16384 1 drm_kms_helper, Live 0x0000000000000000
drm 352256 11 i915,drm_kms_helper, Live 0x0000000000000000
psmouse 126976 0 - Live 0x0000000000000000
r8169 81920 0 - Live 0x0000000000000000
ahci 36864 4 - Live 0x0000000000000000
libahci 32768 1 ahci, Live 0x0000000000000000
mii 16384 1 r8169, Live 0x0000000000000000
sdhci_acpi 16384 0 - Live 0x0000000000000000
video 40960 1 i915, Live 0x0000000000000000
fjes 28672 0 - Live 0x0000000000000000
sdhci 45056 1 sdhci_acpi, Live 0x0000000000000000

[7.4]
al@n:~/linux-4.4-rc1/scripts$ cat /proc/ioports
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
  0680-069f : pnp 00:00
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  164e-164f : pnp 00:00
  1800-1803 : ACPI PM1a_EVT_BLK
  1804-1805 : ACPI PM1a_CNT_BLK
  1808-180b : ACPI PM_TMR
  1810-1815 : ACPI CPU throttle
  1830-1833 : iTCO_wdt.0.auto
  1850-1850 : ACPI PM2_CNT_BLK
  1854-1857 : pnp 00:02
  1860-187f : iTCO_wdt.0.auto
  1880-189f : ACPI GPE0_BLK
  3000-3fff : PCI Bus 0000:0d
    3000-30ff : 0000:0d:00.0
      3000-30ff : rtl_pci
  4000-4fff : PCI Bus 0000:07
    4000-40ff : 0000:07:00.0
      4000-40ff : r8169
  5000-5fff : PCI Bus 0000:01
  6000-603f : 0000:00:02.0
  6040-605f : 0000:00:1f.3
  6060-607f : 0000:00:1f.2
    6060-607f : ahci
  6080-6087 : 0000:00:1f.2
    6080-6087 : ahci
  6088-608f : 0000:00:1f.2
    6088-608f : ahci
  6090-6093 : 0000:00:1f.2
    6090-6093 : ahci
  6094-6097 : 0000:00:1f.2
    6094-6097 : ahci
  fd60-fd63 : pnp 00:00
  ffff-ffff : pnp 00:00
    ffff-ffff : pnp 00:00
      ffff-ffff : pnp 00:00
al@n:~/linux-4.4-rc1/scripts$ cat /proc/iomem
00000000-00000fff : reserved
00001000-00057fff : System RAM
00058000-00058fff : reserved
00059000-00085fff : System RAM
00086000-0009ffff : reserved
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
000f0000-000fffff : PCI Bus 0000:00
  000f0000-000fffff : System ROM
00100000-9bbddfff : System RAM
  02000000-0279ee33 : Kernel code
  0279ee34-02d4d27f : Kernel data
  02ec4000-03008fff : Kernel bss
9bbde000-9bdddfff : reserved
9bdde000-9cc8dfff : reserved
9cc8e000-9cf8dfff : ACPI Non-volatile Storage
9cf8e000-9cffdfff : ACPI Tables
9cffe000-9cffefff : System RAM
9cfff000-9cffffff : MSFT0101:00
9d000000-9dffffff : RAM buffer
9e000000-9fffffff : reserved
  9e000000-9fffffff : Graphics Stolen Memory
a0000000-dfffffff : PCI Bus 0000:00
  a0000000-a000ffff : pnp 00:06
  a0010000-a001ffff : pnp 00:06
  b0000000-bfffffff : 0000:00:02.0
  c0000000-c0ffffff : PCI Bus 0000:01
  c1000000-c1ffffff : PCI Bus 0000:0d
  c2000000-c2ffffff : 0000:00:02.0
  c3000000-c3ffffff : PCI Bus 0000:0d
    c3000000-c3003fff : 0000:0d:00.0
      c3000000-c3003fff : rtl_pci
  c4000000-c50fffff : PCI Bus 0000:07
    c5000000-c5000fff : 0000:07:00.0
      c5000000-c5000fff : r8169
  c5100000-c51fffff : PCI Bus 0000:07
    c5100000-c5103fff : 0000:07:00.0
      c5100000-c5103fff : r8169
  c5200000-c520ffff : 0000:00:14.0
    c5200000-c520ffff : xhci-hcd
  c5210000-c5217fff : 0000:00:04.0
  c5218000-c521bfff : 0000:00:03.0
    c5218000-c521bfff : ICH HD audio
  c521c000-c521ffff : 0000:00:1b.0
    c521c000-c521ffff : ICH HD audio
  c5220000-c52200ff : 0000:00:1f.3
  c5221000-c522101f : 0000:00:16.0
    c5221000-c522101f : mei_me
  c5223000-c5223fff : 0000:00:1f.6
    c5223000-c5223fff : Intel PCH thermal driver
  c5224000-c52247ff : 0000:00:1f.2
    c5224000-c52247ff : ahci
  c6000000-c6ffffff : PCI Bus 0000:01
e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
  e0000000-efffffff : reserved
    e0000000-efffffff : pnp 00:06
fe000000-fe113fff : PCI Bus 0000:00
feb00000-feb03fff : reserved
fec00000-fec00fff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : PNP0103:00
fed10000-fed19fff : reserved
  fed10000-fed17fff : pnp 00:06
  fed18000-fed18fff : pnp 00:06
  fed19000-fed19fff : pnp 00:06
fed1c000-fed1ffff : reserved
  fed1c000-fed1ffff : pnp 00:06
    fed1f410-fed1f414 : iTCO_wdt.0.auto
fed20000-fed3ffff : pnp 00:06
fed70000-fed70fff : MSFT0101:00
fed90000-fed90fff : dmar0
fed91000-fed91fff : dmar1
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ff000000-ff000fff : pnp 00:06
ff010000-ffffffff : INT0800:00
  ffa00000-ffffffff : reserved
100000000-15effffff : System RAM
15f000000-15fffffff : RAM buffer

[7.5]
00:00.0 Host bridge: Intel Corporation Broadwell-U Host Bridge -OPI (rev 09)
        Subsystem: Hewlett-Packard Company Device 80c1
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information: Len=0c <?>
        Kernel driver in use: bdw_uncore

00:02.0 VGA compatible controller: Intel Corporation Broadwell-U
Integrated Graphics (rev 09) (prog-if 00 [VGA controller])
        Subsystem: Hewlett-Packard Company Device 80c1
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 45
        Region 0: Memory at c2000000 (64-bit, non-prefetchable) [size=16M]
        Region 2: Memory at b0000000 (64-bit, prefetchable) [size=256M]
        Region 4: I/O ports at 6000 [size=64]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee00018  Data: 0000
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a4] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: i915

00:03.0 Audio device: Intel Corporation Broadwell-U Audio Controller (rev 09)
        Subsystem: Hewlett-Packard Company Device 80c1
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 48
        Region 0: Memory at c5218000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee002d8  Data: 0000
        Capabilities: [70] Express (v1) Root Complex Integrated
Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag- RBE-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr- TransPend-
        Kernel driver in use: snd_hda_intel

00:04.0 Signal processing controller: Intel Corporation Broadwell-U
Camarillo Device (rev 09)
        Subsystem: Hewlett-Packard Company Device 80c1
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at c5210000 (64-bit, non-prefetchable) [size=32K]
        Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Capabilities: [d0] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [e0] Vendor Specific Information: Len=0c <?>
        Kernel driver in use: proc_thermal

00:14.0 USB controller: Intel Corporation Wildcat Point-LP USB xHCI
Controller (rev 03) (prog-if 30 [XHCI])
        Subsystem: Hewlett-Packard Company Device 80c1
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 42
        Region 0: Memory at c5200000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
                Address: 00000000fee00258  Data: 0000
        Kernel driver in use: xhci_hcd

00:16.0 Communication controller: Intel Corporation Wildcat Point-LP
MEI Controller #1 (rev 03)
        Subsystem: Hewlett-Packard Company Device 80c1
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 46
        Region 0: Memory at c5221000 (64-bit, non-prefetchable) [size=32]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee002b8  Data: 0000
        Kernel driver in use: mei_me

00:1b.0 Audio device: Intel Corporation Wildcat Point-LP High
Definition Audio Controller (rev 03)
        Subsystem: Hewlett-Packard Company Device 80c1
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 47
        Region 0: Memory at c521c000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee002f8  Data: 0000
        Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation Wildcat Point-LP PCI Express
Root Port #1 (rev e3) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=01, subordinate=06, sec-latency=0
        I/O behind bridge: 00005000-00005fff
        Memory behind bridge: c6000000-c6ffffff
        Prefetchable memory behind bridge: 00000000c0000000-00000000c0ffffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag- RBE+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr+ TransPend-
                LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1,
Exit Latency L0s <1us, L1 <4us
                        ClockPM- Surprise- LLActRep+ BwNot+
                LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
HotPlug+ Surprise+
                        Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown,
Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range ABC, TimeoutDis+,
LTR+, OBFF Via WAKE# ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms,
TimeoutDis-, LTR+, OBFF Disabled ARIFwd-
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
        Capabilities: [90] Subsystem: Hewlett-Packard Company Device 80c1
        Capabilities: [a0] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport

00:1c.2 PCI bridge: Intel Corporation Wildcat Point-LP PCI Express
Root Port #3 (rev e3) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=07, subordinate=0c, sec-latency=0
        I/O behind bridge: 00004000-00004fff
        Memory behind bridge: c4000000-c50fffff
        Prefetchable memory behind bridge: 00000000c5100000-00000000c51fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag- RBE+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr+ TransPend-
                LnkCap: Port #3, Speed 5GT/s, Width x1, ASPM L0s L1,
Exit Latency L0s <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot+
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
HotPlug- Surprise-
                        Slot #2, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown,
Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range ABC, TimeoutDis+,
LTR+, OBFF Not Supported ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms,
TimeoutDis-, LTR+, OBFF Disabled ARIFwd-
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
        Capabilities: [90] Subsystem: Hewlett-Packard Company Device 80c1
        Capabilities: [a0] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100 v0] #00
        Capabilities: [200 v1] L1 PM Substates
                L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+
ASPM_L1.1+ L1_PM_Substates+
                          PortCommonModeRestoreTime=40us PortTPowerOnTime=10us
        Kernel driver in use: pcieport

00:1c.5 PCI bridge: Intel Corporation Wildcat Point-LP PCI Express
Root Port #6 (rev e3) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=0d, subordinate=12, sec-latency=0
        I/O behind bridge: 00003000-00003fff
        Memory behind bridge: c3000000-c3ffffff
        Prefetchable memory behind bridge: 00000000c1000000-00000000c1ffffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag- RBE+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr+ TransPend-
                LnkCap: Port #6, Speed 5GT/s, Width x1, ASPM L0s L1,
Exit Latency L0s <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot+
                LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
HotPlug- Surprise-
                        Slot #5, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown,
Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range ABC, TimeoutDis+,
LTR+, OBFF Not Supported ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms,
TimeoutDis-, LTR+, OBFF Disabled ARIFwd-
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
        Capabilities: [90] Subsystem: Hewlett-Packard Company Device 80c1
        Capabilities: [a0] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100 v0] #00
        Capabilities: [200 v1] L1 PM Substates
                L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+
ASPM_L1.1+ L1_PM_Substates+
                          PortCommonModeRestoreTime=40us PortTPowerOnTime=10us
        Kernel driver in use: pcieport

00:1f.0 ISA bridge: Intel Corporation Wildcat Point-LP LPC Controller (rev 03)
        Subsystem: Hewlett-Packard Company Device 80c1
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information: Len=0c <?>
        Kernel driver in use: lpc_ich

00:1f.2 SATA controller: Intel Corporation Wildcat Point-LP SATA
Controller [AHCI Mode] (rev 03) (prog-if 01 [AHCI 1.0])
        Subsystem: Hewlett-Packard Company Device 80c1
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 43
        Region 0: I/O ports at 6088 [size=8]
        Region 1: I/O ports at 6094 [size=4]
        Region 2: I/O ports at 6080 [size=8]
        Region 3: I/O ports at 6090 [size=4]
        Region 4: I/O ports at 6060 [size=32]
        Region 5: Memory at c5224000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee00298  Data: 0000
        Capabilities: [70] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
        Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation Wildcat Point-LP SMBus Controller (rev 03)
        Subsystem: Hewlett-Packard Company Device 80c1
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin C routed to IRQ 255
        Region 0: Memory at c5220000 (64-bit, non-prefetchable) [size=256]
        Region 4: I/O ports at 6040 [size=32]

00:1f.6 Signal processing controller: Intel Corporation Wildcat
Point-LP Thermal Management Controller (rev 03)
        Subsystem: Hewlett-Packard Company Device 80c1
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 0: Memory at c5223000 (64-bit, non-prefetchable) [size=4K]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Kernel driver in use: intel_pch_thermal

07:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 07)
        Subsystem: Hewlett-Packard Company Device 80c3
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 44
        Region 0: I/O ports at 4000 [size=256]
        Region 2: Memory at c5000000 (64-bit, non-prefetchable) [size=4K]
        Region 4: Memory at c5100000 (64-bit, prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee00278  Data: 0000
        Capabilities: [70] Express (v2) Endpoint, MSI 01
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
unlimited, L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Exit Latency L0s unlimited, L1 <64us
                        ClockPM+ Surprise- LLActRep- BwNot-
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+,
LTR+, OBFF Via message/WAKE#
                DevCtl2: Completion Timeout: 50us to 50ms,
TimeoutDis-, LTR+, OBFF Disabled
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
                Vector table: BAR=4 offset=00000000
                PBA: BAR=4 offset=00000800
        Capabilities: [d0] Vital Product Data
                No end tag found
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [140 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Capabilities: [160 v1] Device Serial Number 01-00-00-00-36-4c-e0-00
        Capabilities: [170 v1] Latency Tolerance Reporting
                Max snoop latency: 3145728ns
                Max no snoop latency: 3145728ns
        Kernel driver in use: r8169

0d:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8723BE
PCIe Wireless Network Adapter
        Subsystem: Hewlett-Packard Company Device 804c
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: I/O ports at 3000 [size=256]
        Region 2: Memory at c3000000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<4us, L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Exit Latency L0s <512ns, L1 <64us
                        ClockPM+ Surprise- LLActRep- BwNot-
                LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported,
TimeoutDis+, LTR+, OBFF Via message/WAKE#
                DevCtl2: Completion Timeout: 50us to 50ms,
TimeoutDis+, LTR+, OBFF Disabled
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [100 v2] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [140 v1] Device Serial Number 00-23-b7-fe-ff-4c-e0-00
        Capabilities: [150 v1] Latency Tolerance Reporting
                Max snoop latency: 3145728ns
                Max no snoop latency: 3145728ns
        Capabilities: [158 v1] L1 PM Substates
                L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+
ASPM_L1.1+ L1_PM_Substates+
                          PortCommonModeRestoreTime=150us PortTPowerOnTime=150us
        Kernel driver in use: rtl8723be

[7.6]
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: TOSHIBA MQ01ABD1 Rev: 2C
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: hp       Model: DVDRW  SU208GB   Rev: HH00
  Type:   CD-ROM                           ANSI  SCSI revision: 05

[7.7]
1     1065  13    1400  1450  155   1626  1878  2288  27   34   39
525  66  75   783  825  9    973        cgroups      fb
key-users    modules       slabinfo       tty
10    1067  1366  1403  1486  1555  163   1899  2296  28   35   40
526  67  755  787  83   92   986        cmdline      filesystems  kmsg
        mounts        softirqs       uptime
1019  11    1370  1404  1490  156   164   1901  23    29   353  41
528  68  758  79   832  928  987        consoles     fs
kpagecgroup  mtrr          stat           version
1031  1193  1371  1405  1497  1561  1647  2     2306  290  354  43
585  69  76   794  833  934  991        cpuinfo      interrupts
kpagecount   net           swaps          vmallocinfo
1038  1194  1372  1406  15    1564  165   20    2344  3    355  44
586  7   762  8    84   957  995        crypto       iomem
kpageflags   pagetypeinfo  sys            vmstat
105   1195  1374  1411  1504  1567  1650  21    2359  30   36   45
60   70  768  80   85   958  996        devices      ioports
loadavg      partitions    sysrq-trigger  zoneinfo
1055  12    1386  1415  1507  157   17    216   2381  31   366  451
606  71  77   802  86   962  acpi       diskstats    irq
locks        sched_debug   sysvipc
1056  1266  1394  1428  1509  1584  18    217   25    32   37   464
62   72  772  81   87   965  asound     dma          kallsyms
mdstat       schedstat     thread-self
1057  1269  1398  1436  153   16    1843  22    26    322  38   5
64   73  777  811  870  968  buddyinfo  driver       kcore
meminfo      scsi          timer_list
106   1270  14    1448  154   162   1858  2286  269   33   388  524
65   74  78   82   88   972  bus        execdomains  keys         misc
        self          timer_stats

[8.]
turning power management off does not work as it does for other people
tried adding options rtl8723be ips=0 fwlps=0 swlps=0 to rtl8723be.conf
in various combinations
