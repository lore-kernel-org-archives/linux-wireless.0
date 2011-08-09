Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail01.spothost.nl ([77.74.49.150]:37477 "EHLO
	webmail01.spothost.nl" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753075Ab1HIJaf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:30:35 -0400
Received: from webmail.spothost.nl (localhost.localdomain [127.0.0.1])
	by webmail01.spothost.nl (8.13.8/8.13.8) with ESMTP id p799GCIG001755
	for <linux-wireless@vger.kernel.org>; Tue, 9 Aug 2011 11:16:13 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 09 Aug 2011 09:16:12 +0000
From: kc@cobradevil.org
To: <linux-wireless@vger.kernel.org>
Subject: rtl8192cu sometimes it can authenticate to ap
Message-ID: <b3059ba2eac66b7ef0ec17c8fe81a1e6@cobradevil.org> (sfid-20110809_113038_749548_AC3C4D97)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

i have three usb sticks with the the id:
0bda:8176

I am running ubuntu maverick with the compat tree from 2011-08-08 
(downloaded this morning) and i also tried several others (dates from 15 
juli 2011).
The main problem is that sometimes i get a connection and it works like 
a charm and then all of the sudden i don't get any connection at all and 
running wpa_supplicant says time out.

i really have no idea whats wrong so if someone could help me out.
is there a way to get debugging from the rtlwifi drivers?

i got the firmware from: 
http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git

With kind regards

William

