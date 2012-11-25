Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:42788 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab2KYQJa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2012 11:09:30 -0500
Subject: Atheros AR3012 problem in Ubuntu 12.04LTS
From: Jukka Kivari <jukka.kivari@pohjolantietotekniikka.fi>
Reply-To: jukka.kivari@pohjolantietotekniikka.fi
To: mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Sun, 25 Nov 2012 18:09:25 +0200
Message-Id: <1353859765.3743.14.camel@EDAnovaSRV1> (sfid-20121125_170936_082179_4E41FBB9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm not sure whether you're correct person to helps us but let's try :-)

We are Dell reseller partner in Finland and providing turn key Ubuntu
solutions and services for Dell desktops and laptops. We are just
building a new system to a customer and found out that bluetooth is not
working on Dell Vostro 3560 with standard Ubuntu 12.04LTS release.
Apparently there is no correct driver or FW available.

We have found out the Device is AR3012, VID/PID 0cf3:a003. It seems Dell
has some special driver for this in pre-installed Ubuntu
11.10 or there might be some hacking like this:

http://wireless.kernel.org/en/users/Drivers/ath3k

My current analysis of the problem is:

1) BT device is recognized correctly (PID=e003)
2) Ubuntu 12.04 has all drivers and firmaware available
3) driver/firmaware loading fails, there is no PID e003 in btusb.c or
ath3k.c

I think it's something similar to this

http://forum.soft32.com/linux/RFC-btusb-firmware-load-help-ftopict522254.html


We have also tested older and latest Ubuntu and kernel releases and
Fedora 17 and it fails on all.

 
Can you helps us how to make it work. We'd appreciate a fast feedback as
we should get this system delivered to customer in couple of days. 


-- 
Best Regards,

Jukka Kivari
Managing Director
--------------------------------------------------------------------------------------------
Pohjolan Tietotekniikka
EDAnova Oy
Mail address: PL109, 90101 Oulu
Visiting address: Rautatienkatu 84, 90400 Oulu
Tel: +358 400 199 217
www.pohjolantietotekniikka.fi
--------------------------------------------------------------------------------------------

**********************************
       Powered by Linux
**********************************




