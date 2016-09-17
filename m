Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:35510 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753430AbcIQRzq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 13:55:46 -0400
Received: by mail-lf0-f48.google.com with SMTP id l131so80954047lfl.2
        for <linux-wireless@vger.kernel.org>; Sat, 17 Sep 2016 10:55:45 -0700 (PDT)
MIME-Version: 1.0
From: Antony Polukhin <antoshkka@gmail.com>
Date: Sat, 17 Sep 2016 20:55:43 +0300
Message-ID: <CAKqmYPbP_PnbMm6+36YH5C0uab9qK9YRbmBoabe-b=ev53k1dQ@mail.gmail.com> (sfid-20160917_195553_584950_08A12DDD)
Subject: rtl8821ae WiFi does not work
To: wlanfae@realtek.com, Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have a rtl8821ae wifi and it is almost impossible to use. Please
help. Here are the details:


[1.] One line summary of the problem:
rtl8821ae WiFi does not work

[2.] Full description of the problem/report:
Download speed drops down to 50KB/s or less really often. Instead of
2.5 MB/s connection speed, I have an average of less than 100KB/s,
with rare peeks up to 2.5MB/s and common dropdowns to less that
50KB/s. Latency is huge: if I pause downloading at the speed of 50KB/s
and try to download some very simple web page, it may take a few
minutes.

Router info:

Vendor Netgear
Hardware Version WNDR4000
Firmware Version V1.0.2.4_9.1.86
GUI Language Version V1.0.2.4_2.1.17.1

Router firmware is up-to-date, I've updated it a few days ago. It uses
2.4GHz b/g/n and there's no way to disable 802.11n or force only
802.11b/g usage. Other Linux devices work well with that router.

[3.] Keywords:


[4.] Kernel version (from /proc/version):
Linux version 4.8.0-040800rc6-generic (kernel@gloin) (gcc version
6.2.0 20160901 (Ubuntu 6.2.0-3ubuntu11) ) #201609121119 SMP Mon Sep 12
15:21:03 UTC 2016

[5.] Output of Oops.. message:

[6.] A small shell script or example program which triggers the problem:

[7.] Environment:
Description:    Ubuntu 16.04.1 LTS
Release:    16.04

[7.1.] Software
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux antishkka-amd 4.8.0-040800rc6-generic #201609121119 SMP Mon Sep
12 15:21:03 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

GNU C            5.4.0
GNU Make        4.1
Binutils        2.26.1
Util-linux        2.27.1
Mount            2.27.1
Module-init-tools    22
E2fsprogs        1.42.13
Pcmciautils        018
PPP            2.4.7
Linux C Library        2.23
Dynamic linker (ldd)    2.23
Linux C++ Library    6.0.21
Procps            3.3.10
Net-tools        1.60
Kbd            1.15.5
Console-tools        1.15.5
Sh-utils        8.25
Udev            229
Wireless-tools        30
Modules Loaded        ablk_helper ac acpi_cpufreq aesni_intel
aes_x86_64 ahci amdgpu amdkfd arc4 autofs4 battery binfmt_misc
bluetooth bnep btbcm btcoexist btintel btrtl btusb button ccm cfg80211
crc16 crc32c_intel crc32_pclmul crct10dif_pclmul cryptd ctr drm
drm_kms_helper efi_pstore efivarfs efivars ehci_hcd ehci_pci evdev
ext4 fam15h_power fat fb_sys_fops fjes fscrypto fuse gf128mul
ghash_clmulni_intel glue_helper i2c_algo_bit i2c_designware_core
i2c_designware_platform i2c_piix4 irqbypass jbd2 joydev k10temp kvm
kvm_amd libahci libata lp lrw mac80211 mbcache media mii nls_cp437
nls_utf8 parport parport_pc ppdev psmouse r8169 radeon rfcomm rfkill
rtl8821ae rtl_pci rtlwifi scsi_mod sd_mod serio_raw sg shpchp snd
snd_hda_codec snd_hda_codec_generic snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_core snd_hda_intel snd_hwdep snd_pcm
snd_rawmidi snd_seq snd_seq_device snd_seq_midi snd_seq_midi_event
snd_timer soundcore syscopyarea sysfillrect sysimgblt tpm tpm_tis
tpm_tis_core ttm usb_common usbcore uvcvideo vfat video videobuf2_core
videobuf2_memops videobuf2_v4l2 videobuf2_vmalloc videodev wmi
xhci_hcd xhci_pci

[7.2.] Processor information (from /proc/cpuinfo):
processor    : 0
vendor_id    : AuthenticAMD
cpu family    : 21
model        : 96
model name    : AMD FX-8800P Radeon R7, 12 Compute Cores 4C+8G
stepping    : 1
microcode    : 0x6006110
cpu MHz        : 1400.000
cache size    : 1024 KB
physical id    : 0
siblings    : 4
core id        : 0
cpu cores    : 2
apicid        : 16
initial apicid    : 0
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good acc_power nopl
nonstop_tsc extd_apicid aperfmperf eagerfpu pni pclmulqdq monitor
ssse3 fma cx16 sse4_1 sse4_2 movbe popcnt aes xsave avx f16c rdrand
lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse
3dnowprefetch osvw ibs xop skinit wdt lwp fma4 tce nodeid_msr tbm
topoext perfctr_core perfctr_nb bpext ptsc mwaitx cpb hw_pstate
vmmcall fsgsbase bmi1 avx2 smep bmi2 xsaveopt arat npt lbrv svm_lock
nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter
pfthreshold avic overflow_recov
bugs        : fxsave_leak sysret_ss_attrs null_seg
bogomips    : 4192.20
TLB size    : 1536 4K pages
clflush size    : 64
cache_alignment    : 64
address sizes    : 48 bits physical, 48 bits virtual
power management: ts ttp tm 100mhzsteps hwpstate cpb eff_freq_ro acc_power [13]

