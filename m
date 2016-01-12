Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:33804 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934052AbcALL4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 06:56:35 -0500
Received: by mail-pf0-f172.google.com with SMTP id q63so63813203pfb.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jan 2016 03:56:35 -0800 (PST)
Received: from ?IPv6:2001:da8:20c:641:8d3:511b:5312:dad7? ([2001:da8:20c:641:8d3:511b:5312:dad7])
        by smtp.gmail.com with ESMTPSA id c90sm30001924pfd.31.2016.01.12.03.56.33
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Tue, 12 Jan 2016 03:56:34 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Fulcrum Mike <fulcrummike@gmail.com>
Subject: Wireshark: Alfa AWUS036H not capturing TCP
Message-ID: <5694E9EC.3080103@gmail.com> (sfid-20160112_125638_574497_DA9C6ED8)
Date: Tue, 12 Jan 2016 19:56:28 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everybody

I am using Alfa AWUS036H usb Wifi device with Arch Linux (kernel 4.3.3) 
to capture wifi traffic. I have setup an open access point which should 
be easy to sniff. I tried for many days but couldn't catch any tcp data. 
There were numerous protocols like 802.11 broadcasts, NBNS, UDP, ICMPv6, 
ARP, SSDP, LLMNR etc but no tcp. Then I booted a live kali cd and 
repeated the same procedure exactly. This time everything worked fine 
and there was plentiful tcp traffic from multiple APs nearby.

My procedure: I put the device in monitor mode using 'airmon-ng start 
wlan0'. Then start capturing data using 'airodump-ng wlan0mon' so I 
start seeing info about nearby access points. At this stage I start data 
capture on Wireshark. Here onwards, Kali gives loads of tcp data but 
Arch doesn't capture a single tcp packet.

My question is: While both Arch and Kali systems are using the same 
driver (rt2800usb version 2.3.0), why can't I capture tcp on Arch?

Regards

