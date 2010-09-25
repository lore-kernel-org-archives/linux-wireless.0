Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from snt0-omc2-s43.snt0.hotmail.com ([65.54.61.94]:63591 "EHLO
	snt0-omc2-s43.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754832Ab0IYAe1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 20:34:27 -0400
Message-ID: <SNT113-W182B461295E717BB27130BF1630@phx.gbl>
From: Dale Turner <rx_guy@hotmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: carl9170 problem
Date: Fri, 24 Sep 2010 21:34:26 -0300
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello everyone.

Thanks for releasing the carl9170 driver in the 
compat-wireless package. I have been able to compile the driver, so that
 is great. The connection seems to be a bit inconsistent. I get the 
following quite often in /var/log/messages :

kernel: ieee80211 phy9: channel change: 2472 -> 2462 failed (2)

and/or

kernel: ieee80211 phy9: invalid plcp cck rate (0)

and/or

kernel: ieee80211 phy9: FW: MAC RESET

When
 that happens (which can be as often as every few minutes) my reported 
connection speed in network manager drops to 6 or 1 Mb/s. The network 
speed is noticeably reduced (for instance download speeds drastically 
reduce, online videos stutter, or music streaming from a different 
computer pauses, etc).

My previous adapter TP-Link TL-WN721N (ath9k_htc driver) did not behave like this.

Any thoughts/solutions ??

Again, many thanks for providing the driver. I cannot program (I wish I could to help) but I can report my experience.

Dale

 		 	   		   		 	   		  