processor    : 1
vendor_id    : AuthenticAMD
cpu family    : 21
model        : 96
model name    : AMD FX-8800P Radeon R7, 12 Compute Cores 4C+8G
stepping    : 1
microcode    : 0x6006110
cpu MHz        : 1400.000
cache size    : 1024 KB
physical id    : 0
siblings    : 4
core id        : 0
cpu cores    : 2
apicid        : 17
initial apicid    : 1
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good acc_power nopl
nonstop_tsc extd_apicid aperfmperf eagerfpu pni pclmulqdq monitor
ssse3 fma cx16 sse4_1 sse4_2 movbe popcnt aes xsave avx f16c rdrand
lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse
3dnowprefetch osvw ibs xop skinit wdt lwp fma4 tce nodeid_msr tbm
topoext perfctr_core perfctr_nb bpext ptsc mwaitx cpb hw_pstate
vmmcall fsgsbase bmi1 avx2 smep bmi2 xsaveopt arat npt lbrv svm_lock
nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter
pfthreshold avic overflow_recov
bugs        : fxsave_leak sysret_ss_attrs null_seg
bogomips    : 4182.01
TLB size    : 1536 4K pages
clflush size    : 64
cache_alignment    : 64
address sizes    : 48 bits physical, 48 bits virtual
power management: ts ttp tm 100mhzsteps hwpstate cpb eff_freq_ro acc_power [13]

processor    : 2
vendor_id    : AuthenticAMD
cpu family    : 21
model        : 96
model name    : AMD FX-8800P Radeon R7, 12 Compute Cores 4C+8G
stepping    : 1
microcode    : 0x6006110
cpu MHz        : 1400.000
cache size    : 1024 KB
physical id    : 0
siblings    : 4
core id        : 1
cpu cores    : 2
apicid        : 18
initial apicid    : 2
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good acc_power nopl
nonstop_tsc extd_apicid aperfmperf eagerfpu pni pclmulqdq monitor
ssse3 fma cx16 sse4_1 sse4_2 movbe popcnt aes xsave avx f16c rdrand
lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse
3dnowprefetch osvw ibs xop skinit wdt lwp fma4 tce nodeid_msr tbm
topoext perfctr_core perfctr_nb bpext ptsc mwaitx cpb hw_pstate
vmmcall fsgsbase bmi1 avx2 smep bmi2 xsaveopt arat npt lbrv svm_lock
nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter
pfthreshold avic overflow_recov
bugs        : fxsave_leak sysret_ss_attrs null_seg
bogomips    : 4182.01
TLB size    : 1536 4K pages
clflush size    : 64
cache_alignment    : 64
address sizes    : 48 bits physical, 48 bits virtual
power management: ts ttp tm 100mhzsteps hwpstate cpb eff_freq_ro acc_power [13]

processor    : 3
vendor_id    : AuthenticAMD
cpu family    : 21
model        : 96
model name    : AMD FX-8800P Radeon R7, 12 Compute Cores 4C+8G
stepping    : 1
microcode    : 0x6006110
cpu MHz        : 1400.000
cache size    : 1024 KB
physical id    : 0
siblings    : 4
core id        : 1
cpu cores    : 2
apicid        : 19
initial apicid    : 3
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good acc_power nopl
nonstop_tsc extd_apicid aperfmperf eagerfpu pni pclmulqdq monitor
ssse3 fma cx16 sse4_1 sse4_2 movbe popcnt aes xsave avx f16c rdrand
lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse
3dnowprefetch osvw ibs xop skinit wdt lwp fma4 tce nodeid_msr tbm
topoext perfctr_core perfctr_nb bpext ptsc mwaitx cpb hw_pstate
vmmcall fsgsbase bmi1 avx2 smep bmi2 xsaveopt arat npt lbrv svm_lock
nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter
pfthreshold avic overflow_recov
bugs        : fxsave_leak sysret_ss_attrs null_seg
bogomips    : 4182.01
TLB size    : 1536 4K pages
clflush size    : 64
cache_alignment    : 64
address sizes    : 48 bits physical, 48 bits virtual
power management: ts ttp tm 100mhzsteps hwpstate cpb eff_freq_ro acc_power [13]



