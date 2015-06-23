Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37556 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbbFWJMR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2015 05:12:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Z7KFb-0004wZ-Jy
	for linux-wireless@vger.kernel.org; Tue, 23 Jun 2015 11:12:15 +0200
Received: from proxyext.iabg.de ([proxyext.iabg.de])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jun 2015 11:12:10 +0200
Received: from pommnitz by proxyext.iabg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jun 2015 11:12:10 +0200
To: linux-wireless@vger.kernel.org
From: Joerg <pommnitz@yahoo.com>
Subject: Runtime configuration of multicast datarate with nl80211/mac80211
Date: Tue, 23 Jun 2015 09:12:00 +0000 (UTC)
Message-ID: <loom.20150623T110608-595@post.gmane.org> (sfid-20150623_111220_624704_C70C6156)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,
I'm looking for a way to configure the multicast datarate of a 802.11 client
(e.g. STA mode) and an AP.
The iw command (I have 3.4) allows to specify a multicast datarate on IBSS
and MESH joins, but there doesn't seem to be an option that allows the
setting of the multicast datarate in a way similar to the unicast datarate.

Am I missing something or is this simply not supported?

Regards
  Joerg

