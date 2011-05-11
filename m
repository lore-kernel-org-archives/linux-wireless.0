Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:37619 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642Ab1EKUat (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 16:30:49 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-124-14.nexicom.net [216.168.124.14])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p4BKUkdu010688
	for <linux-wireless@vger.kernel.org>; Wed, 11 May 2011 16:30:47 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 2ACC21E0112
	for <linux-wireless@vger.kernel.org>; Wed, 11 May 2011 16:30:46 -0400 (EDT)
Message-ID: <4DCAF218.7050402@lockie.ca> (sfid-20110511_223053_055750_E39D8F05)
Date: Wed, 11 May 2011 16:31:20 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: later kernels that 2.6.36.4 mess up wireless (but compatwireless
 on that kernel works)
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

vanilla linux-2.6.36.4 works with my 02:09.0 Network controller: Atheros
Communications Inc. AR5008 Wireless Network Adapter (rev 01)
compat-wireless-2011-05-11.tar.bz2 also works with the 2.6.36.4 kernel).

$ sudo modinfo ath9k 
filename:      
/lib/modules/2.6.36.4/updates/drivers/net/wireless/ath/ath9k/ath9k.ko

A later kernel doesn't work.

I can take out my tv tuner card and take out the binary driver for my
nvidia video card.

How can I find out which part of the kernel is messing up my wireless card?
Maybe someone can send me their working .config
I just need AHCI SATA support. :-)

