Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 93-97-239-3.zone5.bethere.co.uk ([93.97.239.3]:47516 "EHLO
	pond-weed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115Ab2AANo0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jan 2012 08:44:26 -0500
Received: from buffy.scoobygang ([192.168.158.102])
	by pond-weed.com with esmtps (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <john@pond-weed.com>)
	id 1RhL18-0006c9-52
	for linux-wireless@vger.kernel.org; Sun, 01 Jan 2012 13:00:02 +0000
Date: Sun, 1 Jan 2012 13:00:00 +0000
From: John Williams <john@pond-weed.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [Question] Realtek USB 0bda:8176 as AP?
Message-ID: <20120101130000.57429e74@buffy.scoobygang> (sfid-20120101_144430_579737_43300AEA)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello list,

I see there was a discussion on this list about three months ago about
using an RTL8192CU (usb 0bda:8176) in access point mode. I've just
bought one and I've got the same problem: hostapd just prints this in a
loop until it gives up:

WPA: 00:24:23:0c:9c:2f WPA_PTK entering state PTKSTART
wlan0: STA 00:24:23:0c:9c:2f WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8
  kde_len=0 keyidx=0 encr=0) 
IEEE 802.1X: 00:24:23:0c:9c:2f TX status -version=2 type=3 
  length=95 - ack=1 
wlan0: STA 00:24:23:0c:9c:2f
WPA: EAPOL-Key timeout

This is with the driver from compat_wireless as of 2011-12-29.

It works fine with the driver downloaded from the realtek website
(provided that I also use their patched version of hostapd), so it's
not a hardware problem.

If anyone could point me to the area in the driver where it is supposed
to receive the missing message, I would be happy to have a go at
debugging it.

Regards,
John Williams
