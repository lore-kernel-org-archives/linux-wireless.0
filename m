Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36464 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751877AbdLKUvl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 15:51:41 -0500
Received: by mail-wm0-f42.google.com with SMTP id b76so16697464wmg.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 Dec 2017 12:51:41 -0800 (PST)
Date: Mon, 11 Dec 2017 21:51:29 +0100 (CET)
From: Enrico Mioso <mrkiko.rs@gmail.com>
To: linux-wireless@vger.kernel.org
cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        nbd@nbd.name
Subject: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame
 due to full tx queue...?
Message-ID: <alpine.LNX.2.21.99.1712112132480.7817@localhost.localdomain> (sfid-20171211_215147_316465_64327477)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello guys, and sorry for the big CC list.
I would like to point out about a bug who survived for years - at least from 2015 until now, regarding the Ralink driver getting stuck, and in some cases not being able to recover.
The problem manifested with an MT7620A chip, and the wireless card inside the WL-330N3G device.
The error message is in rt2x00/rt2x00queue.c .

This bug was discussed, and a patch proposed, in this thread:
https://lists.openwrt.org/pipermail/openwrt-devel/2015-September/thread.html#35778

I would like to help if possible - I have the have both an Archer MR200, and the WL330n3G hardware.
BTW, the Archer MR200 is a nice MT7610 device, and the problem manifests itself, see:
https://forum.openwrt.org/viewtopic.php?id=64293&p=6

Any help, hint, anything would be apreciated.
thank you to all.

Enrico
