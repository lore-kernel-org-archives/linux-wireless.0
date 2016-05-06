Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2on0084.outbound.protection.outlook.com ([207.46.100.84]:26947
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755915AbcEFRST (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2016 13:18:19 -0400
To: <linux-wireless@vger.kernel.org>
From: Tom Harada <tomharada@lnihealth.com>
Subject: Limiting bit rate on BCM43438
Message-ID: <77343ffd-10b2-4d85-4c5e-ae639a7cf59a@lnihealth.com> (sfid-20160506_191824_068840_12EA733F)
Date: Fri, 6 May 2016 13:18:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On a Raspberry Pi 3 running Raspbian, I'm finding it impossible to 
maintain a stable WiFi connection with 802.11n access points using the 
internal BCM43438 chip. The association is lost quite frequently (as 
often as twice a minute) and often fails to be recovered. I've tried the 
usual fixes recommended by the RPi forum (disabling power management, 
setting the regulatory domain, updating the kernel) without success. 
However, the problem seems to be less severe with 802.11g access points. 
Is there a way to limit the BCM43438's bit rate and force it to connect 
as a "g" device? iw/iwconfig don't allow this, returning "Operation not 
supported." I'm willing to modify the kernel/drivers if that's what it 
takes. Of course, other suggestions are appreciated as well.

Thanks in advance.

