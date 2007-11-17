Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:14930 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbXKQBdb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 20:33:31 -0500
Received: by py-out-1112.google.com with SMTP id u77so4541465pyb
        for <linux-wireless@vger.kernel.org>; Fri, 16 Nov 2007 17:33:30 -0800 (PST)
Message-ID: <43e72e890711161733o72b557ccs63fa1c0104bc656a@mail.gmail.com> (sfid-20071117_013334_358466_88D83698)
Date: Fri, 16 Nov 2007 20:33:29 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: libertas-dev@lists.infradead.org
Subject: 88w8335 [Libertas] 802.11b/g
Cc: wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Someone gave an old Marvell card, it seems to be libertas:

Ethernet controller: Marvell Technology Group Ltd. 88w8335 [Libertas]
802.11b/g Wireless (rev 03)

vendor:device -- 11ab:1faa

libertas_cs isn't picking up though. I found a net80211 linux based
driver which does have it though. I haven't touched this hardware
until now. How different are they? Anyone already working on the
net80211 driver port to mac80211?

The topdog needs a port too but that's different.

   Luis
