Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:49910 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbYGFSGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2008 14:06:20 -0400
Received: by fg-out-1718.google.com with SMTP id 19so708111fgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2008 11:06:18 -0700 (PDT)
Message-ID: <30353c3d0807061106x78e796f4r95f2ce7e56a4bb5c@mail.gmail.com> (sfid-20080706_200625_429649_A608F745)
Date: Sun, 6 Jul 2008 14:06:18 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: b43legacy: local packet loss
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While using the latest b43legacy driver, I have severe packet loss
originating from the machine using the b43legacy driver. However, when
packets are routed through the machine using NAT, no packet loss
occurs. Ping results are as follows:

using 'ping -c 100 192.168.1.1'

>From local machine (192.168.1.100) to wireless router (192.168.1.1)
    43% packet loss, average rtt 13.987ms

>From nat machine(192.168.2.100) to wireless router (192.168.1.1) via
b43legacy router(eth0:192.168.2.1, wlan0:192.168.1.100)
    0% packet loss, average rtt 3.621ms

The only logical conclusion I can draw from the above information is
that there is something wrong with how packets are created locally and
delivered to the device. I'm willing to provide any help necessary
needed to correct the issue.

Regards,

David Ellingsworth