[7.3.] Module information (from /proc/modules):
ctr 16384 4 - Live 0xffffffffc0b2b000
ccm 20480 2 - Live 0xffffffffc0b8e000
rfcomm 77824 0 - Live 0xffffffffc0d45000
fuse 98304 2 - Live 0xffffffffc0c77000
bnep 20480 2 - Live 0xffffffffc0b36000
binfmt_misc 20480 1 - Live 0xffffffffc0b25000
nls_utf8 16384 1 - Live 0xffffffffc0a13000
nls_cp437 20480 1 - Live 0xffffffffc0b1f000
vfat 20480 1 - Live 0xffffffffc0a27000
fat 69632 1 vfat, Live 0xffffffffc0bac000
kvm_amd 73728 0 - Live 0xffffffffc0c64000
arc4 16384 2 - Live 0xffffffffc0976000
kvm 593920 1 kvm_amd, Live 0xffffffffc0dd3000
irqbypass 16384 1 kvm, Live 0xffffffffc0a18000
crct10dif_pclmul 16384 0 - Live 0xffffffffc0a22000
crc32_pclmul 16384 0 - Live 0xffffffffc0a1d000
uvcvideo 90112 0 - Live 0xffffffffc0b95000
rtl8821ae 225280 0 - Live 0xffffffffc0d0d000
ghash_clmulni_intel 16384 0 - Live 0xffffffffc0a0e000
videobuf2_vmalloc 16384 1 uvcvideo, Live 0xffffffffc0b1a000
snd_hda_codec_realtek 86016 1 - Live 0xffffffffc0dbd000
videobuf2_memops 16384 1 videobuf2_vmalloc, Live 0xffffffffc093a000
videobuf2_v4l2 24576 1 uvcvideo, Live 0xffffffffc0ace000
btcoexist 53248 1 rtl8821ae, Live 0xffffffffc0daf000
snd_hda_codec_generic 69632 1 snd_hda_codec_realtek, Live 0xffffffffc0d9d000
videobuf2_core 40960 2 uvcvideo,videobuf2_v4l2, Live 0xffffffffc0b58000
rtl_pci 28672 1 rtl8821ae, Live 0xffffffffc0ad9000
snd_hda_codec_hdmi 45056 1 - Live 0xffffffffc0ac2000
videodev 176128 3 uvcvideo,videobuf2_v4l2,videobuf2_core, Live
0xffffffffc0d61000
rtlwifi 77824 2 rtl8821ae,rtl_pci, Live 0xffffffffc0cb0000
snd_hda_intel 36864 5 - Live 0xffffffffc0a30000
media 40960 2 uvcvideo,videodev, Live 0xffffffffc0d02000
snd_hda_codec 135168 4
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_intel,
Live 0xffffffffc0cd0000
snd_hda_core 81920 5
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,
Live 0xffffffffc0c90000
mac80211 663552 3 rtl8821ae,rtl_pci,rtlwifi, Live 0xffffffffc0bc1000
snd_hwdep 16384 1 snd_hda_codec, Live 0xffffffffc0b09000
aesni_intel 167936 4 - Live 0xffffffffc0b64000
snd_pcm 110592 4
snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_hda_core, Live
0xffffffffc0b3c000
aes_x86_64 20480 1 aesni_intel, Live 0xffffffffc0b30000
lrw 16384 1 aesni_intel, Live 0xffffffffc0b04000
btusb 45056 0 - Live 0xffffffffc0b0e000
btrtl 16384 1 btusb, Live 0xffffffffc094f000
joydev 20480 0 - Live 0xffffffffc0afa000
btbcm 16384 1 btusb, Live 0xffffffffc0af5000
gf128mul 16384 1 lrw, Live 0xffffffffc0af0000
btintel 16384 1 btusb, Live 0xffffffffc0aeb000
efi_pstore 16384 0 - Live 0xffffffffc0ae6000
snd_seq_midi 16384 0 - Live 0xffffffffc0966000
glue_helper 16384 1 aesni_intel, Live 0xffffffffc0961000
snd_seq_midi_event 16384 1 snd_seq_midi, Live 0xffffffffc092c000
ablk_helper 16384 1 aesni_intel, Live 0xffffffffc0ae1000
bluetooth 544768 31 rfcomm,bnep,btusb,btrtl,btbcm,btintel, Live
0xffffffffc0a3c000
cryptd 24576 3 ghash_clmulni_intel,aesni_intel,ablk_helper, Live
0xffffffffc096f000
cfg80211 589824 2 rtlwifi,mac80211, Live 0xffffffffc097d000
rfkill 24576 6 bluetooth,cfg80211, Live 0xffffffffc095a000
efivars 20480 1 efi_pstore, Live 0xffffffffc0954000
snd_rawmidi 32768 1 snd_seq_midi, Live 0xffffffffc0946000
sg 32768 0 - Live 0xffffffffc0931000
serio_raw 16384 0 - Live 0xffffffffc0804000
k10temp 16384 0 - Live 0xffffffffc0927000
fam15h_power 16384 0 - Live 0xffffffffc0911000
i2c_piix4 24576 0 - Live 0xffffffffc093f000
snd_seq 65536 2 snd_seq_midi,snd_seq_midi_event, Live 0xffffffffc0916000
battery 16384 0 - Live 0xffffffffc090c000
snd_seq_device 16384 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0xffffffffc07ff000
i2c_designware_platform 16384 0 - Live 0xffffffffc0635000
snd_timer 32768 2 snd_pcm,snd_seq, Live 0xffffffffc08da000
ac 16384 0 - Live 0xffffffffc0812000
i2c_designware_core 20480 1 i2c_designware_platform, Live 0xffffffffc03dc000
snd 86016 21 snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_seq_device,snd_timer,
Live 0xffffffffc08f6000
evdev 24576 25 - Live 0xffffffffc08e3000
soundcore 16384 1 snd, Live 0xffffffffc07fa000
acpi_cpufreq 20480 0 - Live 0xffffffffc08ec000
tpm_tis 16384 0 - Live 0xffffffffc0817000
shpchp 36864 0 - Live 0xffffffffc08d0000
tpm_tis_core 20480 1 tpm_tis, Live 0xffffffffc080c000
tpm 45056 2 tpm_tis,tpm_tis_core, Live 0xffffffffc07ee000
parport_pc 28672 0 - Live 0xffffffffc07e6000
ppdev 20480 0 - Live 0xffffffffc04da000
lp 20480 0 - Live 0xffffffffc0439000
parport 49152 3 parport_pc,ppdev,lp, Live 0xffffffffc0628000
efivarfs 16384 1 - Live 0xffffffffc0434000
autofs4 40960 2 - Live 0xffffffffc03fe000
ext4 589824 2 - Live 0xffffffffc083f000
crc16 16384 2 bluetooth,ext4, Live 0xffffffffc0332000
jbd2 110592 1 ext4, Live 0xffffffffc060c000
fscrypto 28672 1 ext4, Live 0xffffffffc0386000
mbcache 16384 3 ext4, Live 0xffffffffc032d000
sd_mod 45056 6 - Live 0xffffffffc03d0000
crc32c_intel 24576 0 - Live 0xffffffffc037f000
psmouse 131072 0 - Live 0xffffffffc040e000
ahci 36864 4 - Live 0xffffffffc0323000
amdkfd 139264 2 - Live 0xffffffffc081c000
libahci 32768 1 ahci, Live 0xffffffffc033a000
radeon 1495040 0 - Live 0xffffffffc0678000
libata 249856 2 ahci,libahci, Live 0xffffffffc063a000
amdgpu 1187840 3 - Live 0xffffffffc04e9000
ehci_pci 16384 0 - Live 0xffffffffc04e0000
ehci_hcd 81920 1 ehci_pci, Live 0xffffffffc04c5000
r8169 81920 0 - Live 0xffffffffc04b0000
xhci_pci 16384 0 - Live 0xffffffffc042f000
mii 16384 1 r8169, Live 0xffffffffc0409000
xhci_hcd 188416 1 xhci_pci, Live 0xffffffffc0481000
scsi_mod 225280 3 sg,sd_mod,libata, Live 0xffffffffc0449000
i2c_algo_bit 16384 2 radeon,amdgpu, Live 0xffffffffc0442000
ttm 98304 2 radeon,amdgpu, Live 0xffffffffc03e5000
usbcore 253952 6 uvcvideo,btusb,ehci_pci,ehci_hcd,xhci_pci,xhci_hcd,
Live 0xffffffffc0391000
drm_kms_helper 155648 2 radeon,amdgpu, Live 0xffffffffc0358000
usb_common 16384 1 usbcore, Live 0xffffffffc0353000
syscopyarea 16384 1 drm_kms_helper, Live 0xffffffffc034e000
sysfillrect 16384 1 drm_kms_helper, Live 0xffffffffc0349000
sysimgblt 16384 1 drm_kms_helper, Live 0xffffffffc0344000
fb_sys_fops 16384 1 drm_kms_helper, Live 0xffffffffc02bc000
drm 360448 50 radeon,amdgpu,ttm,drm_kms_helper, Live 0xffffffffc02ca000
wmi 16384 0 - Live 0xffffffffc02c1000
video 40960 0 - Live 0xffffffffc02b1000
fjes 28672 0 - Live 0xffffffffc02a5000
button 16384 0 - Live 0xffffffffc029c000



