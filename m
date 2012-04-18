Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:16462 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab2DRTKO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 15:10:14 -0400
Date: Wed, 18 Apr 2012 21:10:11 +0200 (CEST)
From: =?UTF-8?Q?C=C3=A9dric_MARTIN?= <policenauts@wanadoo.fr>
Reply-To: =?UTF-8?Q?C=C3=A9dric_MARTIN?= <policenauts@wanadoo.fr>
To: linux-wireless@vger.kernel.org
Message-ID: <1885003111.25113.1334776211682.JavaMail.www@wwinf1d16> (sfid-20120418_211021_290923_6543F4EB)
Subject: tr: Re: tr: Re: info about D-link USB wlan with realtek RTL8192SU
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


apologies for previous html email.




> Message du 18/04/12 20:58
> De : "Cédric MARTIN" 
> A : "Larry Finger" 
> Copie à : linux-wireless@vger.kernel.org
> Objet : Re: tr: Re: info about D-link USB wlan with realtek RTL8192SU
> 
>
> Thanks for your help, I still trying it works.

> for info the last release I did try with no functional device was with kernel 3.2.14

>  

> http://openelec.tv/forum/88-wlan/30485-dwa-131-issue#31420

>  

> Best regards.



> Message du 18/04/12 20:18
> De : "Larry Finger" 
> A : "Cédric MARTIN" 
> Copie à : linux-wireless@vger.kernel.org
> Objet : Re: tr: Re: info about D-link USB wlan with realtek RTL8192SU
> 
> On 04/13/2012 04:50 PM, Cédric MARTIN wrote:
> >>> I'm sorry ton contact you, because I think you have hundred of email like this,
> >>> but I think you're the right person to give me some advices.
> >>> I'm beginner in Gnu/linux world as User.
> >>>
> >>> I use a PC with openelec distri (home theater distribution, *OpenELEC 1.0
> >>> (stable)* - 1.0.2
> >>> Intel x86_64
> >>> (90 MB)) and I have problem with my wlan.
> >>> I have aleatory connection.
> >>>
> >>> a lsusb give me this:
> >>>
> >>> "...
> >>> Bus 002 Device 006: ID 07d1:3303 D-Link System DWA-131 802.11n Wireless N Nano
> >>> Adapter(rev.A1) [Realtek RTL8192SU]"
> >>>
> >>> It seem ok.
> >>>
> >>> a lsmod give me this:
> >>>
> >>> "
> >>> root ~ # lsmod
> >>> Module Size Used by
> >>> snd_hda_codec_hdmi 22001 1
> >>> snd_hda_codec_realtek 274159 1
> >>> snd_hda_intel 21531 3
> >>> snd_hda_codec 73098 3 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel
> >>> snd_hwdep 5108 1 snd_hda_codec
> >>> snd_pcm 59142 4 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec
> >>> snd_timer 17314 2 snd_pcm
> >>> snd 44263 11
> >>> snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
> >>> ftdi_sio 32206 1
> >>> r8712u 156717 0
> >>> snd_page_alloc 6753 2 snd_hda_intel,snd_pcm
> >>> usbserial 28127 3 ftdi_sio
> >>> coretemp 5979 0
> >>> "
> >>> a dmesg give me this:
> >>>
> >>> "
> >>> ...[ 5.745226] r8712u: module is from the staging directory, the quality is
> >>> unknown, you have been warned.
> >>> [ 5.745750] r8712u: DriverVersion: v7_0.20100831
> >>> [ 5.745761] r8712u: register rtl8712_netdev_ops to netdev_ops
> >>> [ 5.745763] r8712u: USB_SPEED_HIGH with 4 endpoints
> >>> [ 5.746286] r8712u: Boot from EFUSE: Autoload OK
> >>> [ 5.746449] USB Serial support registered for FTDI USB Serial Device
> >>> [ 5.746490] ftdi_sio 2-1.4.1:1.0: FTDI USB Serial Device converter detected
> >>> [ 5.746532] usb 2-1.4.1: Detected FT232RL
> >>> [ 5.746535] usb 2-1.4.1: Number of endpoints 2
> >>> [ 5.746536] usb 2-1.4.1: Endpoint 1 MaxPacketSize 64
> >>> [ 5.746538] usb 2-1.4.1: Endpoint 2 MaxPacketSize 64
> >>> [ 5.746539] usb 2-1.4.1: Setting MaxPacketSize 64
> >>> [ 5.747002] usb 2-1.4.1: FTDI USB Serial Device converter now attached to ttyUSB0
> >>> [ 5.747021] usbcore: registered new interface driver ftdi_sio
> >>> [ 5.747023] ftdi_sio: v1.6.0:USB FTDI Serial Converters Driver
> >>> [ 6.104736] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> >>> [ 6.104787] snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
> >>> [ 6.104831] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
> >>> [ 6.327161] r8712u: CustomerID = 0x0000
> >>> [ 6.327164] r8712u: MAC Address from efuse = fc:75:16:6d:f3:b1
> >>> [ 6.327420] usbcore: registered new interface driver r8712u
> >>> ...
> >>> [ 22.465242] r8712u: Loading firmware from "rtlwifi/rtl8712u.bin"
> >>> [ 23.150858] r8712u: 1 RCR=0x153f00e
> >>> [ 23.151818] r8712u: 2 RCR=0x553f00e
> >>> [ 23.260743] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> 
> I have no knowledge of the openELEC distro, or more precisely, what kernel they 
> are using, but r8712u works very well with current kernels such as 3.4-rc3. 
> There were some changes added between 3.1 and 3.2 that caused problems with some 
> distros - Arch and Debian were two of them. If yours is Debian based, then it is 
> probably affected. Those problems were fixed and have been added to the latest 
> releases of stable kernels.
> 
> In short, you probably need to upgrade your kernel.
> 
> Larry
>
