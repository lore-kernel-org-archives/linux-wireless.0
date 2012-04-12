Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm11-vm5.bullet.mail.sg3.yahoo.com ([106.10.148.244]:29561 "HELO
	nm11-vm5.bullet.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756438Ab2DLOhs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 10:37:48 -0400
Message-ID: <1334241114.15814.YahooMailNeo@web192304.mail.sg3.yahoo.com> (sfid-20120412_163752_815894_62FDF500)
Date: Thu, 12 Apr 2012 22:31:54 +0800 (SGT)
From: Dino Joseph Mycle <dinomycle@yahoo.com>
Reply-To: Dino Joseph Mycle <dinomycle@yahoo.com>
Subject: wl12xx: receiving all packet(like Promiscuous mode)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all
    We are doing one experiment with wl12xx,
in this we are required to get all packet received which passes FCS. I set the
rx_config  CFG_RX_ALL_GOOD, but still not getting any packet. we want it to behave how it is in monitor mode. Can someone throw some light into this .

When we configure it with CFG_RX_ALL_GOOD, that is 0x0x8 for the rx_config, the value is been set, but the effect is not there. Is there any dependency on the firmware ? 

Using the linux-3.1.10 with firmware (Rev 6.1.5.50.74) with Panda board
 
Thanks for the support,
Dino Joseph Mycle