[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
# cat /proc/modules
ctr 16384 4 - Live 0xffffffffc0b2b000
ccm 20480 2 - Live 0xffffffffc0b8e000
rfcomm 77824 0 - Live 0xffffffffc0d45000
fuse 98304 2 - Live 0xffffffffc0c77000
bnep 20480 2 - Live 0xffffffffc0b36000
binfmt_misc 20480 1 - Live 0xffffffffc0b25000
nls_utf8 16384 1 - Live 0xffffffffc0a13000
nls_cp437 20480 1 - Live 0xffffffffc0b1f000
vfat 20480 1 - Live 0xffffffffc0a27000
fat 69632 1 vfat, Live 0xffffffffc0bac000
kvm_amd 73728 0 - Live 0xffffffffc0c64000
arc4 16384 2 - Live 0xffffffffc0976000
kvm 593920 1 kvm_amd, Live 0xffffffffc0dd3000
irqbypass 16384 1 kvm, Live 0xffffffffc0a18000
crct10dif_pclmul 16384 0 - Live 0xffffffffc0a22000
crc32_pclmul 16384 0 - Live 0xffffffffc0a1d000
uvcvideo 90112 0 - Live 0xffffffffc0b95000
rtl8821ae 225280 0 - Live 0xffffffffc0d0d000
ghash_clmulni_intel 16384 0 - Live 0xffffffffc0a0e000
videobuf2_vmalloc 16384 1 uvcvideo, Live 0xffffffffc0b1a000
snd_hda_codec_realtek 86016 1 - Live 0xffffffffc0dbd000
videobuf2_memops 16384 1 videobuf2_vmalloc, Live 0xffffffffc093a000
videobuf2_v4l2 24576 1 uvcvideo, Live 0xffffffffc0ace000
btcoexist 53248 1 rtl8821ae, Live 0xffffffffc0daf000
snd_hda_codec_generic 69632 1 snd_hda_codec_realtek, Live 0xffffffffc0d9d000
videobuf2_core 40960 2 uvcvideo,videobuf2_v4l2, Live 0xffffffffc0b58000
rtl_pci 28672 1 rtl8821ae, Live 0xffffffffc0ad9000
snd_hda_codec_hdmi 45056 1 - Live 0xffffffffc0ac2000
videodev 176128 3 uvcvideo,videobuf2_v4l2,videobuf2_core, Live
0xffffffffc0d61000
rtlwifi 77824 2 rtl8821ae,rtl_pci, Live 0xffffffffc0cb0000
snd_hda_intel 36864 5 - Live 0xffffffffc0a30000
media 40960 2 uvcvideo,videodev, Live 0xffffffffc0d02000
snd_hda_codec 135168 4
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_intel,
Live 0xffffffffc0cd0000
snd_hda_core 81920 5
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,
Live 0xffffffffc0c90000
mac80211 663552 3 rtl8821ae,rtl_pci,rtlwifi, Live 0xffffffffc0bc1000
snd_hwdep 16384 1 snd_hda_codec, Live 0xffffffffc0b09000
aesni_intel 167936 4 - Live 0xffffffffc0b64000
snd_pcm 110592 4
snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_hda_core, Live
0xffffffffc0b3c000
aes_x86_64 20480 1 aesni_intel, Live 0xffffffffc0b30000
lrw 16384 1 aesni_intel, Live 0xffffffffc0b04000
btusb 45056 0 - Live 0xffffffffc0b0e000
btrtl 16384 1 btusb, Live 0xffffffffc094f000
joydev 20480 0 - Live 0xffffffffc0afa000
btbcm 16384 1 btusb, Live 0xffffffffc0af5000
gf128mul 16384 1 lrw, Live 0xffffffffc0af0000
btintel 16384 1 btusb, Live 0xffffffffc0aeb000
efi_pstore 16384 0 - Live 0xffffffffc0ae6000
snd_seq_midi 16384 0 - Live 0xffffffffc0966000
glue_helper 16384 1 aesni_intel, Live 0xffffffffc0961000
snd_seq_midi_event 16384 1 snd_seq_midi, Live 0xffffffffc092c000
ablk_helper 16384 1 aesni_intel, Live 0xffffffffc0ae1000
bluetooth 544768 31 rfcomm,bnep,btusb,btrtl,btbcm,btintel, Live
0xffffffffc0a3c000
cryptd 24576 3 ghash_clmulni_intel,aesni_intel,ablk_helper, Live
0xffffffffc096f000
cfg80211 589824 2 rtlwifi,mac80211, Live 0xffffffffc097d000
rfkill 24576 6 bluetooth,cfg80211, Live 0xffffffffc095a000
efivars 20480 1 efi_pstore, Live 0xffffffffc0954000
snd_rawmidi 32768 1 snd_seq_midi, Live 0xffffffffc0946000
sg 32768 0 - Live 0xffffffffc0931000
serio_raw 16384 0 - Live 0xffffffffc0804000
k10temp 16384 0 - Live 0xffffffffc0927000
fam15h_power 16384 0 - Live 0xffffffffc0911000
i2c_piix4 24576 0 - Live 0xffffffffc093f000
snd_seq 65536 2 snd_seq_midi,snd_seq_midi_event, Live 0xffffffffc0916000
battery 16384 0 - Live 0xffffffffc090c000
snd_seq_device 16384 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0xffffffffc07ff000
i2c_designware_platform 16384 0 - Live 0xffffffffc0635000
snd_timer 32768 2 snd_pcm,snd_seq, Live 0xffffffffc08da000
ac 16384 0 - Live 0xffffffffc0812000
i2c_designware_core 20480 1 i2c_designware_platform, Live 0xffffffffc03dc000
snd 86016 21 snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_seq_device,snd_timer,
Live 0xffffffffc08f6000
evdev 24576 25 - Live 0xffffffffc08e3000
soundcore 16384 1 snd, Live 0xffffffffc07fa000
acpi_cpufreq 20480 0 - Live 0xffffffffc08ec000
tpm_tis 16384 0 - Live 0xffffffffc0817000
shpchp 36864 0 - Live 0xffffffffc08d0000
tpm_tis_core 20480 1 tpm_tis, Live 0xffffffffc080c000
tpm 45056 2 tpm_tis,tpm_tis_core, Live 0xffffffffc07ee000
parport_pc 28672 0 - Live 0xffffffffc07e6000
ppdev 20480 0 - Live 0xffffffffc04da000
lp 20480 0 - Live 0xffffffffc0439000
parport 49152 3 parport_pc,ppdev,lp, Live 0xffffffffc0628000
efivarfs 16384 1 - Live 0xffffffffc0434000
autofs4 40960 2 - Live 0xffffffffc03fe000
ext4 589824 2 - Live 0xffffffffc083f000
crc16 16384 2 bluetooth,ext4, Live 0xffffffffc0332000
jbd2 110592 1 ext4, Live 0xffffffffc060c000
fscrypto 28672 1 ext4, Live 0xffffffffc0386000
mbcache 16384 3 ext4, Live 0xffffffffc032d000
sd_mod 45056 6 - Live 0xffffffffc03d0000
crc32c_intel 24576 0 - Live 0xffffffffc037f000
psmouse 131072 0 - Live 0xffffffffc040e000
ahci 36864 4 - Live 0xffffffffc0323000
amdkfd 139264 2 - Live 0xffffffffc081c000
libahci 32768 1 ahci, Live 0xffffffffc033a000
radeon 1495040 0 - Live 0xffffffffc0678000
libata 249856 2 ahci,libahci, Live 0xffffffffc063a000
amdgpu 1187840 3 - Live 0xffffffffc04e9000
ehci_pci 16384 0 - Live 0xffffffffc04e0000
ehci_hcd 81920 1 ehci_pci, Live 0xffffffffc04c5000
r8169 81920 0 - Live 0xffffffffc04b0000
xhci_pci 16384 0 - Live 0xffffffffc042f000
mii 16384 1 r8169, Live 0xffffffffc0409000
xhci_hcd 188416 1 xhci_pci, Live 0xffffffffc0481000
scsi_mod 225280 3 sg,sd_mod,libata, Live 0xffffffffc0449000
i2c_algo_bit 16384 2 radeon,amdgpu, Live 0xffffffffc0442000
ttm 98304 2 radeon,amdgpu, Live 0xffffffffc03e5000
usbcore 253952 6 uvcvideo,btusb,ehci_pci,ehci_hcd,xhci_pci,xhci_hcd,
Live 0xffffffffc0391000
drm_kms_helper 155648 2 radeon,amdgpu, Live 0xffffffffc0358000
usb_common 16384 1 usbcore, Live 0xffffffffc0353000
syscopyarea 16384 1 drm_kms_helper, Live 0xffffffffc034e000
sysfillrect 16384 1 drm_kms_helper, Live 0xffffffffc0349000
sysimgblt 16384 1 drm_kms_helper, Live 0xffffffffc0344000
fb_sys_fops 16384 1 drm_kms_helper, Live 0xffffffffc02bc000
drm 360448 50 radeon,amdgpu,ttm,drm_kms_helper, Live 0xffffffffc02ca000
wmi 16384 0 - Live 0xffffffffc02c1000
video 40960 0 - Live 0xffffffffc02b1000
fjes 28672 0 - Live 0xffffffffc02a5000
button 16384 0 - Live 0xffffffffc029c000
root@antishkka-amd:/#
root@antishkka-amd:/#
root@antishkka-amd:/#
root@antishkka-amd:/# cat /proc/ioports
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0061-0061 : PNP0800:00
  0062-0062 : PNP0C09:00
    0062-0062 : EC data
  0064-0064 : keyboard
  0066-0066 : PNP0C09:00
    0066-0066 : EC cmd
  0070-0071 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
    00f0-00fe : PNP0C04:00
  0400-04cf : pnp 00:04
    0400-0403 : ACPI PM1a_EVT_BLK
    0404-0405 : ACPI PM1a_CNT_BLK
    0408-040b : ACPI PM_TMR
    0410-0415 : ACPI CPU throttle
    0420-0427 : ACPI GPE0_BLK
  04d0-04d1 : pnp 00:04
  04d6-04d6 : pnp 00:04
  0800-0800 : ACPI PM2_CNT_BLK
  0b00-0b07 : piix4_smbus
  0b20-0b3f : SMB0001:00
  0c00-0c01 : pnp 00:04
  0c14-0c14 : pnp 00:04
  0c50-0c52 : pnp 00:04
  0c6c-0c6c : pnp 00:04
  0c6f-0c6f : pnp 00:04
  0cd0-0cdb : pnp 00:04
    0cd6-0cd7 : smba_idx
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  2000-2fff : PCI Bus 0000:03
    2000-20ff : 0000:03:00.0
  3000-3fff : PCI Bus 0000:02
    3000-30ff : 0000:02:00.0
      3000-30ff : rtl_pci
  4000-4fff : PCI Bus 0000:01
    4000-40ff : 0000:01:00.0
      4000-40ff : r8169
  5000-50ff : 0000:00:01.0
  5100-510f : 0000:00:11.0
    5100-510f : ahci
  5110-5117 : 0000:00:11.0
    5110-5117 : ahci
  5118-511f : 0000:00:11.0
    5118-511f : ahci
  5120-5123 : 0000:00:11.0
    5120-5123 : ahci
  5124-5127 : 0000:00:11.0
    5124-5127 : ahci


# cat /proc/iomem
00000000-00000fff : reserved
00001000-00087fff : System RAM
00088000-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000cfbff : Video ROM
  000c0000-000c3fff : PCI Bus 0000:00
  000c4000-000c7fff : PCI Bus 0000:00
  000c8000-000cbfff : PCI Bus 0000:00
000d0000-000d3fff : PCI Bus 0000:00
000d4000-000d7fff : PCI Bus 0000:00
000d8000-000dbfff : PCI Bus 0000:00
000dc000-000dffff : PCI Bus 0000:00
000e0000-000e3fff : PCI Bus 0000:00
000e4000-000e7fff : PCI Bus 0000:00
000e8000-000ebfff : PCI Bus 0000:00
000ec000-000effff : PCI Bus 0000:00
000f0000-000fffff : System ROM
00100000-b8b85fff : System RAM
  19200000-198220db : Kernel code
  198220dc-19f53c7f : Kernel data
  1a0da000-1a200fff : Kernel bss
b8b86000-b9485fff : reserved
b9486000-bf08efff : System RAM
bf08f000-bf28efff : reserved
bf28f000-bfa7efff : reserved
bfa7f000-bfb7efff : ACPI Non-volatile Storage
bfb7f000-bfbfefff : ACPI Tables
bfbff000-bfbfffff : System RAM
bfc00000-bfffffff : RAM buffer
c0000000-f7ffffff : PCI Bus 0000:00
  c0000000-d07fffff : PCI Bus 0000:03
    c0000000-cfffffff : 0000:03:00.0
    d0000000-d07fffff : 0000:03:00.0
  d0800000-d0ffffff : 0000:00:01.0
  d1000000-d10fffff : pnp 00:00
  d1100000-d11fffff : 0000:00:08.0
  d1200000-d12fffff : PCI Bus 0000:03
    d1200000-d123ffff : 0000:03:00.0
    d1240000-d125ffff : 0000:03:00.0
  d1300000-d13fffff : PCI Bus 0000:02
    d1300000-d1303fff : 0000:02:00.0
      d1300000-d1303fff : rtl_pci
  d1400000-d14fffff : PCI Bus 0000:01
    d1400000-d1403fff : 0000:01:00.0
      d1400000-d1403fff : r8169
    d1404000-d1404fff : 0000:01:00.0
      d1404000-d1404fff : r8169
  d1500000-d153ffff : 0000:00:01.0
  d1540000-d155ffff : 0000:00:08.0
  d1560000-d1563fff : 0000:00:01.1
    d1560000-d1563fff : ICH HD audio
  d1564000-d1567fff : 0000:00:09.2
    d1564000-d1567fff : ICH HD audio
  d1568000-d1569fff : 0000:00:10.0
    d1568000-d1569fff : xhci-hcd
  d156a000-d156bfff : 0000:00:08.0
  d156c000-d156c3ff : 0000:00:11.0
    d156c000-d156c3ff : ahci
  d156d000-d156d0ff : 0000:00:12.0
    d156d000-d156d0ff : ehci_hcd
  d156f000-d156ffff : 0000:00:08.0
  e0000000-efffffff : 0000:00:01.0
    e0000000-e07e8fff : BOOTFB
f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]
  f8000000-fbffffff : reserved
