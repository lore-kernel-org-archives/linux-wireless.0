Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f194.google.com ([209.85.222.194]:61331 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab0C3RTO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 13:19:14 -0400
Received: by pzk32 with SMTP id 32so4767272pzk.4
        for <linux-wireless@vger.kernel.org>; Tue, 30 Mar 2010 10:19:13 -0700 (PDT)
Message-ID: <4BB2328D.9010503@lwfinger.net>
Date: Tue, 30 Mar 2010 12:19:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: Broadcom card totally not visible for system (lspci)
References: <b170af451003300956r7fbd7812jdb40d125aeaf1b32@mail.gmail.com>
In-Reply-To: <b170af451003300956r7fbd7812jdb40d125aeaf1b32@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/30/2010 11:56 AM, Rafał Miłecki wrote:
> I've some polish user that has Medion (???) notebook with "BCM4306KFB
> HS00328 P20 702910 M2" (citation from spec).
> 
> This card worked fine in Windows and few days ago user decided to
> install openSUSE 11.2 (2.6.31.12). AFAIK he removed Windows and has
> openSUSE now only.
> 
> The problem is that system does not detect his WiFi card at all. lspci shows:
> 00:00.0 Host bridge: ATI Technologies Inc AGP Bridge [IGP 320M] (rev 13)
> 00:01.0 PCI bridge: ATI Technologies Inc PCI Bridge [IGP 320M] (rev 01)
> 00:07.0 ISA bridge: ALi Corporation M1533/M1535/M1543 PCI to ISA
> Bridge [Aladdin IV/V/V+]
> 00:08.0 Multimedia audio controller: ALi Corporation M5451 PCI AC-Link
> Controller Audio Device (rev 02)
> 00:09.0 Modem: ALi Corporation M5457 AC'97 Modem Controller
> 00:0a.0 CardBus bridge: Texas Instruments PCI4410 PC card Cardbus
> Controller (rev 02)
> 00:0a.1 FireWire (IEEE 1394): Texas Instruments PCI4410 FireWire
> Controller (rev 02)
> 00:0d.0 USB Controller: NEC Corporation USB (rev 43)
> 00:0d.1 USB Controller: NEC Corporation USB (rev 43)
> 00:0d.2 USB Controller: NEC Corporation USB 2.0 (rev 04)
> 00:0e.0 Ethernet controller: Broadcom Corporation BCM4401 100Base-T (rev 01)
> 00:10.0 IDE interface: ALi Corporation M5229 IDE (rev c4)
> 00:11.0 Bridge: ALi Corporation M7101 Power Management Controller [PMU]
> 01:05.0 VGA compatible controller: ATI Technologies Inc Radeon Mobility U1
> 
> Do you have any ideas what may this be?

There are only two reasons for lspci not to list the device:

(1) It is disabled in the BIOS.

(2) It is defective or not plugged in.

No. 1 is checked in the BIOS setup when booting. If nothing found there, and
re-seating the board does not help, then it is time for a new card.

If some device is not seen in lspci or lsusb, then it does not exist for the
operating system.

