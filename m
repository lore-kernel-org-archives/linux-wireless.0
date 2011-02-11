Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:54731 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584Ab1BKPjT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Feb 2011 10:39:19 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Pnv5Z-0002np-HO
	for linux-wireless@vger.kernel.org; Fri, 11 Feb 2011 16:39:17 +0100
Received: from proxyext.iabg.de ([proxyext.iabg.de])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 11 Feb 2011 16:39:17 +0100
Received: from pommnitz by proxyext.iabg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 11 Feb 2011 16:39:17 +0100
To: linux-wireless@vger.kernel.org
From: jpo234 <pommnitz@yahoo.com>
Subject: WPA for Ethernet?
Date: Fri, 11 Feb 2011 15:39:03 +0000 (UTC)
Message-ID: <loom.20110211T163104-102@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,
is it possible to use the mac80211 (software) encryption infrastructure to
encrypt data over non 802.11 interfaces? If not, how hard would this be?

IPsec and other VPN solutions are "tunnel centric" instead of "interface
centric". I'm looking for a way to say "All inbound and outbound traffic through
this interface must be encrypted with the following key.", just like WPA-PSK.

Regards
  Joerg

