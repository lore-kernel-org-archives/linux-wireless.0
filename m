Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:36857 "EHLO
	mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbcAGWFa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 17:05:30 -0500
Received: by mail-lf0-f47.google.com with SMTP id z124so336002061lfa.3
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2016 14:05:28 -0800 (PST)
Subject: Re: Fwd: 8192 WiFi Realtek 8192E disconnects after a while and fails
 to reconnect
To: gilbertdion@gmail.com, Larry.Finger@lwfinger.net,
	wlanfae@realtek.com, chaoming_li@realsil.com.cn
References: <CAKQFV0H+K46CO62w=9yNRvVaOpwmDj3UKXD0QOmF1XPs54GwnQ@mail.gmail.com>
 <CAKQFV0EV9WvmzJaUaFEGODc-kxpt=rXJVYe5Md4oM5H00cBaeQ@mail.gmail.com>
Cc: linux-wireless@vger.kernel.org
From: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>
Message-ID: <568EE125.1030103@gmail.com> (sfid-20160107_230551_881588_868417F9)
Date: Thu, 7 Jan 2016 23:05:25 +0100
MIME-Version: 1.0
In-Reply-To: <CAKQFV0EV9WvmzJaUaFEGODc-kxpt=rXJVYe5Md4oM5H00cBaeQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Hi,

Thanks for the bug report.

I've didn't catched it as my test setup uses old 32-bit netbook, 
but will try to reproduce it during weekend on mini-pcie to pcie converter.

Mateusz

