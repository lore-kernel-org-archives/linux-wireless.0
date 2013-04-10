Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from x1.w4w.guest.it ([77.95.174.1]:51935 "EHLO x1.w4w.guest.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935225Ab3DJKYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 06:24:15 -0400
Received: from [46.182.93.144] (helo=[192.168.1.33])
	by x1.w4w.guest.it with esmtpa (Exim 4.80.1)
	(envelope-from <danjde@msw.it>)
	id 1UPrw6-0001mQ-0c
	for linux-wireless@vger.kernel.org; Wed, 10 Apr 2013 12:07:26 +0200
Message-ID: <516539DC.8060004@msw.it> (sfid-20130410_122424_229038_BFE71355)
Date: Wed, 10 Apr 2013 12:07:24 +0200
From: Davide Marchi <danjde@msw.it>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: realtek usb wifi based on "rtl8192cu"
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi friends,
on realtek usb wifi based on "rtl8192cu",
using kernel 3.8.3.x or 3.8.6 the device seem work good, but is unable 
to connect. Infinitely it ask me the wep/wpa key..

I've tested using kernel "Linux  3.8.3-103.fc17.x86_64 #1 SMP Mon Mar 18 
15:46:01 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux"
and 3.8.6 vanilla (from kernel.org)

Asking to Larry Finger he says that from kernel 3.8.5 this issues is 
fixed, but is not so, for my experience.

lsusb:
Bus 001 Device 003: ID 0bda:8178 Realtek Semiconductor Corp. RTL8192CU 
802.11n WLAN Adapter


many thanks

Davide
Italy



-- 
cosmogoniA
cosmogoniA<http://www.cosmogonia.org/>
noprovarenofareononfarenonc'èprovare

