Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755147AbZKTTpf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 14:45:35 -0500
Subject: Re: Ad-hoc mode support
From: Dan Williams <dcbw@redhat.com>
To: "Antonio R. Costa" <costa.antonior@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <b0c88b10911200159p1c4a56a5m9d9ede81151a6fef@mail.gmail.com>
References: <b0c88b10911200159p1c4a56a5m9d9ede81151a6fef@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 20 Nov 2009 11:45:54 -0800
Message-Id: <1258746354.26965.77.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-11-20 at 10:59 +0100, Antonio R. Costa wrote:
> Hi guys,
>   I need some suggestions about choosing an USB dongle whose driver
> supports ad-hoc mode under Linux.

Try an rt73usb-driven device like the Hawking HWUG1A or any of the other
adapters that are rt2x00 or zd1211 based.  I can't guarantee that all
these below are actually zd1211b or rt73 (besides the Hawking which I
have right next to me) but here's a list with cdw.com part #s from a
while ago.

SMC SMCWUSB-G EZ Connect g 2.4GHz 54Mbps Wireless USB 2.0 Adapter ($31.99)  zd1211b
CDW Part:  	1031059
Mfg. Part:  	SMCWUSB-G
UNSPSC:  	43201409

D-Link Wireless G USB Adapter ($49.99)  rt73usb
CDW Part:  	1080593
Mfg. Part:  	WUA-1340
UNSPSC:  	43201409

Linksys Compact Wireless-G USB Adapter ($59.99)  rt73usb
CDW Part:  	919115
Mfg. Part:  	WUSB54GC
UNSPSC:  	43201409

Hawking HWUG1A Wireless-G USB Adapter Product ID  ($62.99)
CDW Part:  	1157994
Mfg. Part:  	HWUG1A
UNSPSC:  	43201409

TRENDnet 802.11g Wireless & Bluetooth Combo USB Adapter  ($59.99)  zd1211
CDW Part:  	936507
Mfg. Part:  	TBW-103UB
UNSPSC:  	43201409

3Com OfficeConnect Wireless 54Mbps 11g Compact USB Adapter  ($53.99)  zd1211b
CDW Part:  	698171
Mfg. Part:  	3CRUSB10075
UNSPSC:  	43201409

Hawking HWUG1 Wireless-G USB Adapter  ($55.99)  rt2570
CDW Part:  	1038208
Mfg. Part:  	HWUG1
UNSPSC:  	43201409

Netopia 3-D Reach Wireless Adapter - network adapter  ($49.99)  rt71
CDW Part:  	845451
Mfg. Part:  	TER/GUSB-N1
UNSPSC:  	43201409

TRENDnet TEW 429UB Wireless USB Adapter  ($59.99)  zd1211b
CDW Part:  	828030
Mfg. Part:  	TEW-429UB
UNSPSC:  	43201409

ZyXEL ZyAIR AG-225H - network adapter  ($63.99)  zd1211  (USB, has A)
CDW Part:  	864954
Mfg. Part:  	AG-222H
UNSPSC:  	43201409

IOGEAR WiFi 54g USB Adapter  ($32.99)  zd1211
CDW Part:  	785329
Mfg. Part:  	GWU523
UNSPSC:  	43201409


