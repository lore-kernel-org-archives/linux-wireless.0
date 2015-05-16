Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:35739 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbbEPUqD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2015 16:46:03 -0400
Received: by labbd9 with SMTP id bd9so168876248lab.2
        for <linux-wireless@vger.kernel.org>; Sat, 16 May 2015 13:46:02 -0700 (PDT)
Received: from [192.168.0.103] ([213.21.44.132])
        by mx.google.com with ESMTPSA id ej5sm1379627lad.5.2015.05.16.13.46.01
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 May 2015 13:46:01 -0700 (PDT)
Message-ID: <5557AC87.6080008@users.sourceforge.net> (sfid-20150516_224609_683968_A5DA4058)
Date: Sat, 16 May 2015 23:45:59 +0300
From: Alberto Mardegan <mardy@users.sourceforge.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: tp-link tl-wn8200nd and rtlwifi_new drivers
References: <5557A00E.1090104@users.sourceforge.net> <5557A2E6.7070406@lwfinger.net>
In-Reply-To: <5557A2E6.7070406@lwfinger.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/16/2015 11:04 PM, Larry Finger wrote:
> Please list the USB ID for your device as shown by lsusb.

Bus 001 Device 004: ID 2357:0100

Here's the first few lines of syslog when I insert the device:

May 16 23:39:31 fujino kernel: [  526.925753] usb 1-1.2: new high-speed 
USB device number 4 using ehci-pci
May 16 23:39:31 fujino kernel: [  527.019903] usb 1-1.2: New USB device 
found, idVendor=2357, idProduct=0100
May 16 23:39:31 fujino kernel: [  527.019910] usb 1-1.2: New USB device 
strings: Mfr=1, Product=2, SerialNumber=3
May 16 23:39:31 fujino kernel: [  527.019915] usb 1-1.2: Product: 
802.11n WLAN Adapter
May 16 23:39:31 fujino kernel: [  527.019918] usb 1-1.2: Manufacturer: 
Realtek
May 16 23:39:31 fujino kernel: [  527.019921] usb 1-1.2: SerialNumber: 
00e04c000001
May 16 23:39:31 fujino kernel: [  527.023349] rtl8192cu: Chip version 0x11
May 16 23:39:31 fujino kernel: [  527.113013] rtl8192cu: MAC address: 
c4:6e:1f:17:0d:f8
May 16 23:39:31 fujino kernel: [  527.113023] rtl8192cu: Board Type 0
May 16 23:39:31 fujino kernel: [  527.113250] rtl_usb: rx_max_size 
15360, rx_urb_num 8, in_ep 1
May 16 23:39:31 fujino kernel: [  527.113295] rtl8192cu: Loading 
firmware rtlwifi/rtl8192cufw_TMSC.bin
May 16 23:39:31 fujino kernel: [  527.113733] ieee80211 phy2: Selected 
rate control algorithm 'rtl_rc'
May 16 23:39:31 fujino kernel: [  527.114712] rtlwifi: wireless switch is on

I found this old conversation where you were helping another user having 
the same device:

http://www.spinics.net/lists/linux-wireless/msg109223.html

Did you get the device you ordered from e-bay? I wonder if they are all 
the same, or if there are hardware variants which are working out of the 
box.

Ciao,
   Alberto
