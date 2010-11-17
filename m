Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43614 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933306Ab0KQA4S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 19:56:18 -0500
Received: by qwh6 with SMTP id 6so1174618qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Nov 2010 16:56:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinbpsg-n6MgY07-694ogfXbM8BdAY36hGtMS6AF@mail.gmail.com>
References: <AANLkTinbpsg-n6MgY07-694ogfXbM8BdAY36hGtMS6AF@mail.gmail.com>
Date: Wed, 17 Nov 2010 11:56:17 +1100
Message-ID: <AANLkTik2z7n7w0+oqa_-JhS5z86bOFzrjzLX=2Q1V20b@mail.gmail.com>
Subject: Issue with hostapd
From: linux newbie <linux.newbie79@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

We are running linux_2.6.35 on our pxa255 based embedded device.

recently I am trying to bring up hostapd but so far not successful and
I need your expert advice. hostapd(0.6.10) and libnl(2.0) are the
versions I am using.

hostapd.conf is as follows:
interface=eth1
driver=nl80211
ssid=Testnet
channel=8
hw_mode=g
auth_algs=1
wpa=3
wpa_passphrase=1234567890
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP CCMP
rsn_pairwise=CCMP

I tried with 2 network interfaces (not simultaneously) and following
is the error messages.

1. cisco 350 pcmcia wireless card -  on running ./hostapd -dd
hostapd.conf it gives failed to create interface mon.eth1.
2. realtek 8187 usb wireless card - ELOOP: remaining socket: sock=5
eloop_data=0x4c710 user_data=(nil) handler=0x2fb34

I was using wpa_supplicant to configure the interface in two cards and
it is working fine.

Please let me know, how to debug this issue further.

Thanks
