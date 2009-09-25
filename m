Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55420 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750992AbZIYJcS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 05:32:18 -0400
From: Malte Gell <malte.gell@gmx.de>
To: linux-wireless@vger.kernel.org
Subject: Re: ar9170 makes machine hang when shut down
Date: Fri, 25 Sep 2009 11:32:18 +0200
References: <200909242155.19485.malte.gell@gmx.de> <4ABBE5DB.5070201@gmx.de>
In-Reply-To: <4ABBE5DB.5070201@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200909251132.18546.malte.gell@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Joerg Albert <jal2@gmx.de> wrote

> > Does it make sense to use "rmmod --force ar9170" to force removing that
> > module before shutting down?
> 
> Why are you sure that the hang is caused by the ar9170 driver?

You are right.... I thought this way, because my machine never hung and after 
installing the USB stick it hang... But, I noticed when i disable ISDN 
subsystem, it did not hang, so maybe it is the ISDN subsystem, I will try 
further.
 
> The vendor driver is called arusb_lnx, the new one ar9170usb

Vendor driver? Does this mean, Atheros made a driver on its own? Are there 
several drivers for the same chip now?

My system loads ar9170:

lsmod | grep ar91*

ar9170                 32632  0
mac80211              237208  1 ar9170
led_class               4028  1 ar9170
usbcore               183280  15 
usbserial,ar9170,usbhid,uvcvideo,snd_usb_audio,snd_usb_lib,usblp,ehci_hcd,uhci_hcd,ohci_hcd,usb_storage

Regards
Malte
