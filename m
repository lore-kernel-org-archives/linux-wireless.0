Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53453 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab1DXTdz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 15:33:55 -0400
Received: by wya21 with SMTP id 21so1228566wya.19
        for <linux-wireless@vger.kernel.org>; Sun, 24 Apr 2011 12:33:54 -0700 (PDT)
Mime-Version: 1.0 (Apple Message framework v753.1)
Message-Id: <60EDBC04-4433-42CD-8209-66324B8044DE@googlemail.com> (sfid-20110424_213358_649233_009F04EE)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
To: linux-wireless@vger.kernel.org
From: Tobias Netzel <tobias.netzel@googlemail.com>
Subject: Status of support for Broadcom 14e4:4329 (Cardbus)
Date: Sun, 24 Apr 2011 21:33:51 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've got that Broadcom BCM4321 based CardBus device (14e4:4329) and  
I'd like to use it with a PowerBook (PowerPC) and linux 2.6.38 . So  
far it doesn't seem to work out the box. The card is being recognized  
and the b43 driver is loaded but scanning doesn't give any results  
(although there should be) and connecting doesn't work either.
Upon ifdown I get a message about DMA errors related to that card. Do  
I have to switch the card to PIO mode? How do I do that?
Will there be improved support for that card in linux 2.6.39 ? And in  
the future?
(BTW: Booting that very same linux installation on another PowerBook  
with a Broadcom-based 802.11g Apple AirPort-Card does work without  
any problems.)

Thanks in advance,
Tobias
