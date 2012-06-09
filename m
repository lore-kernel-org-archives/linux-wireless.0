Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from h1355771.stratoserver.net ([85.214.105.140]:55431 "EHLO
	h1355771.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab2FINnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 09:43:00 -0400
Subject: poor performance with W2CBW003 (Marvell 8686)
From: Andreas Kemnade <andreas@kemnade.info>
To: dsd@laptop.org, dcbw@redhat.com, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 09 Jun 2012 15:03:27 +0200
Message-ID: <1339247007.5895.373.camel@localhost> (sfid-20120609_154336_516104_954CE8F1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

on the GTA04 (www.gta04.org) 
which has a W2CBW003 chip for wifi connected to a DM3730CBP CPU. data
rates are quite low using the libertas driver from kernel 3.2-3.4 
(https://github.com/neilbrown/gta04/branches)
even near an accesspoint. That seems not depend on the encryption
settings. Rates are around 100KByte/s. iwconfig shows 5.5Mb/s if it is
not connected to an accesspoint with specially configured rates (but
still the throughput is low).

In contrary data rates are high (>1MByte/s) with a kernel based on
the 2.6.32  BeagleBoard XM hw-validation kernel
https://github.com/goldelico/gta04-kernel
That behaviour was reported by several people.

I tried also the libertas-tf driver with kernel 3.2 using the
instructions here:
http://corysohrakoff.wordpress.com/2011/09/13/enabling-wifi-ap-mode-on-a-gumstix-overo/
That was also slow.

Any hints?

Greetings
Andreas Kemnade

