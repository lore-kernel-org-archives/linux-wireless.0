Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redpinesignals.com ([203.196.161.92]:49315 "EHLO
	mail.redpinesignals.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3FXFCR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 01:02:17 -0400
Received: from [192.168.40.112] ([192.168.40.112])
	(authenticated user jahnavi.meher@redpinesignals.com)
	by mail.redpinesignals.com
	for linux-wireless@vger.kernel.org;
	Mon, 24 Jun 2013 10:26:07 +0530
Message-ID: <51C7D11D.8070805@redpinesignals.com> (sfid-20130624_070225_629544_C505F478)
Date: Mon, 24 Jun 2013 10:24:53 +0530
From: Jahnavi <jahnavi.meher@redpinesignals.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Help regarding the initialization of MAC80211 layer
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Hi,
I am new to the linux wireless subsystem and I am trying to bring 
register MAC80211 with a HAL. I have started with the monitor mode and 
am using FC 16, kernel version 3.5.4. I am registering the callbacks to 
the driver through the function ieee80211_alloc_hw(). I am getting a 
kernel crash here, on checking the crash log the crash is from the 
mac80211.ko at main.c, line number 583(BUG_ON(!ops->stop)) which says 
that there is no valid "stop" callback. The crash log says: "invalid 
opcode: 0000 [#1] SMP ". I have a GPL and a NON-GPL module and in the 
stop callback, I am calling a function from the NON-GPL module. I have 
checked my Module.symvers and the function is present there. Any help in 
this regard would be very much appreciated. Thank you.

-- 
Regards,
Jahnavi Meher


