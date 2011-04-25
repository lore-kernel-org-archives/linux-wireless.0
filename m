Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:40905 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439Ab1DYKPO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 06:15:14 -0400
Received: from [195.4.92.28] (helo=18.mx.freenet.de)
	by mout0.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.72 #5)
	id 1QEIoy-0006ti-8I
	for linux-wireless@vger.kernel.org; Mon, 25 Apr 2011 12:15:12 +0200
Received: from p54a18759.dip0.t-ipconnect.de ([84.161.135.89]:34350 helo=mail.maya.org)
	by 18.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.72 #3)
	id 1QEIox-0005Ip-U1
	for linux-wireless@vger.kernel.org; Mon, 25 Apr 2011 12:15:12 +0200
Received: from [192.168.1.6] (dualc.maya.org [192.168.1.6])
	by mail.maya.org (8.14.4/8.13.8) with ESMTP id p3PAF8UL003454
	for <linux-wireless@vger.kernel.org>; Mon, 25 Apr 2011 12:15:09 +0200
Message-ID: <4DB54A1D.9030501@01019freenet.de> (sfid-20110425_121517_867893_279688D7)
Date: Mon, 25 Apr 2011 12:17:01 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Searching for a good hardware for an AP with hostapd
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I want to build an own AP with hostapd and therefore I'm searching for
hardware, which supports 801.11n and MIMO. Throughput must be >= 300Mbps
and it should support the frequency bands 2.4 and 5 GHz. It should have
the ability to put the antenna at a place away from the computer (the
antenna shouldn't be fixed on the card itself).

For example, I've got a WUSB600N v2 which unfortunately isn't supported
by nl80211 (it's rt3572 based), which has a cable to place it at a good
place outside the computer.


As atheros seems to be well supported by linux, I would like to buy a
atheros based hardware with the following chips:
atheros ar9380 or ar9390 or ar9392.

Does anybody know of cards with these chips?


Or is there any other hardware, which would meet my requirements?



Thank you for any hint!
Andreas
