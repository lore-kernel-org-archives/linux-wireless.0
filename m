Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out25.alice.it ([85.33.2.25]:4574 "EHLO
	smtp-out25.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbXEDOZl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2007 10:25:41 -0400
From: Matteo Croce <rootkit85@yahoo.it>
To: Michal Schmidt <mschmidt@redhat.com>
Subject: Re: airo works badly
Date: Fri, 4 May 2007 16:11:21 +0200
References: <200705041410.02269.rootkit85@yahoo.it> <463B28F1.4020107@redhat.com>
In-Reply-To: <463B28F1.4020107@redhat.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200705041611.21185.rootkit85@yahoo.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 04 May 2007 14:37:05 you wrote:
> (CCing linux-wireless, other people might have ideas)
>
> Matteo Croce skrev:
> > Every day i gets offline after reading this in the syslog:
> >
> > May  3 15:25:30 raver kernel: airo(): Probing for PCI adapters
> > May  3 15:25:30 raver kernel: airo(eth0): cmd:111 status:7f11 rsp0:2
> > rsp1:0 rsp2:0 May  3 15:25:30 raver kernel: airo(eth0): Doing fast
> > bap_reads
> > May  3 15:25:30 raver kernel: airo(eth0): WPA is supported.
> > May  3 15:25:30 raver kernel: airo(eth0): MAC enabled 0:d:29:4f:c:be
> > May  3 15:25:30 raver kernel: airo(): Finished probing for PCI adapters
> > May  3 17:59:36 raver kernel: airo(eth0): Bad size 8192
> > May  3 18:47:52 raver kernel: airo(eth0): Bad size 8192
> > May  3 19:05:47 raver kernel: airo(eth0): Bad size 8192
> > May  3 19:08:08 raver kernel: airo(eth0): Bad size 8192
> > May  3 19:20:07 raver kernel: airo(eth0): airo: BAP setup error too many
> > retries May  3 19:20:07 raver kernel: airo(eth0): airo: BAP setup error
> > too many retries May  3 19:20:09 raver kernel: airo(eth0): airo: BAP
> > setup error too many retries May  3 19:20:09 raver kernel: airo(eth0):
> > airo: BAP setup error too many retries May  3 19:20:09 raver kernel:
> > airo(eth0): airo: BAP setup error too many retries May  3 19:20:09 raver
> > kernel: airo(eth0): airo: BAP setup error too many retries May  3
> > 19:20:09 raver kernel: airo(eth0): airo: BAP setup error too many retries
> > May  3 19:20:09 raver kernel: airo(eth0): airo: BAP setup error too many
> > retries May  3 19:20:09 raver kernel: airo(eth0): airo: BAP setup error
> > too many retries May  3 19:20:09 raver kernel: airo(eth0): airo: BAP
> > setup error too many retries May  3 19:20:09 raver kernel: airo(eth0):
> > airo: BAP setup error too many retries May  3 19:20:10 raver kernel:
> > airo(eth0): airo: BAP setup error too many retries May  3 19:20:10 raver
> > kernel: airo(eth0): airo: BAP setup error too many retries
>
> Hi,
>
> What kernel version are you using? Is this a regression? If so, what was
> the last version that worked well?
I'm using 2.6.21, last version that worked well is something like 2.6.15

> What if you rmmod the driver and then reload it? Does it make it work
> again?
Yes, it does work again

> What hardware is it exactly? The airo driver supports more than one 
> type of card.
Cisco Aironet 350 PCI
$ cat /proc/driver/aironet/eth0/Status
Status: CFG ACT SYN LNK PRIV KEY WEP
Mode: 3bf
Signal Strength: 70
Signal Quality: 34
SSID: cocorico
AP:
Freq: 0
BitRate: 11mbs
Driver Version: airo.c 0.6 (Ben Reed & Javier Achirica)
Device: 350 Series
Manufacturer: Cisco Systems
Firmware Version: 5.60.21
Radio type: 2
Country: 1
Hardware Version: 22
Software Version: 560
Software Subversion: 15
Boot block version: 150
> Are you doing anything special with the card, like running some wifi
> monitoring application for instance?
No, just web and mail
> Michal