On 07.01.2016 21:34, Gilbert Dion wrote:
> A few minutes after booting, the Wi-Fi disconnects and it fails to
> reconnect until I restart the machine.
> 
> [2] Full description of the problem/report
> I start the machine, a Samsung R580 laptop and the Wi-Fi connects.
> Then, after 5 or 10 minutes, while the Wi-Fi still appears to be
> connected, I can no longer load web pages. Then, a few minutes later,
> the Wi-Fi is disconnected. I tried some iconfig commands to try to
> reconnect it, but it does not work.
> It is crucial to notice that this happens only in 64 bit kernels. I
> tested 3.13 to the latest upstream. The machine running a 32 bit
> kernel stays connected forever.
> 
> [3] keywords
> 
> 
> [4] Linux version 4.4.0-040400rc8-generic (kernel@gloin) (gcc version
> 5.2.1 20151010 (Ubuntu 5.2.1-22ubuntu2) ) #201601051225 SMP Tue Jan 5
> 17:27:39 UTC 2016
> 
> [5] Output of Ooops... message
> Not applicable
> 
> [6] ] A small shell script or example program which triggers the problem
> Not applicable
> 
> [7.] Environment
> Description: Ubuntu 15.10
> Release: 15.10
> 
> [7.1] Software
> If some fields are empty or look unusual you may have an old version.
> Compare to the current minimal requirements in Documentation/Changes.
> 
> Linux Samsung-Laptop 4.4.0-040400rc8-generic #201601051225 SMP Tue Jan
> 5 17:27:39 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
> 
> GNU C 5.2.1
> GNU Make 4.0
> Binutils 2.25.1
> Util-linux 2.26.2
> Mount 2.26.2
> Module-init-tools 21
> E2fsprogs 1.42.12
> Pcmciautils 018
> PPP 2.4.6
> Linux C Library 2.21
> Dynamic linker (ldd) 2.21
> Linux C++ Library 6.0.21
> Procps 3.3.9
> Net-tools 1.60
> Kbd 1.15.5
> Console-tools 1.15.5
> Sh-utils 8.23
> Udev 225
> Wireless-tools 30
> Modules Loaded ahci arc4 autofs4 binfmt_misc bluetooth bnep btbcm
> btintel btrtl btusb cfg80211 coretemp drm drm_kms_helper fb_sys_fops
> fjes hid hid_generic i2c_algo_bit input_leds intel_powerclamp
> irqbypass joydev kvm kvm_intel lib80211 libahci lp lpc_ich mac80211
> mac_hid media michael_mic mxm_wmi nls_iso8859_1 nouveau parport
> parport_pc ppdev psmouse r8192e_pci rfcomm rtl8192se rtllib
> rtllib_crypt_ccmp rtllib_crypt_tkip rtl_pci rtlwifi samsung_laptop
> serio_raw shpchp sky2 snd snd_hda_codec snd_hda_codec_generic
> snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_core snd_hda_intel
> snd_hwdep snd_pcm snd_rawmidi snd_seq snd_seq_device snd_seq_midi
> snd_seq_midi_event snd_timer soundcore syscopyarea sysfillrect
> sysimgblt ttm uas usbhid usb_storage uvcvideo v4l2_common video
> videobuf2_core videobuf2_memops videobuf2_v4l2 videobuf2_vmalloc
> videodev wmi
> 
> [7.2] Processor information
> processor : 0
> vendor_id : GenuineIntel
> cpu family : 6
> model : 37
> model name : Intel(R) Core(TM) i3 CPU       M 330  @ 2.13GHz
> stepping : 2
> microcode : 0x9
> cpu MHz : 933.000
> cache size : 3072 KB
> physical id : 0
> siblings : 4
> core id : 0
> cpu cores : 2
> apicid : 0
> initial apicid : 0
> fpu : yes
> fpu_exception : yes
> cpuid level : 11
> wp : yes
> flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
> pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
> rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
> nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3
> cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm arat dtherm tpr_shadow
> vnmi flexpriority ept vpid
> bugs :
> bogomips : 4255.71
> clflush size : 64
> cache_alignment : 64
> address sizes : 36 bits physical, 48 bits virtual
> power management:
> 
> processor : 1
> vendor_id : GenuineIntel
> cpu family : 6
> model : 37
> model name : Intel(R) Core(TM) i3 CPU       M 330  @ 2.13GHz
> stepping : 2
> microcode : 0x9
> cpu MHz : 1066.000
> cache size : 3072 KB
> physical id : 0
> siblings : 4
> core id : 2
> cpu cores : 2
> apicid : 4
> initial apicid : 4
> fpu : yes
> fpu_exception : yes
> cpuid level : 11
> wp : yes
> flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
> pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
> rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
> nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3
> cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm arat dtherm tpr_shadow
> vnmi flexpriority ept vpid
> bugs :
> bogomips : 4255.71
> clflush size : 64
> cache_alignment : 64
> address sizes : 36 bits physical, 48 bits virtual
> power management:
> 
> processor : 2
> vendor_id : GenuineIntel
> cpu family : 6
> model : 37
> model name : Intel(R) Core(TM) i3 CPU       M 330  @ 2.13GHz
> stepping : 2
> microcode : 0x9
> cpu MHz : 933.000
> cache size : 3072 KB
> physical id : 0
> siblings : 4
> core id : 0
> cpu cores : 2
> apicid : 1
> initial apicid : 1
> fpu : yes
> fpu_exception : yes
> cpuid level : 11
> wp : yes
> flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
> pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
> rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
> nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3
> cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm arat dtherm tpr_shadow
> vnmi flexpriority ept vpid
> bugs :
> bogomips : 4255.71
> clflush size : 64
> cache_alignment : 64
> address sizes : 36 bits physical, 48 bits virtual
> power management:
> 
> processor : 3
> vendor_id : GenuineIntel
> cpu family : 6
> model : 37
> model name : Intel(R) Core(TM) i3 CPU       M 330  @ 2.13GHz
> stepping : 2
> microcode : 0x9
> cpu MHz : 933.000
> cache size : 3072 KB
> physical id : 0
> siblings : 4
> core id : 2
> cpu cores : 2
> apicid : 5
> initial apicid : 5
> fpu : yes
> fpu_exception : yes
> cpuid level : 11
> wp : yes
> flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
> pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
> rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
> nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3
> cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm arat dtherm tpr_shadow
> vnmi flexpriority ept vpid
> bugs :
> bogomips : 4255.71
> clflush size : 64
> cache_alignment : 64
> address sizes : 36 bits physical, 48 bits virtual
> power management:
> 
> [7.3] Module information
> nls_iso8859_1 16384 1 - Live 0x0000000000000000
> uas 24576 0 - Live 0x0000000000000000
> usb_storage 69632 2 uas, Live 0x0000000000000000
> rfcomm 69632 0 - Live 0x0000000000000000
> michael_mic 16384 8 - Live 0x0000000000000000
> arc4 16384 4 - Live 0x0000000000000000
> rtllib_crypt_tkip 20480 0 - Live 0x0000000000000000 (C)
> rtllib_crypt_ccmp 16384 0 - Live 0x0000000000000000 (C)
> bnep 20480 2 - Live 0x0000000000000000
> binfmt_misc 20480 1 - Live 0x0000000000000000
> snd_hda_codec_hdmi 53248 4 - Live 0x0000000000000000
> r8192e_pci 135168 0 - Live 0x0000000000000000 (C)
> snd_hda_codec_realtek 81920 1 - Live 0x0000000000000000
> snd_hda_codec_generic 77824 1 snd_hda_codec_realtek, Live 0x0000000000000000
> snd_hda_intel 36864 5 - Live 0x0000000000000000
> rtllib 155648 1 r8192e_pci, Live 0x0000000000000000 (C)
> lib80211 16384 3 rtllib_crypt_tkip,rtllib_crypt_ccmp,rtllib, Live
> 0x0000000000000000
> snd_hda_codec 135168 4
> snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,
> Live 0x0000000000000000
> uvcvideo 90112 0 - Live 0x0000000000000000
> snd_hda_core 65536 5
> snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_hda_codec,
> Live 0x0000000000000000
> snd_hwdep 16384 1 snd_hda_codec, Live 0x0000000000000000
> rtl8192se 65536 0 - Live 0x0000000000000000
> videobuf2_vmalloc 16384 1 uvcvideo, Live 0x0000000000000000
> videobuf2_memops 16384 1 videobuf2_vmalloc, Live 0x0000000000000000
> intel_powerclamp 16384 0 - Live 0x0000000000000000
> videobuf2_v4l2 28672 1 uvcvideo, Live 0x0000000000000000
> samsung_laptop 20480 0 - Live 0x0000000000000000
> videobuf2_core 36864 2 uvcvideo,videobuf2_v4l2, Live 0x0000000000000000
> v4l2_common 16384 1 videobuf2_v4l2, Live 0x0000000000000000
> coretemp 16384 0 - Live 0x0000000000000000
> rtl_pci 28672 1 rtl8192se, Live 0x0000000000000000
> videodev 176128 4 uvcvideo,videobuf2_v4l2,videobuf2_core,v4l2_common,
> Live 0x0000000000000000
> rtlwifi 77824 2 rtl8192se,rtl_pci, Live 0x0000000000000000
> snd_pcm 102400 4
> snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_hda_core, Live
> 0x0000000000000000
> snd_seq_midi 16384 0 - Live 0x0000000000000000
> media 24576 2 uvcvideo,videodev, Live 0x0000000000000000
> mac80211 724992 3 rtl8192se,rtl_pci,rtlwifi, Live 0x0000000000000000
> snd_seq_midi_event 16384 1 snd_seq_midi, Live 0x0000000000000000
> snd_rawmidi 32768 1 snd_seq_midi, Live 0x0000000000000000
> snd_seq 69632 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
> btusb 45056 0 - Live 0x0000000000000000
> btrtl 16384 1 btusb, Live 0x0000000000000000
> btbcm 16384 1 btusb, Live 0x0000000000000000
> btintel 16384 1 btusb, Live 0x0000000000000000
> snd_seq_device 16384 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0x0000000000000000
> cfg80211 557056 2 rtlwifi,mac80211, Live 0x0000000000000000
> kvm_intel 167936 0 - Live 0x0000000000000000
> joydev 20480 0 - Live 0x0000000000000000
> input_leds 16384 0 - Live 0x0000000000000000
> serio_raw 16384 0 - Live 0x0000000000000000
> bluetooth 520192 29 rfcomm,bnep,btusb,btrtl,btbcm,btintel, Live
> 0x0000000000000000
> snd_timer 32768 2 snd_pcm,snd_seq, Live 0x0000000000000000
> kvm 532480 1 kvm_intel, Live 0x0000000000000000
> irqbypass 16384 1 kvm, Live 0x0000000000000000
> snd 81920 21 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_seq_device,snd_timer,
> Live 0x0000000000000000
> soundcore 16384 1 snd, Live 0x0000000000000000
> lpc_ich 24576 0 - Live 0x0000000000000000
> shpchp 36864 0 - Live 0x0000000000000000
> mac_hid 16384 0 - Live 0x0000000000000000
> parport_pc 32768 0 - Live 0x0000000000000000
> ppdev 20480 0 - Live 0x0000000000000000
> lp 20480 0 - Live 0x0000000000000000
> parport 49152 3 parport_pc,ppdev,lp, Live 0x0000000000000000
> autofs4 40960 2 - Live 0x0000000000000000
> hid_generic 16384 0 - Live 0x0000000000000000
> usbhid 49152 0 - Live 0x0000000000000000
> hid 118784 2 hid_generic,usbhid, Live 0x0000000000000000
> nouveau 1495040 4 - Live 0x0000000000000000
> mxm_wmi 16384 1 nouveau, Live 0x0000000000000000
> wmi 20480 2 nouveau,mxm_wmi, Live 0x0000000000000000
> i2c_algo_bit 16384 1 nouveau, Live 0x0000000000000000
> ttm 94208 1 nouveau, Live 0x0000000000000000
> drm_kms_helper 135168 1 nouveau, Live 0x0000000000000000
> syscopyarea 16384 1 drm_kms_helper, Live 0x0000000000000000
> psmouse 126976 0 - Live 0x0000000000000000
> sysfillrect 16384 1 drm_kms_helper, Live 0x0000000000000000
> sysimgblt 16384 1 drm_kms_helper, Live 0x0000000000000000
> fb_sys_fops 16384 1 drm_kms_helper, Live 0x0000000000000000
> ahci 36864 3 - Live 0x0000000000000000
> drm 360448 7 nouveau,ttm,drm_kms_helper, Live 0x0000000000000000
> libahci 32768 1 ahci, Live 0x0000000000000000
> sky2 61440 0 - Live 0x0000000000000000
> fjes 28672 0 - Live 0x0000000000000000
> video 40960 2 samsung_laptop,nouveau, Live 0x0000000000000000
> 
> [7.4] Loaded driver and hardware information
> ioproc:
> 0000-0cf7 : PCI Bus 0000:00
>   0000-001f : dma1
>   0020-0021 : pic1
>   0040-0043 : timer0
>   0050-0053 : timer1
>   0060-0060 : keyboard
>   0062-0062 : PNP0C09:00
>     0062-0062 : EC data
>   0064-0064 : keyboard
>   0066-0066 : PNP0C09:00
>     0066-0066 : EC cmd
>   0070-0077 : rtc0
>   0080-008f : dma page reg
>   00a0-00a1 : pic2
>   00c0-00df : dma2
>   00f0-00ff : fpu
>     00f0-00f0 : PNP0C04:00
>   03c0-03df : vesafb
>   0400-0403 : ACPI PM1a_EVT_BLK
>   0404-0405 : ACPI PM1a_CNT_BLK
>   0408-040b : ACPI PM_TMR
>   0410-0415 : ACPI CPU throttle
>   0420-042f : ACPI GPE0_BLK
>   0430-0433 : iTCO_wdt.0.auto
>   0450-0450 : ACPI PM2_CNT_BLK
>   0460-047f : iTCO_wdt.0.auto
>   0500-050f : pnp 00:00
>   0600-0603 : pnp 00:00
>   0680-069f : pnp 00:00
>   06a0-06af : pnp 00:01
>   06b0-06ff : pnp 00:01
> 0cf8-0cff : PCI conf1
> 0d00-ffff : PCI Bus 0000:00
>   1180-11ff : pnp 00:00
>   164e-164f : pnp 00:00
>   1800-181f : 0000:00:1f.2
>     1800-181f : ahci
>   1820-1823 : 0000:00:1f.2
>     1820-1823 : ahci
>   1824-1827 : 0000:00:1f.2
>     1824-1827 : ahci
>   1828-182f : 0000:00:1f.2
>     1828-182f : ahci
>   1830-1837 : 0000:00:1f.2
>     1830-1837 : ahci
>   1840-185f : 0000:00:1f.3
>   2000-2fff : PCI Bus 0000:02
>     2000-207f : 0000:02:00.0
>   3000-3fff : PCI Bus 0000:03
>     3000-30ff : 0000:03:00.0
>   4000-4fff : PCI Bus 0000:05
>   5000-5fff : PCI Bus 0000:07
>     5000-50ff : 0000:07:00.0
>       5000-50ff : sky2
>   fe00-fe00 : pnp 00:00
> 
> iomem:
> 00000000-00000fff : reserved
> 00001000-0009c3ff : System RAM
> 0009c400-0009ffff : reserved
> 000a0000-000bffff : PCI Bus 0000:00
> 000c0000-000c7fff : Video ROM
> 000d0000-000d3fff : PCI Bus 0000:00
> 000d4000-000d7fff : PCI Bus 0000:00
> 000d8000-000dbfff : PCI Bus 0000:00
> 000dc000-000fffff : reserved
>   000f0000-000fffff : System ROM
> 00100000-d727bfff : System RAM
>   01000000-0180273f : Kernel code
>   01802740-01f3bd3f : Kernel data
>   020b2000-021f4fff : Kernel bss
> d727c000-d7281fff : reserved
> d7282000-d73ebfff : System RAM
> d73ec000-d740efff : reserved
> d740f000-d746efff : System RAM
> d746f000-d746ffff : reserved
> d7470000-d74f0fff : ACPI Non-volatile Storage
> d74f1000-d770efff : reserved
> d770f000-d7715fff : System RAM
> d7716000-d771efff : reserved
> d771f000-d777ffff : System RAM
> d7780000-d779efff : ACPI Non-volatile Storage
> d779f000-d77e1fff : System RAM
> d77e2000-d77fefff : ACPI Tables
> d77ff000-d77fffff : System RAM
> d7800000-d7ffffff : reserved
> d8000000-feafffff : PCI Bus 0000:00
>   d8000000-d8000fff : pnp 00:05
>   dc000000-ddefffff : PCI Bus 0000:02
>     dc000000-dcffffff : 0000:02:00.0
>     dd000000-dd07ffff : 0000:02:00.0
>     ddefc000-ddefffff : 0000:02:00.1
>       ddefc000-ddefffff : ICH HD audio
>   de000000-efffffff : PCI Bus 0000:02
>     de000000-dfffffff : 0000:02:00.0
>     e0000000-efffffff : 0000:02:00.0
>   f7fff000-fbffffff : reserved
>     f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]
>       f8000000-fbffffff : pnp 00:05
>   fc000000-fc1fffff : PCI Bus 0000:03
>   fc200000-fc3fffff : PCI Bus 0000:05
>   fc400000-fc5fffff : PCI Bus 0000:07
>   fc600000-fc6fffff : PCI Bus 0000:05
>   fc700000-fc7fffff : PCI Bus 0000:03
>     fc700000-fc703fff : 0000:03:00.0
>       fc700000-fc703fff : rtl819xE
>   fc800000-fc8fffff : PCI Bus 0000:07
>     fc800000-fc803fff : 0000:07:00.0
>       fc800000-fc803fff : sky2
>     fc820000-fc83ffff : 0000:07:00.0
>   fcb00000-fcb03fff : 0000:00:1b.0
>     fcb00000-fcb03fff : ICH HD audio
>   fcb04000-fcb04fff : reserved
>     fcb04000-fcb04fff : pnp 00:05
>   fcb05000-fcb057ff : 0000:00:1f.2
>     fcb05000-fcb057ff : ahci
>   fcb06000-fcb063ff : 0000:00:1a.0
>     fcb06000-fcb063ff : ehci_hcd
>   fcb06400-fcb067ff : 0000:00:1d.0
>     fcb06400-fcb067ff : ehci_hcd
>   fcb06800-fcb068ff : 0000:00:1f.3
> fec00000-fec0ffff : reserved
>   fec00000-fec003ff : IOAPIC 0
> fed00000-fed003ff : HPET 0
>   fed00000-fed003ff : reserved
>     fed00000-fed003ff : PNP0103:00
> fed10000-fed13fff : pnp 00:05
> fed18000-fed18fff : pnp 00:05
> fed19000-fed19fff : pnp 00:05
> fed1c000-fed8ffff : reserved
>   fed1c000-fed1ffff : pnp 00:05
>     fed1f410-fed1f414 : iTCO_wdt.0.auto
>   fed20000-fed3ffff : pnp 00:05
>   fed40000-fed44fff : pnp 00:05
>   fed45000-fed8ffff : pnp 00:05
> fee00000-fee00fff : Local APIC
>   fee00000-fee00fff : reserved
> ff000000-ffffffff : reserved
>   ff000000-ffffffff : INT0800:00
>     ff000000-ffffffff : pnp 00:05
> 100000000-11fffffff : System RAM
> 
> [7.5] PCI information
> 00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev 12)
> Subsystem: Samsung Electronics Co Ltd R730 Laptop
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> <TAbort+ <MAbort+ >SERR- <PERR- INTx-
> Latency: 0
> Capabilities: [e0] Vendor Specific Information: Len=0c <?>
> 
> 00:01.0 PCI bridge: Intel Corporation Core Processor PCI Express x16
> Root Port (rev 12) (prog-if 00 [Normal decode])
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin A routed to IRQ 24
> Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
> I/O behind bridge: 00002000-00002fff
> Memory behind bridge: dc000000-ddefffff
> Prefetchable memory behind bridge: 00000000de000000-00000000efffffff
> Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort+ <SERR- <PERR-
> BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
> PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> Capabilities: [88] Subsystem: Samsung Electronics Co Ltd Device c06a
> Capabilities: [80] Power Management version 3
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
> Address: 00000000  Data: 0000
> Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
> DevCap: MaxPayload 128 bytes, PhantFunc 0
> ExtTag- RBE+
> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> MaxPayload 128 bytes, MaxReadReq 128 bytes
> DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
> LnkCap: Port #2, Speed 2.5GT/s, Width x16, ASPM L0s L1, Exit Latency
> L0s <256ns, L1 <4us
> ClockPM- Surprise- LLActRep- BwNot+ ASPMOptComp-
> LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
> ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
> BWMgmt+ ABWMgmt-
> SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
> Slot #17, PowerLimit 75.000W; Interlock- NoCompl+
> SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
> Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
> SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
> Changed: MRL- PresDet+ LinkState-
> RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
> RootCap: CRSVisible-
> RootSta: PME ReqID 0000, PMEStatus- PMEPending-
> DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
> Not Supported ARIFwd-
> DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
> Disabled ARIFwd-
> LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
> Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
> Compliance De-emphasis: -6dB
> LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
> EqualizationPhase1-
> EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
> Capabilities: [100 v1] Virtual Channel
> Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
> Arb: Fixed- WRR32- WRR64- WRR128-
> Ctrl: ArbSelect=Fixed
> Status: InProgress-
> VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
> Arb: Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
> Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
> Status: NegoPending- InProgress-
> Kernel driver in use: pcieport
> 
> 00:1a.0 USB controller: Intel Corporation 5 Series/3400 Series Chipset
> USB2 Enhanced Host Controller (rev 06) (prog-if 20 [EHCI])
> Subsystem: Samsung Electronics Co Ltd R730 Laptop
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin A routed to IRQ 16
> Region 0: Memory at fcb06000 (32-bit, non-prefetchable) [size=1K]
> Capabilities: [50] Power Management version 2
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [58] Debug port: BAR=1 offset=00a0
> Capabilities: [98] PCI Advanced Features
> AFCap: TP+ FLR+
> AFCtrl: FLR-
> AFStatus: TP+
> Kernel driver in use: ehci-pci
> 
> 00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset
> High Definition Audio (rev 06)
> Subsystem: Samsung Electronics Co Ltd R730 Laptop
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin A routed to IRQ 28
> Region 0: Memory at fcb00000 (64-bit, non-prefetchable) [size=16K]
> Capabilities: [50] Power Management version 2
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
> Address: 00000000fee0f00c  Data: 41e1
> Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
> DevCap: MaxPayload 128 bytes, PhantFunc 0
> ExtTag- RBE-
> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> MaxPayload 128 bytes, MaxReadReq 128 bytes
> DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
> Capabilities: [100 v1] Virtual Channel
> Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
> Arb: Fixed- WRR32- WRR64- WRR128-
> Ctrl: ArbSelect=Fixed
> Status: InProgress-
> VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
> Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
> Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
> Status: NegoPending- InProgress-
> VC1: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
> Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
> Ctrl: Enable+ ID=1 ArbSelect=Fixed TC/VC=02
> Status: NegoPending- InProgress-
> Capabilities: [130 v1] Root Complex Link
> Desc: PortNumber=0f ComponentID=00 EltType=Config
> Link0: Desc: TargetPort=00 TargetComponent=00 AssocRCRB-
> LinkType=MemMapped LinkValid+
> Addr: 00000000fed1c000
> Kernel driver in use: snd_hda_intel
> 
> 00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
> Express Root Port 1 (rev 06) (prog-if 00 [Normal decode])
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort+
> <TAbort- <MAbort- >SERR+ <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin A routed to IRQ 16
> Bus: primary=00, secondary=03, subordinate=04, sec-latency=0
> I/O behind bridge: 00003000-00003fff
> Memory behind bridge: fc700000-fc7fffff
> Prefetchable memory behind bridge: 00000000fc000000-00000000fc1fffff
> Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort+ <MAbort+ <SERR- <PERR-
> BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
> DevCap: MaxPayload 128 bytes, PhantFunc 0
> ExtTag- RBE+
> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> MaxPayload 128 bytes, MaxReadReq 128 bytes
> DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq- AuxPwr+ TransPend-
> LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
> L0s <256ns, L1 <4us
> ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
> LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
> ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
> BWMgmt- ABWMgmt-
> SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
> Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
> SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
> Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
> SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
> Changed: MRL- PresDet- LinkState-
> RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
> RootCap: CRSVisible-
> RootSta: PME ReqID 0000, PMEStatus- PMEPending-
> DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not
> Supported ARIFwd-
> DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
> Disabled ARIFwd-
> LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
> Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
> Compliance De-emphasis: -6dB
> LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
> EqualizationPhase1-
> EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
> Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
> Address: 00000000  Data: 0000
> Capabilities: [90] Subsystem: Samsung Electronics Co Ltd R730 Laptop
> Capabilities: [a0] Power Management version 2
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Kernel driver in use: pcieport
> 
> 00:1c.2 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
> Express Root Port 3 (rev 06) (prog-if 00 [Normal decode])
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin C routed to IRQ 18
> Bus: primary=00, secondary=05, subordinate=06, sec-latency=0
> I/O behind bridge: 00004000-00004fff
> Memory behind bridge: fc600000-fc6fffff
> Prefetchable memory behind bridge: 00000000fc200000-00000000fc3fffff
> Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort+ <SERR- <PERR-
> BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
> DevCap: MaxPayload 128 bytes, PhantFunc 0
> ExtTag- RBE+
> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> MaxPayload 128 bytes, MaxReadReq 128 bytes
> DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
> LnkCap: Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
> L0s <1us, L1 <4us
> ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
> LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
> ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive-
> BWMgmt- ABWMgmt-
> SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
> Slot #2, PowerLimit 10.000W; Interlock- NoCompl+
> SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
> Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
> SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
> Changed: MRL- PresDet- LinkState-
> RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
> RootCap: CRSVisible-
> RootSta: PME ReqID 0000, PMEStatus- PMEPending-
> DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not
> Supported ARIFwd-
> DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
> Disabled ARIFwd-
> LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
> Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
> Compliance De-emphasis: -6dB
> LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
> EqualizationPhase1-
> EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
> Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
> Address: 00000000  Data: 0000
> Capabilities: [90] Subsystem: Samsung Electronics Co Ltd R730 Laptop
> Capabilities: [a0] Power Management version 2
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Kernel driver in use: pcieport
> 
> 00:1c.3 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
> Express Root Port 4 (rev 06) (prog-if 00 [Normal decode])
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin D routed to IRQ 19
> Bus: primary=00, secondary=07, subordinate=08, sec-latency=0
> I/O behind bridge: 00005000-00005fff
> Memory behind bridge: fc800000-fc8fffff
> Prefetchable memory behind bridge: 00000000fc400000-00000000fc5fffff
> Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort+ <SERR- <PERR-
> BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
> DevCap: MaxPayload 128 bytes, PhantFunc 0
> ExtTag- RBE+
> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> MaxPayload 128 bytes, MaxReadReq 128 bytes
> DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
> LnkCap: Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
> L0s <256ns, L1 <4us
> ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
> LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
> ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
> BWMgmt- ABWMgmt-
> SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
> Slot #3, PowerLimit 10.000W; Interlock- NoCompl+
> SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
> Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
> SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
> Changed: MRL- PresDet- LinkState+
> RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
> RootCap: CRSVisible-
> RootSta: PME ReqID 0000, PMEStatus- PMEPending-
> DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not
> Supported ARIFwd-
> DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
> Disabled ARIFwd-
> LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
> Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
> Compliance De-emphasis: -6dB
> LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
> EqualizationPhase1-
> EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
> Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
> Address: 00000000  Data: 0000
> Capabilities: [90] Subsystem: Samsung Electronics Co Ltd R730 Laptop
> Capabilities: [a0] Power Management version 2
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Kernel driver in use: pcieport
> 
> 00:1d.0 USB controller: Intel Corporation 5 Series/3400 Series Chipset
> USB2 Enhanced Host Controller (rev 06) (prog-if 20 [EHCI])
> Subsystem: Samsung Electronics Co Ltd R730 Laptop
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin A routed to IRQ 23
> Region 0: Memory at fcb06400 (32-bit, non-prefetchable) [size=1K]
> Capabilities: [50] Power Management version 2
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [58] Debug port: BAR=1 offset=00a0
> Capabilities: [98] PCI Advanced Features
> AFCap: TP+ FLR+
> AFCtrl: FLR-
> AFStatus: TP-
> Kernel driver in use: ehci-pci
> 
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a6)
> (prog-if 01 [Subtractive decode])
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Bus: primary=00, secondary=09, subordinate=09, sec-latency=0
> I/O behind bridge: 0000f000-00000fff
> Memory behind bridge: fff00000-000fffff
> Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
> Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort+ <SERR- <PERR-
> BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> Capabilities: [50] Subsystem: Samsung Electronics Co Ltd R730 Laptop
> 
> 00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC
> Interface Controller (rev 06)
> Subsystem: Samsung Electronics Co Ltd R730 Laptop
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Capabilities: [e0] Vendor Specific Information: Len=10 <?>
> Kernel driver in use: lpc_ich
> 
> 00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series
> Chipset 4 port SATA AHCI Controller (rev 06) (prog-if 01 [AHCI 1.0])
> Subsystem: Samsung Electronics Co Ltd R730 Laptop
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin B routed to IRQ 26
> Region 0: I/O ports at 1830 [size=8]
> Region 1: I/O ports at 1824 [size=4]
> Region 2: I/O ports at 1828 [size=8]
> Region 3: I/O ports at 1820 [size=4]
> Region 4: I/O ports at 1800 [size=32]
> Region 5: Memory at fcb05000 (32-bit, non-prefetchable) [size=2K]
> Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
> Address: fee0500c  Data: 41b1
> Capabilities: [70] Power Management version 3
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
> Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
> Capabilities: [b0] PCI Advanced Features
> AFCap: TP+ FLR+
> AFCtrl: FLR-
> AFStatus: TP-
> Kernel driver in use: ahci
> 
> 00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus
> Controller (rev 06)
> Subsystem: Samsung Electronics Co Ltd R730 Laptop
> Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Interrupt: pin C routed to IRQ 10
> Region 0: Memory at fcb06800 (64-bit, non-prefetchable) [size=256]
> Region 4: I/O ports at 1840 [size=32]
> 
> 02:00.0 VGA compatible controller: NVIDIA Corporation GT218M [GeForce
> 310M] (rev a2) (prog-if 00 [VGA controller])
> Subsystem: Samsung Electronics Co Ltd Device c06a
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin A routed to IRQ 27
> Region 0: Memory at dc000000 (32-bit, non-prefetchable) [size=16M]
> Region 1: Memory at e0000000 (64-bit, prefetchable) [size=256M]
> Region 3: Memory at de000000 (64-bit, prefetchable) [size=32M]
> Region 5: I/O ports at 2000 [size=128]
> [virtual] Expansion ROM at dd000000 [disabled] [size=512K]
> Capabilities: [60] Power Management version 3
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [68] MSI: Enable+ Count=1/1 Maskable- 64bit+
> Address: 00000000fee0f00c  Data: 41c1
> Capabilities: [78] Express (v2) Endpoint, MSI 00
> DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 <64us
> ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
> MaxPayload 128 bytes, MaxReadReq 512 bytes
> DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
> LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Exit Latency L0s
> <256ns, L1 <4us
> ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
> LnkCtl: ASPM L1 Enabled; RCB 128 bytes Disabled- CommClk+
> ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
> BWMgmt- ABWMgmt-
> DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, OBFF
> Not Supported
> DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
> LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
> Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
> Compliance De-emphasis: -6dB
> LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
> EqualizationPhase1-
> EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
> Capabilities: [b4] Vendor Specific Information: Len=14 <?>
> Capabilities: [100 v1] Virtual Channel
> Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
> Arb: Fixed- WRR32- WRR64- WRR128-
> Ctrl: ArbSelect=Fixed
> Status: InProgress-
> VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
> Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
> Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
> Status: NegoPending- InProgress-
> Capabilities: [128 v1] Power Budgeting <?>
> Capabilities: [600 v1] Vendor Specific Information: ID=0001 Rev=1 Len=024 <?>
> Kernel driver in use: nouveau
> 
> 02:00.1 Audio device: NVIDIA Corporation High Definition Audio
> Controller (rev a1)
> Subsystem: Samsung Electronics Co Ltd Device c06a
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin A routed to IRQ 16
> Region 0: Memory at ddefc000 (32-bit, non-prefetchable) [size=16K]
> Capabilities: [60] Power Management version 3
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
> Address: 0000000000000000  Data: 0000
> Capabilities: [78] Express (v2) Endpoint, MSI 00
> DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 <64us
> ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> MaxPayload 128 bytes, MaxReadReq 512 bytes
> DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
> LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Exit Latency L0s
> <256ns, L1 <1us
> ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
> LnkCtl: ASPM L0s L1 Enabled; RCB 128 bytes Disabled- CommClk+
> ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
> BWMgmt- ABWMgmt-
> DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, OBFF
> Not Supported
> DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
> LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
> EqualizationPhase1-
> EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
> Kernel driver in use: snd_hda_intel
> 
> 03:00.0 Network controller: Realtek Semiconductor Co., Ltd.
> RTL8192E/RTL8192SE Wireless LAN Controller (rev 01)
> Subsystem: Askey Computer Corp. Device 7160
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort+
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin A routed to IRQ 16
> Region 0: I/O ports at 3000 [size=256]
> Region 1: Memory at fc700000 (32-bit, non-prefetchable) [size=16K]
> Capabilities: [40] Power Management version 3
> Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
> Address: 0000000000000000  Data: 0000
> Capabilities: [70] Express (v1) Legacy Endpoint, MSI 00
> DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <128ns, L1 <2us
> ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
> MaxPayload 128 bytes, MaxReadReq 512 bytes
> DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
> LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
> L0s <512ns, L1 <64us
> ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
> LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
> ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
> BWMgmt- ABWMgmt-
> Capabilities: [100 v1] Advanced Error Reporting
> UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
> MalfTLP- ECRC- UnsupReq- ACSViol-
> UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
> MalfTLP- ECRC- UnsupReq- ACSViol-
> UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
> MalfTLP+ ECRC- UnsupReq- ACSViol-
> CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
> CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
> AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
> Capabilities: [140 v1] Virtual Channel
> Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
> Arb: Fixed- WRR32- WRR64- WRR128-
> Ctrl: ArbSelect=Fixed
> Status: InProgress-
> VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
> Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
> Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
> Status: NegoPending- InProgress-
> Capabilities: [160 v1] Device Serial Number 01-00-00-fe-ff-4c-e0-00
> Kernel driver in use: rtl819xE
> 
> 07:00.0 Ethernet controller: Marvell Technology Group Ltd. Yukon
> Optima 88E8059 [PCIe Gigabit Ethernet Controller with AVB] (rev 11)
> Subsystem: Samsung Electronics Co Ltd Device c06a
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin A routed to IRQ 25
> Region 0: Memory at fc800000 (64-bit, non-prefetchable) [size=16K]
> Region 2: I/O ports at 5000 [size=256]
> [virtual] Expansion ROM at fc820000 [disabled] [size=128K]
> Capabilities: [48] Power Management version 3
> Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [5c] MSI: Enable+ Count=1/1 Maskable- 64bit+
> Address: 00000000fee0100c  Data: 41a1
> Capabilities: [c0] Express (v2) Legacy Endpoint, MSI 00
> DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
> ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> MaxPayload 128 bytes, MaxReadReq 512 bytes
> DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
> LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
> L0s <1us, L1 <32us
> ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
> LnkCtl: ASPM L0s L1 Enabled; RCB 128 bytes Disabled- CommClk+
> ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
> LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
> BWMgmt- ABWMgmt-
> DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, OBFF
> Not Supported
> DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
> LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
> Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
> Compliance De-emphasis: -6dB
> LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
> EqualizationPhase1-
> EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
> Capabilities: [100 v1] Advanced Error Reporting
> UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
> MalfTLP- ECRC- UnsupReq- ACSViol-
> UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
> MalfTLP- ECRC- UnsupReq- ACSViol-
> UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
> MalfTLP+ ECRC- UnsupReq- ACSViol-
> CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
> CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
> AERCap: First Error Pointer: 1f, GenCap- CGenEn- ChkCap- ChkEn-
> Capabilities: [130 v1] Device Serial Number 35-66-40-ff-ff-54-24-00
> Kernel driver in use: sky2
> 
> 3f:00.0 Host bridge: Intel Corporation Core Processor QuickPath
> Architecture Generic Non-core Registers (rev 02)
> Subsystem: Intel Corporation Device 8086
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> 
> 3f:00.1 Host bridge: Intel Corporation Core Processor QuickPath
> Architecture System Address Decoder (rev 02)
> Subsystem: Intel Corporation Device 8086
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> 
> 3f:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 02)
> Subsystem: Intel Corporation Device 8086
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> 
> 3f:02.1 Host bridge: Intel Corporation 1st Generation Core i3/5/7
> Processor QPI Physical 0 (rev 02)
> Subsystem: Intel Corporation Device 8086
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> 
> 3f:02.2 Host bridge: Intel Corporation 1st Generation Core i3/5/7
> Processor Reserved (rev 02)
> Subsystem: Intel Corporation Device 8086
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> 
> 3f:02.3 Host bridge: Intel Corporation 1st Generation Core i3/5/7
> Processor Reserved (rev 02)
> Subsystem: Intel Corporation Device 8086
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> 
> gilbert@Samsung-Laptop:~$ sudo lspci -vvv
> 00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev 12)
> Subsystem: Samsung Electronics Co Ltd R730 Laptop
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> <TAbort+ <MAbort+ >SERR- <PERR- INTx-
> Latency: 0
> Capabilities: [e0] Vendor Specific Information: Len=0c <?>
> 
> 00:01.0 PCI bridge: Intel Corporation Core Processor PCI Express x16
> Root Port (rev 12) (prog-if 00 [Normal decode])
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin A routed to IRQ 24
> Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
> I/O behind bridge: 00002000-00002fff
> Memory behind bridge: dc000000-ddefffff
> Prefetchable memory behind bridge: 00000000de000000-00000000efffffff
> Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort+ <SERR- <PERR-
> BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
> PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> Capabilities: [88] Subsystem: Samsung Electronics Co Ltd Device c06a
> Capabilities: [80] Power Management version 3
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
> Address: 00000000  Data: 0000
> Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
> DevCap: MaxPayload 128 bytes, PhantFunc 0
> ExtTag- RBE+
> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> MaxPayload 128 bytes, MaxReadReq 128 bytes
> DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
> LnkCap: Port #2, Speed 2.5GT/s, Width x16, ASPM L0s L1, Exit Latency
> L0s <256ns, L1 <4us
> ClockPM- Surprise- LLActRep- BwNot+ ASPMOptComp-
> LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
> ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
> BWMgmt+ ABWMgmt-
> SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
> Slot #17, PowerLimit 75.000W; Interlock- NoCompl+
> SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
> Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
> SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
> Changed: MRL- PresDet+ LinkState-
> RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
> RootCap: CRSVisible-
> RootSta: PME ReqID 0000, PMEStatus- PMEPending-
> DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
> Not Supported ARIFwd-
> DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
> Disabled ARIFwd-
> LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
> Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
> Compliance De-emphasis: -6dB
> LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
> EqualizationPhase1-
> EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
> Capabilities: [100 v1] Virtual Channel
> Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
> Arb: Fixed- WRR32- WRR64- WRR128-
> Ctrl: ArbSelect=Fixed
> Status: InProgress-
> VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
> Arb: Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
> Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
> Status: NegoPending- InProgress-
> Kernel driver in use: pcieport
> 
> 00:1a.0 USB controller: Intel Corporation 5 Series/3400 Series Chipset
> USB2 Enhanced Host Controller (rev 06) (prog-if 20 [EHCI])
> Subsystem: Samsung Electronics Co Ltd R730 Laptop
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin A routed to IRQ 16
> Region 0: Memory at fcb06000 (32-bit, non-prefetchable) [size=1K]
> Capabilities: [50] Power Management version 2
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [58] Debug port: BAR=1 offset=00a0
> Capabilities: [98] PCI Advanced Features
> AFCap: TP+ FLR+
> AFCtrl: FLR-
> AFStatus: TP-
> Kernel driver in use: ehci-pci
> 
> 00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset
> High Definition Audio (rev 06)
> Subsystem: Samsung Electronics Co Ltd R730 Laptop
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin A routed to IRQ 28
> Region 0: Memory at fcb00000 (64-bit, non-prefetchable) [size=16K]
> Capabilities: [50] Power Management version 2
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
> Address: 00000000fee0f00c  Data: 41e1
> Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
> DevCap: MaxPayload 128 bytes, PhantFunc 0
> ExtTag- RBE-
> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> MaxPayload 128 bytes, MaxReadReq 128 bytes
> DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
> Capabilities: [100 v1] Virtual Channel
> Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
> Arb: Fixed- WRR32- WRR64- WRR128-
> Ctrl: ArbSelect=Fixed
> Status: InProgress-
> VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
> Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
> Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
> Status: NegoPending- InProgress-
> VC1: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
> Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
> Ctrl: Enable+ ID=1 ArbSelect=Fixed TC/VC=02
> Status: NegoPending- InProgress-
> Capabilities: [130 v1] Root Complex Link
> Desc: PortNumber=0f ComponentID=00 EltType=Config
> Link0: Desc: TargetPort=00 TargetComponent=00 AssocRCRB-
> LinkType=MemMapped LinkValid+
> Addr: 00000000fed1c000
> Kernel driver in use: snd_hda_intel
> 
> 00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
> Express Root Port 1 (rev 06) (prog-if 00 [Normal decode])
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort+
> <TAbort- <MAbort- >SERR+ <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin A routed to IRQ 16
> Bus: primary=00, secondary=03, subordinate=04, sec-latency=0
> I/O behind bridge: 00003000-00003fff
> Memory behind bridge: fc700000-fc7fffff
> Prefetchable memory behind bridge: 00000000fc000000-00000000fc1fffff
> Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort+ <MAbort+ <SERR- <PERR-
> BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
> DevCap: MaxPayload 128 bytes, PhantFunc 0
> ExtTag- RBE+
> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> MaxPayload 128 bytes, MaxReadReq 128 bytes
> DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq- AuxPwr+ TransPend-
> LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
> L0s <256ns, L1 <4us
> ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
> LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
> ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
> BWMgmt- ABWMgmt-
> SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
> Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
> SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
> Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
> SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
> Changed: MRL- PresDet- LinkState-
> RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
> RootCap: CRSVisible-
> RootSta: PME ReqID 0000, PMEStatus- PMEPending-
> DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not
> Supported ARIFwd-
> DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
> Disabled ARIFwd-
> LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
> Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
> Compliance De-emphasis: -6dB
> LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
> EqualizationPhase1-
> EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
> Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
> Address: 00000000  Data: 0000
> Capabilities: [90] Subsystem: Samsung Electronics Co Ltd R730 Laptop
> Capabilities: [a0] Power Management version 2
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Kernel driver in use: pcieport
> 
> 00:1c.2 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
> Express Root Port 3 (rev 06) (prog-if 00 [Normal decode])
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin C routed to IRQ 18
> Bus: primary=00, secondary=05, subordinate=06, sec-latency=0
> I/O behind bridge: 00004000-00004fff
> Memory behind bridge: fc600000-fc6fffff
> Prefetchable memory behind bridge: 00000000fc200000-00000000fc3fffff
> Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort+ <SERR- <PERR-
> BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
> DevCap: MaxPayload 128 bytes, PhantFunc 0
> ExtTag- RBE+
> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> MaxPayload 128 bytes, MaxReadReq 128 bytes
> DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
> LnkCap: Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
> L0s <1us, L1 <4us
> ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
> LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
> ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive-
> BWMgmt- ABWMgmt-
> SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
> Slot #2, PowerLimit 10.000W; Interlock- NoCompl+
> SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
> Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
> SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
> Changed: MRL- PresDet- LinkState-
> RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
> RootCap: CRSVisible-
> RootSta: PME ReqID 0000, PMEStatus- PMEPending-
> DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not
> Supported ARIFwd-
> DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
> Disabled ARIFwd-
> LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
> Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
> Compliance De-emphasis: -6dB
> LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
> EqualizationPhase1-
> EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
> Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
> Address: 00000000  Data: 0000
> Capabilities: [90] Subsystem: Samsung Electronics Co Ltd R730 Laptop
> Capabilities: [a0] Power Management version 2
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Kernel driver in use: pcieport
> 
> 00:1c.3 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
> Express Root Port 4 (rev 06) (prog-if 00 [Normal decode])
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin D routed to IRQ 19
> Bus: primary=00, secondary=07, subordinate=08, sec-latency=0
> I/O behind bridge: 00005000-00005fff
> Memory behind bridge: fc800000-fc8fffff
> Prefetchable memory behind bridge: 00000000fc400000-00000000fc5fffff
> Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort+ <SERR- <PERR-
> BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
> DevCap: MaxPayload 128 bytes, PhantFunc 0
> ExtTag- RBE+
> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> MaxPayload 128 bytes, MaxReadReq 128 bytes
> DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
> LnkCap: Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
> L0s <256ns, L1 <4us
> ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
> LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
> ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
> BWMgmt- ABWMgmt-
> SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
> Slot #3, PowerLimit 10.000W; Interlock- NoCompl+
> SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
> Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
> SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
> Changed: MRL- PresDet- LinkState+
> RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
> RootCap: CRSVisible-
> RootSta: PME ReqID 0000, PMEStatus- PMEPending-
> DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not
> Supported ARIFwd-
> DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
> Disabled ARIFwd-
> LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
> Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
> Compliance De-emphasis: -6dB
> LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
> EqualizationPhase1-
> EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
> Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
> Address: 00000000  Data: 0000
> Capabilities: [90] Subsystem: Samsung Electronics Co Ltd R730 Laptop
> Capabilities: [a0] Power Management version 2
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Kernel driver in use: pcieport
> 
> 00:1d.0 USB controller: Intel Corporation 5 Series/3400 Series Chipset
> USB2 Enhanced Host Controller (rev 06) (prog-if 20 [EHCI])
> Subsystem: Samsung Electronics Co Ltd R730 Laptop
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin A routed to IRQ 23
> Region 0: Memory at fcb06400 (32-bit, non-prefetchable) [size=1K]
> Capabilities: [50] Power Management version 2
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [58] Debug port: BAR=1 offset=00a0
> Capabilities: [98] PCI Advanced Features
> AFCap: TP+ FLR+
> AFCtrl: FLR-
> AFStatus: TP-
> Kernel driver in use: ehci-pci
> 
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a6)
> (prog-if 01 [Subtractive decode])
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Bus: primary=00, secondary=09, subordinate=09, sec-latency=0
> I/O behind bridge: 0000f000-00000fff
> Memory behind bridge: fff00000-000fffff
> Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
> Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort+ <SERR- <PERR-
> BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> Capabilities: [50] Subsystem: Samsung Electronics Co Ltd R730 Laptop
> 
> 00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC
> Interface Controller (rev 06)
> Subsystem: Samsung Electronics Co Ltd R730 Laptop
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Capabilities: [e0] Vendor Specific Information: Len=10 <?>
> Kernel driver in use: lpc_ich
> 
> 00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series
> Chipset 4 port SATA AHCI Controller (rev 06) (prog-if 01 [AHCI 1.0])
> Subsystem: Samsung Electronics Co Ltd R730 Laptop
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin B routed to IRQ 26
> Region 0: I/O ports at 1830 [size=8]
> Region 1: I/O ports at 1824 [size=4]
> Region 2: I/O ports at 1828 [size=8]
> Region 3: I/O ports at 1820 [size=4]
> Region 4: I/O ports at 1800 [size=32]
> Region 5: Memory at fcb05000 (32-bit, non-prefetchable) [size=2K]
> Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
> Address: fee0500c  Data: 41b1
> Capabilities: [70] Power Management version 3
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
> Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
> Capabilities: [b0] PCI Advanced Features
> AFCap: TP+ FLR+
> AFCtrl: FLR-
> AFStatus: TP-
> Kernel driver in use: ahci
> 
> 00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus
> Controller (rev 06)
> Subsystem: Samsung Electronics Co Ltd R730 Laptop
> Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Interrupt: pin C routed to IRQ 10
> Region 0: Memory at fcb06800 (64-bit, non-prefetchable) [size=256]
> Region 4: I/O ports at 1840 [size=32]
> 
> 02:00.0 VGA compatible controller: NVIDIA Corporation GT218M [GeForce
> 310M] (rev a2) (prog-if 00 [VGA controller])
> Subsystem: Samsung Electronics Co Ltd Device c06a
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin A routed to IRQ 27
> Region 0: Memory at dc000000 (32-bit, non-prefetchable) [size=16M]
> Region 1: Memory at e0000000 (64-bit, prefetchable) [size=256M]
> Region 3: Memory at de000000 (64-bit, prefetchable) [size=32M]
> Region 5: I/O ports at 2000 [size=128]
> [virtual] Expansion ROM at dd000000 [disabled] [size=512K]
> Capabilities: [60] Power Management version 3
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [68] MSI: Enable+ Count=1/1 Maskable- 64bit+
> Address: 00000000fee0f00c  Data: 41c1
> Capabilities: [78] Express (v2) Endpoint, MSI 00
> DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 <64us
> ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
> MaxPayload 128 bytes, MaxReadReq 512 bytes
> DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
> LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Exit Latency L0s
> <256ns, L1 <4us
> ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
> LnkCtl: ASPM L1 Enabled; RCB 128 bytes Disabled- CommClk+
> ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
> BWMgmt- ABWMgmt-
> DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, OBFF
> Not Supported
> DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
> LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
> Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
> Compliance De-emphasis: -6dB
> LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
> EqualizationPhase1-
> EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
> Capabilities: [b4] Vendor Specific Information: Len=14 <?>
> Capabilities: [100 v1] Virtual Channel
> Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
> Arb: Fixed- WRR32- WRR64- WRR128-
> Ctrl: ArbSelect=Fixed
> Status: InProgress-
> VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
> Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
> Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
> Status: NegoPending- InProgress-
> Capabilities: [128 v1] Power Budgeting <?>
> Capabilities: [600 v1] Vendor Specific Information: ID=0001 Rev=1 Len=024 <?>
> Kernel driver in use: nouveau
> 
> 02:00.1 Audio device: NVIDIA Corporation High Definition Audio
> Controller (rev a1)
> Subsystem: Samsung Electronics Co Ltd Device c06a
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin A routed to IRQ 16
> Region 0: Memory at ddefc000 (32-bit, non-prefetchable) [size=16K]
> Capabilities: [60] Power Management version 3
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
> Address: 0000000000000000  Data: 0000
> Capabilities: [78] Express (v2) Endpoint, MSI 00
> DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 <64us
> ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> MaxPayload 128 bytes, MaxReadReq 512 bytes
> DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
> LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Exit Latency L0s
> <256ns, L1 <1us
> ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
> LnkCtl: ASPM L0s L1 Enabled; RCB 128 bytes Disabled- CommClk+
> ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
> BWMgmt- ABWMgmt-
> DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, OBFF
> Not Supported
> DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
> LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
> EqualizationPhase1-
> EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
> Kernel driver in use: snd_hda_intel
> 
> 03:00.0 Network controller: Realtek Semiconductor Co., Ltd.
> RTL8192E/RTL8192SE Wireless LAN Controller (rev 01)
> Subsystem: Askey Computer Corp. Device 7160
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort+
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin A routed to IRQ 16
> Region 0: I/O ports at 3000 [size=256]
> Region 1: Memory at fc700000 (32-bit, non-prefetchable) [size=16K]
> Capabilities: [40] Power Management version 3
> Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
> Address: 0000000000000000  Data: 0000
> Capabilities: [70] Express (v1) Legacy Endpoint, MSI 00
> DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <128ns, L1 <2us
> ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
> MaxPayload 128 bytes, MaxReadReq 512 bytes
> DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
> LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
> L0s <512ns, L1 <64us
> ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
> LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
> ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
> BWMgmt- ABWMgmt-
> Capabilities: [100 v1] Advanced Error Reporting
> UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
> MalfTLP- ECRC- UnsupReq- ACSViol-
> UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
> MalfTLP- ECRC- UnsupReq- ACSViol-
> UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
> MalfTLP+ ECRC- UnsupReq- ACSViol-
> CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
> CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
> AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
> Capabilities: [140 v1] Virtual Channel
> Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
> Arb: Fixed- WRR32- WRR64- WRR128-
> Ctrl: ArbSelect=Fixed
> Status: InProgress-
> VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
> Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
> Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
> Status: NegoPending- InProgress-
> Capabilities: [160 v1] Device Serial Number 01-00-00-fe-ff-4c-e0-00
> Kernel driver in use: rtl819xE
> 
> 07:00.0 Ethernet controller: Marvell Technology Group Ltd. Yukon
> Optima 88E8059 [PCIe Gigabit Ethernet Controller with AVB] (rev 11)
> Subsystem: Samsung Electronics Co Ltd Device c06a
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin A routed to IRQ 25
> Region 0: Memory at fc800000 (64-bit, non-prefetchable) [size=16K]
> Region 2: I/O ports at 5000 [size=256]
> [virtual] Expansion ROM at fc820000 [disabled] [size=128K]
> Capabilities: [48] Power Management version 3
> Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [5c] MSI: Enable+ Count=1/1 Maskable- 64bit+
> Address: 00000000fee0100c  Data: 41a1
> Capabilities: [c0] Express (v2) Legacy Endpoint, MSI 00
> DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
> ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> MaxPayload 128 bytes, MaxReadReq 512 bytes
> DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
> LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
> L0s <1us, L1 <32us
> ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
> LnkCtl: ASPM L0s L1 Enabled; RCB 128 bytes Disabled- CommClk+
> ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
> LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
> BWMgmt- ABWMgmt-
> DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, OBFF
> Not Supported
> DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
> LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
> Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
> Compliance De-emphasis: -6dB
> LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
> EqualizationPhase1-
> EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
> Capabilities: [100 v1] Advanced Error Reporting
> UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
> MalfTLP- ECRC- UnsupReq- ACSViol-
> UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
> MalfTLP- ECRC- UnsupReq- ACSViol-
> UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
> MalfTLP+ ECRC- UnsupReq- ACSViol-
> CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
> CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
> AERCap: First Error Pointer: 1f, GenCap- CGenEn- ChkCap- ChkEn-
> Capabilities: [130 v1] Device Serial Number 35-66-40-ff-ff-54-24-00
> Kernel driver in use: sky2
> 
> 3f:00.0 Host bridge: Intel Corporation Core Processor QuickPath
> Architecture Generic Non-core Registers (rev 02)
> Subsystem: Intel Corporation Device 8086
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> 
> 3f:00.1 Host bridge: Intel Corporation Core Processor QuickPath
> Architecture System Address Decoder (rev 02)
> Subsystem: Intel Corporation Device 8086
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> 
> 3f:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 02)
> Subsystem: Intel Corporation Device 8086
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> 
> 3f:02.1 Host bridge: Intel Corporation 1st Generation Core i3/5/7
> Processor QPI Physical 0 (rev 02)
> Subsystem: Intel Corporation Device 8086
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> 
> 3f:02.2 Host bridge: Intel Corporation 1st Generation Core i3/5/7
> Processor Reserved (rev 02)
> Subsystem: Intel Corporation Device 8086
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> 
> 3f:02.3 Host bridge: Intel Corporation 1st Generation Core i3/5/7
> Processor Reserved (rev 02)
> Subsystem: Intel Corporation Device 8086
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> 
> 
> [7.6] SCSI information
> Attached devices:
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>   Vendor: ATA      Model: ST9500325AS      Rev: SDM1
>   Type:   Direct-Access                    ANSI  SCSI revision: 05
> Host: scsi1 Channel: 00 Id: 00 Lun: 00
>   Vendor: TSSTcorp Model: CDDVDW TS-L633C  Rev: SC00
>   Type:   CD-ROM                           ANSI  SCSI revision: 05
> Host: scsi5 Channel: 00 Id: 00 Lun: 00
>   Vendor: Generic  Model: Flash Disk       Rev: 8.07
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> 
> [7.7] Other information
> ls /proc:
> 
> 1     16    1762  204   287   358   628  784        consoles     net
> 10    160   1764  205   29    3586  63   79         cpuinfo      pagetypeinfo
> 108   161   1766  2094  2969  359   636  799        crypto       partitions
> 109   1624  1768  21    2982  36    637  8          devices      sched_debug
> 11    1626  1769  2102  2984  360   64   80         diskstats    schedstat
> 12    1627  1770  2141  3     361   641  800        dma          scsi
> 1296  1639  1781  2147  30    3629  647  801        driver       self
> 13    1650  18    2154  3024  3710  65   802        execdomains  slabinfo
> 1355  1652  1823  2176  3029  3721  66   82         fb           softirqs
> 1389  1656  1845  2188  3061  38    67   83         filesystems  stat
> 1391  1658  1853  2189  31    3840  68   835        fs           swaps
> 1404  1659  1863  2197  310   3849  682  84         interrupts   sys
> 1407  1665  1865  2199  3124  3851  7    844        iomem        sysrq-trigger
> 1439  1666  1878  22    3154  3857  70   849        ioports      sysvipc
> 1482  1668  1950  2233  32    3899  703  85         irq          thread-self
> 1486  1680  1951  2235  33    39    709  86         kallsyms     timer_list
> 1492  1685  1955  2244  3307  40    71   87         kcore        timer_stats
> 1494  1698  1956  2257  3350  404   713  875        keys         tty
> 15    1699  1958  23    3351  422   716  88         key-users    uptime
> 150   17    1961  2363  3352  423   718  89         kmsg         version
> 152   170   1977  237   3355  430   72   9          kpagecgroup  vmallocinfo
> 153   1701  1986  24    3398  44    722  90         kpagecount   vmstat
> 154   171   1999  2463  34    449   729  903        kpageflags   zoneinfo
> 155   1711  2     247   343   45    73   924        loadavg
> 156   1712  20    2473  344   450   733  94         locks
> 157   1729  2004  25    35    46    74   acpi       mdstat
> 1572  173   2009  2551  3502  47    744  asound     meminfo
> 158   1732  201   26    3512  5     75   buddyinfo  misc
> 1580  1739  2018  265   3540  512   76   bus        modules
> 159   1760  202   27    3547  6     77   cgroups    mounts
> 1592  1761  2029  28    3548  62    78   cmdline    mtrr
> 
> [x]
> Link to my lauchpad bug report
> 
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1525270
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWjuEhAAoJELvtohmVtQzBXzYH/1BJY2KCxNwa/TEj9TRsZ0rv
szxQAvzWxA+YaqTWzvoBq7PacswDte3H5g10eYtpcO5vOUshnMysbKIzVaJZPfaa
Auf1/TS0CKL4XSnP5Eg99x69xaWLZEvVHEcam7EfHh8d6BJroAuin1qnqSWbeEdA
8HVo438+V2ZccJqxiphCEpiYdT9A9dCzxBUhzq7Q+RZ49XJL7TStkxRJnvWFzEqv
fqoN71qrBJKsqiQrYwPZkzPgwJ2TkoEFJBlWtLqRjnHzhg92TVPBftLXcT0nMo6E
pxq7niI4nzI8JLta+sN2UDRPi6urPk+GB5M2ZY9X752bA4DRKxey3Be7tpASRiQ=
=DxOM
-----END PGP SIGNATURE-----
