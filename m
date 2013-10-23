Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm16-vm1.bullet.mail.ird.yahoo.com ([77.238.189.88]:25544 "EHLO
	nm16-vm1.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750847Ab3JWO1v convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Oct 2013 10:27:51 -0400
References: <1382537927.62604.YahooMailNeo@web171801.mail.ir2.yahoo.com>
Message-ID: <1382538469.7892.YahooMailNeo@web171805.mail.ir2.yahoo.com> (sfid-20131023_162754_284746_4C2B36F9)
Date: Wed, 23 Oct 2013 15:27:49 +0100 (BST)
From: Gianfranco Costamagna <costamagnagianfranco@yahoo.it>
Reply-To: Gianfranco Costamagna <costamagnagianfranco@yahoo.it>
Subject: Edimax EW-7733UnD
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1382537927.62604.YahooMailNeo@web171801.mail.ir2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kernel Wireless developers, I write here since I have an issue with this module.


We bought 2 of them since they are both 2.4 and 5Ghz capable, and they seem to be powerful enough for our pourposes
http://www.edimax.com/au/produce_detail.php?pd_id=399&pl1_id=1&pl2_id=44


Anyway there is a problem, that the linux kernel seems to be not supporting them

I tried following this guide
http://wikidevi.com/wiki/Edimax_EW-7733UnD
rt3573sta, possibly rt5572sta, and future support in rt2800usb "uhosg's patchset adding support, may be in by k3.12"
but at this moment it is showing an interface with one of them (I cannot connect to anything, the interface shown seems to be incorrect), with another I get a kernel anic and with the third one doesn't work at all.

lsusb |grep Edimax

Bus 002 Device 002: ID 7392:7733 Edimax Technology Co., Ltd 

Are you guys working on it? How can I make it work? I'm open to patches, suggestions or whatever can help me in using them


thanks

(please cc me, I'm not yet subscribed to this list)
Gianfranco
