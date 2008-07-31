Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web52406.mail.re2.yahoo.com ([206.190.48.169]:36828 "HELO
	web52406.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751177AbYGaE3H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 00:29:07 -0400
Date: Wed, 30 Jul 2008 21:29:04 -0700 (PDT)
From: Richard Schneiderman <rschneiderman@yahoo.com>
Reply-To: rschneiderman@yahoo.com
Subject: cannot connect to wireless router
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <892482.44637.qm@web52406.mail.re2.yahoo.com> (sfid-20080731_062911_242237_2DBA1FE9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All,
I can now see my wireless connection using iwlist but when I use iwconfig,  the acceess point keeps saying not associated. It has never worked

I have the 2.6.26 kernel loaded on suse with the lastest b43 firmware.
This is a broadcom 4306 rev. 3.
  
This is from iwconfig
wlan0     IEEE 802.11  ESSID:"wireless_g"
          Mode:Managed  Frequency:2.437 GHz  Access Point: Not-Associated
          Tx-Power=27 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Encryption key:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

dmesg | grep b43

b43-phy0: Broadcom 4306 WLAN found
input: b43-phy0 as /devices/virtual/input/input5
firmware: requesting b43/ucode5.fw
firmware: requesting b43/pcm5.fw
firmware: requesting b43/b0g0initvals5.fw
firmware: requesting b43/b0g0bsinitvals5.fw
b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
Registered led device: b43-phy0::tx
Registered led device: b43-phy0::rx
Registered led device: b43-phy0::radio

This statement says I might should be using b43legacy for my card.
4306 and 4309 cards with a MAC core revision of 4 or less should also use b43legacy. b43 should be used on all other cards.

lspci
01:05.0 Network controller: Broadcom Corporation BCM4306 802.11b/g Wireless LAN Controller (rev 03)


I would appreciate any help on this.
Thanks,
Richard Schneiderman






      