fc000000-fed3ffff : PCI Bus 0000:00
  fec00000-fec00fff : reserved
    fec00000-fec003ff : IOAPIC 0
  fec01000-fec013ff : IOAPIC 1
  fec10000-fec10fff : reserved
  fed00000-fed003ff : HPET 0
    fed00000-fed003ff : PNP0103:00
fed80000-fed80fff : reserved
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
    fee00000-fee00fff : pnp 00:00
ff800000-ffffffff : reserved
  ff800000-ffffffff : pnp 00:05
100000000-1feffffff : System RAM
1ff000000-1ffffffff : RAM buffer



[7.5.] PCI information ('lspci -vvv' as root):
# lspci -vvv
00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1576
    Subsystem: Lenovo Device 3807
    Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0

00:01.0 VGA compatible controller: Advanced Micro Devices, Inc.
[AMD/ATI] Carrizo (rev c4) (prog-if 00 [VGA controller])
    Subsystem: Lenovo Carrizo
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 37
    Region 0: Memory at e0000000 (64-bit, prefetchable) [size=256M]
    Region 2: Memory at d0800000 (64-bit, prefetchable) [size=8M]
    Region 4: I/O ports at 5000 [size=256]
    Region 5: Memory at d1500000 (32-bit, non-prefetchable) [size=256K]
    Expansion ROM at 000c0000 [disabled] [size=128K]
    Capabilities: [48] Vendor Specific Information: Len=08 <?>
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1+,D2+,D3hot+,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [58] Express (v2) Root Complex Integrated Endpoint, MSI 00
        DevCap:    MaxPayload 256 bytes, PhantFunc 0
            ExtTag+ RBE+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-,
