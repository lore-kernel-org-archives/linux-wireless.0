Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ore.jhcloos.com ([198.147.22.87]:40890 "EHLO ore.jhcloos.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752580AbcJ3Wda (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Oct 2016 18:33:30 -0400
From: James Cloos <cloos@jhcloos.com>
To: linux-wireless@vger.kernel.org
Subject: Backwards 11ac 
Date: Sun, 30 Oct 2016 16:50:35 -0400
Message-ID: <m3oa21ftno.fsf@carbon.jhcloos.org> (sfid-20161030_233931_971020_29939274)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I recently received my turris omnia and put it into operation yesterday.

(It is only doing wireless; I have a different box for my main router.)

All of the machines on the wlan show backwards transfer speeds; they
upload reasonable fast but downloads are in the kbit/s range.

That applies to the both the 11ac-capable machines and the 11n-on-2.4
machines.

Luci's status/overview page shows 'Bitrate: 6 Mbit/s' for the ath10k and
'Bitrate: 61.5 Mbit/s' for the ath9k.

(The two wireless cards in it are:

01:00.0 Network controller: Qualcomm Atheros AR9287 Wireless Network Adapter (PCI-Express) (rev 01)
02:00.0 Network controller: Qualcomm Atheros QCA986x/988x 802.11ac Wireless Network Adapter
)

Googling has not helped me figure out how to get propper bandwidth.
All of the search results were about wan links, not about wlan links.

What should I look at to diagnose this?

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 0x997A9F17ED7DAEA6
