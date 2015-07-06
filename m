Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv.colino.net ([212.83.157.151]:54047 "EHLO mx.colino.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbbGFSrd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2015 14:47:33 -0400
Received: from net24.it (unknown [151.50.212.211])
	by mx.colino.net (Postfix) with ESMTPSA id 89DC336A431D
	for <linux-wireless@vger.kernel.org>; Mon,  6 Jul 2015 20:38:07 +0200 (CEST)
Date: Mon, 6 Jul 2015 20:37:38 +0200
From: Salvatore De Paolis <iwkse@claws-mail.org>
To: linux-wireless@vger.kernel.org
Subject: Problem with firmware, rt2x00
Message-ID: <20150706203738.6fe7c3ea@net24.it> (sfid-20150706_204737_974931_CFC9CBC0)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

after updating the kernel and udev plus other packages I am not able anymore to let my PCI wireless card
works.

The device is listed as RT2561/RT61 (no rev. B)

After the update when issuing a "up" I get an error like: rt61pci agent aborted rt2561s (not found?)

I have the firmware-ralink and such file is available in /lib/firmware

Monitoring the udev event I can see the action "add" is followed by a "remove".

on my udev rule, 50-firmware.rules I have:

SUBSYSTEM=="firmware" , ACTION=="add", ATTR{loading}="-1"

Anyone has a clue about what could I do to fix this issue?

Best regards,

-- 
Salvatore
