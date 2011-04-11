Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:41875 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab1DKPAN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 11:00:13 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Q9Ib3-00038T-Sj
	for linux-wireless@vger.kernel.org; Mon, 11 Apr 2011 17:00:09 +0200
Received: from 130.149.144.41 ([130.149.144.41])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2011 17:00:09 +0200
Received: from chithanh by 130.149.144.41 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2011 17:00:09 +0200
To: linux-wireless@vger.kernel.org
From: =?utf-8?b?Q2jDrS1UaGFuaA==?= Christopher
	 =?utf-8?b?Tmd1eeG7hW4=?= <chithanh@gentoo.org>
Subject: Re: Firmware for rt2800pci and rt2800usb
Date: Mon, 11 Apr 2011 14:56:12 +0000 (UTC)
Message-ID: <loom.20110411T165357-972@post.gmane.org>
References: <4DA2042A.3010301@gmail.com> <1302469406.5282.341.camel@localhost> <4DA22545.6050209@gmail.com> <4DA2312B.8080303@lwfinger.net> <4DA23594.8090002@gmail.com> <4DA2702B.2080305@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@...> writes:

> I am in the process of updating the firmware files for rt2800pci and
> rt2800usb. 
> If you have one of the devices that use this driver, please test the firmware
> file.

Tested with the following device and rt2800usb driver from kernel 2.6.38:

Bus 001 Device 002: ID 148f:3071 Ralink Technology, Corp. RT3071 Wireless
Adapter

e4b60f5bb4980a26cbac32be690451d6  rt2870.bin (from linux-firmware tree)
phy0 -> rt2x00lib_request_firmware: Error - Current firmware does not support
detected chipset.

a18579be68e02caf3c879407fd8e5b82  rt2870.bin (from RT2870_Firmware_V8.zip)
phy0 -> rt2x00lib_request_firmware: Error - Current firmware does not support
detected chipset.

cfc8663dc0c671f1cf022c791b2f1283  rt2870.bin (from
2009_0820_RT2870_Linux_STA_V2.2.0.0.tar.bz2)
Works

36c944c3138125605d28c0a3a1338be9  rt2870.bin (from your email)
Works

Best regards,
Chí-Thanh Christopher Nguyễn