OBFF Not Supported
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
OBFF Disabled
    Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee0200c  Data: 4182
    Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1
Len=010 <?>
    Capabilities: [270 v1] #19
    Capabilities: [2b0 v1] Address Translation Service (ATS)
        ATSCap:    Invalidate Queue Depth: 00
        ATSCtl:    Enable-, Smallest Translation Unit: 00
    Capabilities: [2c0 v1] #13
    Capabilities: [2d0 v1] #1b
    Kernel driver in use: amdgpu
    Kernel modules: amdgpu

00:01.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Kabini
HDMI/DP Audio
    Subsystem: Lenovo Kabini HDMI/DP Audio
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin B routed to IRQ 39
    Region 0: Memory at d1560000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [48] Vendor Specific Information: Len=08 <?>
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [58] Express (v2) Root Complex Integrated Endpoint, MSI 00
        DevCap:    MaxPayload 256 bytes, PhantFunc 0
            ExtTag+ RBE+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-,
OBFF Not Supported
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
OBFF Disabled
    Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee0e00c  Data: 41b2
    Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1
Len=010 <?>
    Kernel driver in use: snd_hda_intel
    Kernel modules: snd_hda_intel

00:02.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 157b
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:02.2 PCI bridge: Advanced Micro Devices, Inc. [AMD] Device 157c
(prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 25
    Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
    I/O behind bridge: 00004000-00004fff
    Memory behind bridge: d1400000-d14fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 512 bytes, PhantFunc 0
            ExtTag+ RBE+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
        LnkCap:    Port #0, Speed 8GT/s, Width x4, ASPM L0s L1, Exit
Latency L0s <512ns, L1 <64us
            ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt+ ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
            Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
            Changed: MRL- PresDet- LinkState+
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible+
        RootCap: CRSVisible+
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-,
OBFF Not Supported ARIFwd-
        DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis-, LTR-,
OBFF Disabled ARIFwd-
        LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee0f00c  Data: 4171
    Capabilities: [c0] Subsystem: Lenovo Device 3807
    Capabilities: [c8] HyperTransport: MSI Mapping Enable+ Fixed+
    Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1
Len=010 <?>
    Capabilities: [270 v1] #19
    Kernel driver in use: pcieport
    Kernel modules: shpchp

00:02.3 PCI bridge: Advanced Micro Devices, Inc. [AMD] Device 157c
(prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 26
    Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
    I/O behind bridge: 00003000-00003fff
    Memory behind bridge: d1300000-d13fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 512 bytes, PhantFunc 0
            ExtTag+ RBE+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
        LnkCap:    Port #1, Speed 8GT/s, Width x2, ASPM L0s L1, Exit
Latency L0s <512ns, L1 <64us
            ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
        LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt+ ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
            Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
            Changed: MRL- PresDet- LinkState+
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible+
        RootCap: CRSVisible+
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-,
OBFF Not Supported ARIFwd-
        DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis-, LTR-,
OBFF Disabled ARIFwd-
        LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee0f00c  Data: 4181
    Capabilities: [c0] Subsystem: Lenovo Device 3807
    Capabilities: [c8] HyperTransport: MSI Mapping Enable+ Fixed+
    Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1
Len=010 <?>
    Capabilities: [270 v1] #19
    Kernel driver in use: pcieport
    Kernel modules: shpchp

00:03.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 157b
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:03.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Device 157c
(prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 28
    Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
    I/O behind bridge: 00002000-00002fff
    Memory behind bridge: d1200000-d12fffff
    Prefetchable memory behind bridge: 00000000c0000000-00000000d07fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 512 bytes, PhantFunc 0
            ExtTag+ RBE+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 256 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
        LnkCap:    Port #0, Speed 8GT/s, Width x8, ASPM L0s L1, Exit
Latency L0s <512ns, L1 <64us
            ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
        LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 8GT/s, Width x8, TrErr- Train- SlotClk+
DLActive+ BWMgmt+ ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise-
            Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt-
HPIrq+ LinkChg+
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible+
        RootCap: CRSVisible+
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-,
OBFF Not Supported ARIFwd-
        DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis-, LTR-,
OBFF Disabled ARIFwd-
        LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete+, EqualizationPhase1+
             EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
    Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee0f00c  Data: 41a1
    Capabilities: [c0] Subsystem: Lenovo Device 3807
    Capabilities: [c8] HyperTransport: MSI Mapping Enable+ Fixed+
    Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1
Len=010 <?>
    Capabilities: [270 v1] #19
    Kernel driver in use: pcieport
    Kernel modules: shpchp

00:08.0 Encryption controller: Advanced Micro Devices, Inc. [AMD] Device 1578
    Subsystem: Lenovo Device 3807
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 3
    Region 0: Memory at d1540000 (64-bit, prefetchable) [size=128K]
    Region 2: Memory at d1100000 (32-bit, non-prefetchable) [size=1M]
    Region 3: Memory at d156f000 (32-bit, non-prefetchable) [size=4K]
    Region 5: Memory at d156a000 (32-bit, non-prefetchable) [size=8K]
    Capabilities: [50] MSI-X: Enable- Count=2 Masked-
        Vector table: BAR=5 offset=00000000
        PBA: BAR=5 offset=00001000
    Capabilities: [5c] HyperTransport: MSI Mapping Enable+ Fixed+
    Capabilities: [60] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [a4] PCI Advanced Features
        AFCap: TP+ FLR-
        AFCtrl: FLR-
        AFStatus: TP-

00:09.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 157d
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:09.2 Audio device: Advanced Micro Devices, Inc. [AMD] Device 157a
    Subsystem: Lenovo Device 3807
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 40
    Region 0: Memory at d1564000 (32-bit, non-prefetchable) [size=16K]
    Capabilities: [60] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [a4] PCI Advanced Features
        AFCap: TP+ FLR-
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: snd_hda_intel
    Kernel modules: snd_hda_intel

00:10.0 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB
XHCI Controller (rev 20) (prog-if 30 [XHCI])
    Subsystem: Lenovo FCH USB XHCI Controller
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 18
    Region 0: Memory at d1568000 (64-bit, non-prefetchable) [size=8K]
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [70] MSI: Enable- Count=1/8 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Capabilities: [90] MSI-X: Enable+ Count=8 Masked-
        Vector table: BAR=0 offset=00001000
        PBA: BAR=0 offset=00001080
    Capabilities: [a0] Express (v2) Root Complex Integrated Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0
            ExtTag- RBE+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR+,
OBFF Not Supported
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
OBFF Disabled
    Capabilities: [100 v1] Latency Tolerance Reporting
        Max snoop latency: 0ns
        Max no snoop latency: 0ns
    Kernel driver in use: xhci_hcd
    Kernel modules: xhci_pci

00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD] FCH SATA
Controller [AHCI mode] (rev 49) (prog-if 01 [AHCI 1.0])
    Subsystem: Lenovo FCH SATA Controller [AHCI mode]
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 64, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 19
    Region 0: I/O ports at 5118 [size=8]
    Region 1: I/O ports at 5124 [size=4]
    Region 2: I/O ports at 5110 [size=8]
    Region 3: I/O ports at 5120 [size=4]
    Region 4: I/O ports at 5100 [size=16]
    Region 5: Memory at d156c000 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [60] Power Management version 3
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [70] SATA HBA v1.0 InCfgSpace
    Kernel driver in use: ahci
    Kernel modules: ahci

00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB
EHCI Controller (rev 49) (prog-if 20 [EHCI])
    Subsystem: Lenovo FCH USB EHCI Controller
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 32, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 18
    Region 0: Memory at d156d000 (32-bit, non-prefetchable) [size=256]
    Capabilities: [c0] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Bridge: PM- B3+
    Capabilities: [e4] Debug port: BAR=1 offset=00e0
    Kernel driver in use: ehci-pci
    Kernel modules: ehci_pci

00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller (rev 4a)
    Subsystem: Lenovo FCH SMBus Controller
    Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Kernel driver in use: piix4_smbus
    Kernel modules: i2c_piix4, sp5100_tco

00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge (rev 11)
    Subsystem: Lenovo FCH LPC Bridge
    Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0

00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1570
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1571
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1572
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1573
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Capabilities: [f0] Secure device <?>
    Kernel driver in use: k10temp
    Kernel modules: k10temp

00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1574
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Kernel driver in use: fam15h_power
    Kernel modules: fam15h_power

00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1575
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 15)
    Subsystem: Lenovo RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 35
    Region 0: I/O ports at 4000 [size=256]
    Region 2: Memory at d1404000 (64-bit, non-prefetchable) [size=4K]
    Region 4: Memory at d1400000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [40] Power Management version 3
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee0f00c  Data: 4162
    Capabilities: [70] Express (v2) Endpoint, MSI 01
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <64us
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 4096 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit
Latency L0s unlimited, L1 <64us
            ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR+,
OBFF Via message/WAKE#
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
OBFF Disabled
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
        Vector table: BAR=4 offset=00000000
        PBA: BAR=4 offset=00000800
    Capabilities: [100 v2] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
        CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        AERCap:    First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
    Capabilities: [140 v1] Virtual Channel
        Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed- WRR32- WRR64- WRR128-
        Ctrl:    ArbSelect=Fixed
        Status:    InProgress-
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
            Status:    NegoPending- InProgress-
    Capabilities: [160 v1] Device Serial Number 01-00-00-00-68-4c-e0-00
    Capabilities: [170 v1] Latency Tolerance Reporting
        Max snoop latency: 0ns
        Max no snoop latency: 0ns
    Capabilities: [178 v1] L1 PM Substates
        L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+
L1_PM_Substates+
              PortCommonModeRestoreTime=150us PortTPowerOnTime=150us
    Kernel driver in use: r8169
    Kernel modules: r8169

02:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8821AE
802.11ac PCIe Wireless Network Adapter
    Subsystem: Lenovo RTL8821AE 802.11ac PCIe Wireless Network Adapter
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 42
    Region 0: I/O ports at 3000 [size=256]
    Region 2: Memory at d1300000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [40] Power Management version 3
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee0400c  Data: 41e2
    Capabilities: [70] Express (v2) Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 <64us
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit
Latency L0s <512ns, L1 <64us
            ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
        LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR+,
OBFF Via message/WAKE#
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+, LTR-,
OBFF Disabled
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [100 v2] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
        CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        AERCap:    First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
    Capabilities: [140 v1] Device Serial Number 00-e0-4c-ff-fe-87-2b-01
    Capabilities: [150 v1] Latency Tolerance Reporting
        Max snoop latency: 0ns
        Max no snoop latency: 0ns
    Capabilities: [158 v1] L1 PM Substates
        L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+
L1_PM_Substates+
              PortCommonModeRestoreTime=150us PortTPowerOnTime=150us
    Kernel driver in use: rtl8821ae
    Kernel modules: rtl8821ae

03:00.0 Display controller: Advanced Micro Devices, Inc. [AMD/ATI]
Bonaire XT [Radeon R9 M280X] (rev 80)
    Subsystem: Lenovo Bonaire XT [Radeon R9 M280X]
    Physical Slot: 0
    Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Interrupt: pin A routed to IRQ 24
    Region 0: Memory at c0000000 (64-bit, prefetchable) [size=256M]
    Region 2: Memory at d0000000 (64-bit, prefetchable) [size=8M]
    Region 4: I/O ports at 2000 [size=256]
    Region 5: Memory at d1200000 (32-bit, non-prefetchable) [size=256K]
    Expansion ROM at d1240000 [disabled] [size=128K]
    Capabilities: [48] Vendor Specific Information: Len=08 <?>
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1+,D2+,D3hot+,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
        DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s
<4us, L1 unlimited
            ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 256 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
        LnkCap:    Port #0, Speed 8GT/s, Width x16, ASPM L0s L1, Exit
Latency L0s <64ns, L1 <1us
            ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
        LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 8GT/s, Width x8, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-,
OBFF Not Supported
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
OBFF Disabled
        LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete+, EqualizationPhase1+
             EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
    Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1
Len=010 <?>
    Capabilities: [150 v2] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        AERCap:    First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
    Capabilities: [270 v1] #19
    Capabilities: [2b0 v1] Address Translation Service (ATS)
        ATSCap:    Invalidate Queue Depth: 00
        ATSCtl:    Enable-, Smallest Translation Unit: 00
    Capabilities: [2c0 v1] #13
    Capabilities: [2d0 v1] #1b
    Kernel modules: radeon




[7.6.] SCSI information (from /proc/scsi/scsi)
# cat /proc/scsi/scsi
cat: /proc/scsi/scsi: No such file or directory

[7.7.] Other information that might be relevant to the problem (please
look in /proc and include all
information that you think to be relevant):
# modinfo rtl8821ae
filename:
/lib/modules/4.8.0-040800rc6-generic/kernel/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/rtl8821ae.ko
firmware:       rtlwifi/rtl8821aefw.bin
description:    Realtek 8821ae 802.11ac PCI wireless
license:        GPL
author:         Realtek WlanFAE    <wlanfae@realtek.com>
alias:          pci:v000010ECd00008821sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008812sv*sd*bc*sc*i*
depends:        rtlwifi,rtl_pci,btcoexist,mac80211
intree:         Y
vermagic:       4.8.0-040800rc6-generic SMP mod_unload modversions
parm:           swenc:Set to 1 for software crypto (default 0)
 (bool)
parm:           ips:Set to 0 to not use link power save (default 1)
 (bool)
parm:           swlps:Set to 1 to use SW control power save (default 0)
 (bool)
parm:           fwlps:Set to 1 to use FW control power save (default 1)
 (bool)
parm:           msi:Set to 1 to use MSI interrupts mode (default 1)
 (bool)
parm:           debug:Set debug level (0-5) (default 0) (int)
parm:           disable_watchdog:Set to 1 to disable the watchdog (default 0)
 (bool)
parm:           int_clear:Set to 0 to disable interrupt clear before
set (default 1)



[8.] Other notes, patches, fixes, workarounds:
Was reported to Ubuntu here:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1622293
Latest version of https://github.com/lwfinger/rtlwifi_new on kernel
4.2 and kernel 4.2 by default were having the same issue apearing more
explicitly: speed was dropping to 0, not to 50KB/s.

-- 
Best regards,
Antony Polukhin
