Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gamma.ubit.hu ([46.19.33.31]:44694 "EHLO gamma.reon.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357AbaJBO56 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2014 10:57:58 -0400
Received: from alpha.solidcluster.net ([195.228.155.188] helo=beta.solidcluster.net)
	by gamma.reon.hu with esmtp (Exim 4.72)
	(envelope-from <aron@aron.ws>)
	id 1XZh9j-0000wx-Ou
	for linux-wireless@vger.kernel.org; Thu, 02 Oct 2014 16:14:55 +0200
Received: from catv-89-133-38-156.catv.broadband.hu ([89.133.38.156] helo=[192.168.1.50])
	by beta.solidcluster.net with esmtpa (Exim 4.80.1)
	(envelope-from <aron@aron.ws>)
	id 1XZhA0-0003Fw-8C
	for linux-wireless@vger.kernel.org; Thu, 02 Oct 2014 16:15:12 +0200
Message-ID: <542D5DCE.5060007@aron.ws> (sfid-20141002_165807_334569_4228F0A3)
Date: Thu, 02 Oct 2014 16:14:38 +0200
From: Aron Szabo <aron@aron.ws>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: brcm8021: BCM43341
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

I have an ASUS T200TA that has this chip BCM43341 02D0:A94D 
(http://www.broadcom.com/products/Bluetooth/Bluetooth-RF-Silicon-and-Software-Solutions/BCM43341).
This chip is supported by the bcmdhd driver under Android, but not by 
this driver.

I tried to modify the driver to load the firmware extracted from the 
Windows version, but I had no luck:

brcmfmac_sdio mmc1:0001:1: Direct firmware load failed with error -2
brcmfmac_sdio mmc1:0001:1: Falling back to user helper

The sta driver from Broadcom does not support this chip.

Without documentation and any knowledge of how wireless chips work, what 
I can do is probably useless trial and error, so I wanted to ask for help :)

Ha someone worked with this chip? Can somebody point me in the right 
direction ?

Thanks!

Yours,
Aron
