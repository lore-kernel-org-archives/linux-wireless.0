Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34999 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab2BFSll (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 13:41:41 -0500
Received: by ggnh1 with SMTP id h1so2964400ggn.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2012 10:41:41 -0800 (PST)
MIME-Version: 1.0
From: Pedro Francisco <pedrogfrancisco@gmail.com>
Date: Mon, 6 Feb 2012 18:41:21 +0000
Message-ID: <CAJZjf_y_fSYv0U8y8APLJAvWe=xKWpa_poLc9h7qjQuRSj_rGw@mail.gmail.com> (sfid-20120206_194145_522108_67FB340C)
Subject: iwl3945: WPA2+swcrypto=0: receives broadcast only
To: linux-wireless@vger.kernel.org
Cc: ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!
When I connect to a WPA2 AP with swcrypto=0 I get the following kinds
of traffic:
ARP (Broadcast)
DHCP (255.255.255.255)
IGMP (224.0.0.22 and 224.0.0.1)

If I do a normal DHCP, I get no response. If I do "dhclient -B",
requesting BOOTP broadcast flag, I get an IP, as expected. However ARP
requests go unresponded as expected.

The closest I've found relative to this is
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=1872 . It is
however reported as fixed on *both* "software/hardware crypto with
WPA2 PSK and EAP" (2009-01-06).

It seems curious I can receive broadcast traffic but not traffic specific to me.
I'd present the debug of iwl3945 but apparently that option was
removed from iwl3945 module?

Thanks in Advance,
-- 
Pedro F.
