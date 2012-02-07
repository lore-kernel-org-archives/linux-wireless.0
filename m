Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bmail.ru ([194.67.1.203]:62085 "EHLO sovam.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab2BGQ6t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 11:58:49 -0500
From: dganic@bmail.ru
Subject: Re: drivers realtek rtl8191su [rtl8712 ]
To: ali@internetdog.org
Cc: wlanfae@realtek.com, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Date: Tue, 07 Feb 2012 19:53:44 +0300
Message-ID: <web-10842365@mail-be03.sovam.com> (sfid-20120207_175903_420113_F6EC4CAB)
In-Reply-To: <20120207020837.GA29465@internetdog.org>
References: <web-16212948@mail-be01.sovam.com>
 <20120207020837.GA29465@internetdog.org>
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8;format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you Ali for your reply email. One can wonder why you continue to 
develop this driver, and still the most interesting place: (Maybe you 
can help me by passing this information in any other developer in a 
position to write the full realization of this driver? The average 
user like me, they are unlikely to be listen, and you as the developer 
will have to listen. Perhaps you have the opportunity to publish this 
information in the Linux kernel mailing list or linuxdrivers.org? or 
have any contacts who can I turn? itself does not implement realtek 
drivers for their devices under Linux?

with respect, Alexander Anishchenko

On Tue, 7 Feb 2012 10:08:37 +0800
  Ali Bahar <ali@internetdog.org> wrote:
  Hi dganic,
  
  
  On Mon, Feb 06, 2012 at 09:17:33PM +0300, dganic@bmail.ru wrote:
> Subject: drivers realtek rtl8191su [rtl8712 ]
> 
> Good day, 
>https://github.com/torvalds/linux/blob/master/drivers/staging/rtl8712/TODO,
> there indicated that in a short time you make a "switch to use
> MAC80211" and as what about "nl80211" I want to do from wi fi card,
> access point, by means of hostapd, but in this implementation, the
> driver who is at the core, this is impossible, in which release of
> the kernel will be implemented this functionality the driver?
  
  Yes, I was the one who had volunteered to try the implementation.
But,
  unfortunately, I can't work on this driver anymore; I stopped in
  September. So, as far as I know, this is not going to happen anytime
  soon.
  
  regards,
  ali
  
  
> 
> 
> A little more information:
> 
> [htpc@dga-htpc ~]$ lsmod
> Module Size Used by
> appletalk 26298 0
> ipx 20395 0
> p8022 1171 1 ipx
> psnap 1973 2 appletalk,ipx
> llc 3761 2 p8022,psnap
> p8023 1068 1 ipx
> ipv6 290983 16
> nvidia 11695959 40
> snd_hda_codec_hdmi 22092 4
> iTCO_wdt 12717 0
> snd_hda_intel 22122 1
> r8712u 169296 0
> iTCO_vendor_support 1929 1 iTCO_wdt
> snd_hda_codec 77927 2 snd_hda_codec_hdmi,snd_hda_
> intel
> joydev 9895 1
> usbhid 35256 0
> hid 81635 1 usbhid
> pcspkr 1819 0
> evdev 9530 4
> snd_hwdep 6325 1 snd_hda_codec
> i2c_i801 8187 0
> psmouse 55192 0
> intel_agp 10904 0
> intel_gtt 14423 1 intel_agp
> snd_pcm 73952 4 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec
> r8169 42643 0
> mii 3995 1 r8169
> serio_raw 4294 0
> processor 24256 0
> snd_timer 19416 1 snd_pcm
> i2c_core 20133 2 nvidia,i2c_i801
> snd 57818 7 
>snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
> soundcore 6146 1 snd
> snd_page_alloc 7121 2 snd_hda_intel,snd_pcm
> button 4470 0
> ext4 370462 1
> mbcache 5817 1 ext4
> jbd2 71074 1 ext4
> crc16 1297 1 ext4
> sd_mod 28307 2
> uhci_hcd 23084 0
> ahci 21217 1
> libahci 18885 1 ahci
> libata 173297 2 ahci,libahci
> scsi_mod 131546 2 sd_mod,libata
> ehci_hcd 39543 0
> usbcore 142576 5 r8712u,usbhid,uhci_hcd,ehci_hcd
> 
> /etc/hostapd/hostapd.conf:
> 
> interface=wlan0
> driver=nl80211
> logger_syslog=-1
> logger_syslog_level=2
> logger_stdout=-1
> logger_stdout_level=2
> dump_file=/tmp/hostapd.dump
> #ctrl_interface=/var/run/hostapd
> #ctrl_interface_group=0
> ssid=dganic-htpc
> country_code=RU
> hw_mode=g
> channel=11
> beacon_int=100
> dtim_period=2
> max_num_sta=255
> rts_threshold=2347
> fragm_threshold=2346
> macaddr_acl=0
> wpa=2
> wpa_passphrase=50177011aa
> wpa_pairwise=TKIP CCMP
> rsn_pairwise=CCMP
> 
> [htpc@dga-htpc ~]$ sudo hostapd -dd /etc/hostapd/hostapd.conf
> Configuration file: /etc/hostapd/hostapd.conf
> nl80211: 'nl80211' generic netlink not found
> nl80211 driver initialization failed.
> 
> Thank you in advance for your reply, I hope for your support, sorry
> for the very poor English.
