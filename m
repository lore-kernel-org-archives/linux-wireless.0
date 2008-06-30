Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:32037 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbYF3PsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 11:48:12 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1215302waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2008 08:48:12 -0700 (PDT)
Message-ID: <1ba2fa240806300848v4fd92b72n565fc113e1c122b8@mail.gmail.com> (sfid-20080630_174816_156133_1564AED3)
Date: Mon, 30 Jun 2008 18:48:12 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Linux Wireless" <linux-wireless@vger.kernel.org>
Subject: IBSS lockdep failure
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anyone have seen this one?
Thanks
Tomas

wlan0: beacon TSF higher than local TSF - IBSS merge with BSSID
XX:XX:XX:XX:XX:XX
phy0: Adding new IBSS station XX:XX:XX:XX:XX:XX (dev=wlan0)
phy0: Allocated STA XX:XX:XX:XX:XX:XX
phy0: Inserted STA XX:XX:XX:XX:XX:XX
wlan0: RX ProbeReq SA=XX:XX:XX:XX:XX:XX DA=ff:ff:ff:ff:ff:ff
BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
wlan0: Sending ProbeResp to XX:XX:XX:XX:XX:XX
RX beacon SA=XX:XX:XX:XX:XX:XX BSSID=XX:XX:XX:XX:XX:XX TSF=0x14dc0bd5c
BCN=0x14dc0be19 diff=-189 @1071562
wlan0: beacon TSF higher than local TSF - IBSS merge with BSSID
XX:XX:XX:XX:XX:XX
phy0: Removed STA XX:XX:XX:XX:XX:XX
phy0: Removed STA XX:XX:XX:XX:XX:XX
phy0: Removed STA XX:XX:XX:XX:XX:XX
phy0: Removed STA XX:XX:XX:XX:XX:XX
phy0: Removed STA XX:XX:XX:XX:XX:XX
phy0: Removed STA XX:XX:XX:XX:XX:XX
phy0: Removed STA XX:XX:XX:XX:XX:XX
phy0: Removed STA XX:XX:XX:XX:XX:XX
phy0: Removed STA XX:XX:XX:XX:XX:XX
phy0: Removed STA XX:XX:XX:XX:XX:XX
phy0: Removed STA XX:XX:XX:XX:XX:XX
phy0: Removed STA XX:XX:XX:XX:XX:XX
phy0: Destroyed STA XX:XX:XX:XX:XX:XX
phy0: Destroyed STA XX:XX:XX:XX:XX:XX
phy0: Destroyed STA XX:XX:XX:XX:XX:XX
phy0: Destroyed STA XX:XX:XX:XX:XX:XX
phy0: Destroyed STA XX:XX:XX:XX:XX:XX
phy0: Destroyed STA XX:XX:XX:XX:XX:XX
phy0: Destroyed STA XX:XX:XX:XX:XX:XX
phy0: Destroyed STA XX:XX:XX:XX:XX:XX
phy0: Destroyed STA XX:XX:XX:XX:XX:XX
phy0: Destroyed STA XX:XX:XX:XX:XX:XX
phy0: Destroyed STA XX:XX:XX:XX:XX:XX
phy0: Destroyed STA XX:XX:XX:XX:XX:XX
BUG: unable to handle kernel NULL pointer dereference at 00000004
IP: [<c043d4eb>] zap_class+0x22/0x64
*pde = 00000000
Oops: 0002 [#1] SMP
Modules linked in: mac80211 cfg80211 netconsole i915 drm autofs4 hidp
rfcomm l2cap sunrpc cpufreq_ondemand acpi_cpufreq dm_multipath sbs
sbshc ipv6 snd_hda_intel snd_seq_dummy arc4 snd_seq_oss ecb
snd_seq_midi_event snd_seq crypto_blkcipher snd_seq_device hci_usb
snd_pcm_oss snd_mixer_oss snd_pcm video snd_timer snd_page_alloc
bluetooth ac battery button iTCO_wdt snd_hwdep output sr_mod serio_raw
iTCO_vendor_support snd soundcore tg3 joydev pcspkr cdrom sg
dm_snapshot dm_zero ata_piix ohci_hcdESI: 0003c120 EDI: 00001e09 EBP:
0001f024 ESP: ed1bbf2c
c04403d8 ed1bb000 ed1bbfb8 do_syscall_trace+0x121/0x165
c3 39 8b 42 00 81 console [netcon0] enabled
netconsole: network logging started
