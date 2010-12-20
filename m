Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kso.tls-tautenburg.de ([194.94.209.8]:8179 "EHLO
	kso.tls-tautenburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab0LTK2O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 05:28:14 -0500
Received: from localhost (localhost [127.0.0.1])
	by kso.tls-tautenburg.de (Postfix) with ESMTP id 8FBF95064E
	for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 11:28:12 +0100 (CET)
Received: from kso.tls-tautenburg.de ([127.0.0.1])
	by localhost (kso.tls-tautenburg.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tWNYivZNBVms for <linux-wireless@vger.kernel.org>;
	Mon, 20 Dec 2010 11:28:07 +0100 (CET)
Received: from [192.168.178.37] (i5E86DE2F.versanet.de [94.134.222.47])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by kso.tls-tautenburg.de (Postfix) with ESMTP
	for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 11:28:07 +0100 (CET)
Message-ID: <4D0F2FB6.9060701@tls-tautenburg.de>
Date: Mon, 20 Dec 2010 11:28:06 +0100
From: Bringfried Stecklum <stecklum@tls-tautenburg.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Failing on timeout while stopping DMA channel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since updating the kernel to 2.6.36.1, I am getting "Failing on timeout while 
stopping DMA channel" messages during suspend/hibernate. They seem to harmless 
but I'd like to get rid of them. This is the dmesg part

Dec 20 11:01:26 extragalactix kernel: [96861.854138] wlan0: deauthenticating 
from 00:15:0c:be:e3:d0 by local choice (reason=3)
Dec 20 11:01:26 extragalactix kernel: [96861.900288] cfg80211: Calling CRDA to 
update world regulatory domain
Dec 20 11:01:26 extragalactix dhcpcd[2468]: wlan0: carrier lost
Dec 20 11:01:26 extragalactix kernel: [96862.006292] iwlagn 0000:0c:00.0: 
Failing on timeout while stopping DMA channel 1 [0xa5a5a5a2]
Dec 20 11:01:26 extragalactix kernel: [96862.006292] iwlagn 0000:0c:00.0: 
Failing on timeout while stopping DMA channel 3 [0xa5a5a5a2]
Dec 20 11:01:26 extragalactix kernel: [96862.006292] iwlagn 0000:0c:00.0: 
Failing on timeout while stopping DMA channel 4 [0xa5a5a5a2]
Dec 20 11:01:26 extragalactix kernel: [96862.006292] iwlagn 0000:0c:00.0: 
Failing on timeout while stopping DMA channel 6 [0xa5a5a5a2]
Dec 20 11:01:26 extragalactix kernel: [96862.151195] iwlagn 0000:0c:00.0: PCI 
INT A disabled
Dec 20 11:01:26 extragalactix dhcpcd[2468]: wlan0: del_route: No such device
Dec 20 11:01:26 extragalactix dhcpcd[2468]: del_address: No such device
Dec 20 11:01:26 extragalactix dhcpcd[2468]: manage_link: No such device or address
Dec 20 11:01:26 extragalactix dhcpcd[2468]: wlan0: removing interface
Dec 20 11:01:28 extragalactix dhcpcd[5849]: dhcpcd not running
Dec 20 11:01:28 extragalactix kernel: [96864.320479] tg3 0000:09:00.0: irq 41 
for MSI/MSI-X
Dec 20 11:01:28 extragalactix dhcpcd[5854]: dhcpcd not running
Dec 20 11:01:28 extragalactix kernel: [96864.480575] tg3 0000:09:00.0: irq 41 
for MSI/MSI-X
Dec 20 11:02:34 extragalactix acpid: client 4558[0:0] has disconnected
Dec 20 11:02:35 extragalactix kernel: [96865.301314] PM: Syncing filesystems ... 
done.
Dec 20 11:02:35 extragalactix kernel: [96865.309300] Freezing user space 
processes ... (elapsed 0.01 seconds) done.
