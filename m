Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([91.250.116.113]:59002 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab3I3IA6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 04:00:58 -0400
Message-ID: <52492FB0.3010201@einfach.org> (sfid-20130930_100101_785529_6DAEED90)
Date: Mon, 30 Sep 2013 09:00:48 +0100
From: Bruno Randolf <br1@einfach.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	sujith@msujith.org, linux@rempel-privat.de
CC: Ingo Randolf <ingo.randolf@qupik.com>
Subject: ath9k AR9287 status?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

What is the status of AR9287 support in ath9k?

I have a AR9287 PCI-Express card which is behaving more than weird with 
kernel 3.2 and with the current (3.10.4-1) backports drivers: It can't 
connect to APs (many reconnects), with hostap it _seems_ to work as an 
AP, but no beacons are seen and no stations can connect, similar in 
ad-hoc mode, and when bringing the interface down the whole system 
freezes...

I've seen some related bugs in the bugtracker, but I wonder what the 
experiences with this chipset are in general?

Or - can anyone recommend a good half size PCI-Express card that works 
well with ath9k?

Thanks,
bruno
