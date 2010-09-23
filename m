Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53959 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab0IWMoD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 08:44:03 -0400
Received: by ywh1 with SMTP id 1so527523ywh.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Sep 2010 05:44:02 -0700 (PDT)
Date: Thu, 23 Sep 2010 20:44:00 +0800
From: Calwin <rrredboot998@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Can someone help me with B43 driver? thanks a lot 
Message-Id: <20100923204356.97ED.1B491177@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all friends 
      I have AMBITG T60H906 bcm 4318 wireless card , i want to run it on
kernel 2.6.24, after compile the kernel and related modulers ,i boot it
up .
      After modprobe b43 ,i can not see the default wifi interface wlan0
,and no other wifi interface too. I found some error in dmesg ,just like
below :

bus type 'ssb' registered
bus pci: add driver b43-pci-bridge
pci: Matched Device 0000:00:01.0 with Driver b43-pci-bridge
pci: Probing driver b43-pci-bridge with device 0000:00:01.0
PCI: enabling device 0000:00:01.0 (0140 -> 0142)
ssb: PCI-ID not in fallback list
ssb: CHIPID not in nrcores fallback list
ssb: WARNING: Invalid SPROM CRC (corrupt SPROM)
ssb: Unsupported SPROM revision 0 detected. Will extract v1
DEV: registering device: ID = 'ssb0:0'
bus ssb: add device ssb0:0
ssb: Sonics Silicon Backplane found on PCI device 0000:00:01.0
bound device '0000:00:01.0' to driver 'b43-pci-bridge'
pci: Bound Device 0000:00:01.0 to Driver b43-pci-bridge

     of course ,i doubt perhaps i have "corrupt SPROM" on my wireless
card , i have 2 questions about it 
   
   1  Is it sure that the driver included in the kernel 2.6.24 can drive
bcm4318 ?
   2  if 1 is true  , can  b43 driver  bring up the device and add the
interface to system when a corrupt SPROM is present ?
   3  how can i deal with it ? change a good wireless card or somethings
else or someone can send me a copy of good SPROM , i can try to write it 
with related tools in b43 ?

Any suggestions is  welcome ,Thanks  

Best Regards

EricZhang<rrredboot998@gmail.com>

