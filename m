Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:45546 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750999Ab1KIJNp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 04:13:45 -0500
Content-Type: text/plain; charset="utf-8"
Date: Wed, 09 Nov 2011 10:13:41 +0100
From: "Harald Freitag" <harald.freitag@gmx.net>
Message-ID: <20111109091341.83440@gmx.net> (sfid-20111109_101351_090451_1D401D02)
MIME-Version: 1.0
Subject: Compability Issue regarding Freescale i.MX356 and Marvell 88w8688
 Wifi-Module
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I am a student from Germany currently working on a solution to combine the Freescale i.MX356 application processor with the Marvell 88w8688 Wifi-Module over the SDIO interface of the processor.

My main problem is that the application processor of Freescale got an embedded linux 2.6.31 system including the necessary driver support (specially for the SDIO interface) implemented and the driver for the Marvell 88w8688 Wifi-Module is coming with a linux 2.6.35 firmware/driver support.

Now the question is, how do I get them both working together? (I am still a novice on that field of expertise!)

Option 1: Backporting the Marvell 88w8688 SDIO driver from linux 2.6.35 to 2.6.31
Option 2: Finding an older Marvell 88w8688 SDIO compatible with linux 2.6.31

I already did some research (on http://kernelnewbies.org/) trying to figure out what general differences and changes in the libertas driver support have been made (with moderate success, since I am still lacking quite alot of the necessary coding understanding). 
I also downloaded the latest software/firmware packages from Freescale and Marvell in order to learn something about the functionality of SDIO interface drivers (pretty much hitting a wall though...).
After some time looking through the archives here on "http://linuxwireless.org/" and on "http://lists.infradead.org/mailman/listinfo/libertas-dev" I saw a few articles that could be partially helpful for my problem, but that didnt got me very far yet...

Since the embedded linux 2.6.31 system on the application processor got already adapted and configured for the intended feature support, it is not an option to upgrade/patch the linux system on the application processor. 

I would be most grateful for any helpful information regarding this issue or hint towards the right place to look, if there have been similar problems solved/delt with in the past.

Thank you very much and I appreciate that you took some time reading through this...

Regards Harald


-- 
Empfehlen Sie GMX DSL Ihren Freunden und Bekannten und wir
belohnen Sie mit bis zu 50,- Euro! https://freundschaftswerbung.gmx.de
