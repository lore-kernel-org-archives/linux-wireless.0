Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:57902 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174Ab1FXNtV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 09:49:21 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Qa6l6-0006Ul-Fl
	for linux-wireless@vger.kernel.org; Fri, 24 Jun 2011 15:49:20 +0200
Received: from proxyext.iabg.de ([proxyext.iabg.de])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jun 2011 15:49:20 +0200
Received: from pommnitz by proxyext.iabg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jun 2011 15:49:20 +0200
To: linux-wireless@vger.kernel.org
From: jpo <pommnitz@yahoo.com>
Subject: Restricting a interface to 802.11b features
Date: Fri, 24 Jun 2011 13:49:09 +0000 (UTC)
Message-ID: <loom.20110624T154421-95@post.gmane.org> (sfid-20110624_154924_968686_8D67A1D0)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,
is there a way to restrict an interface to the 802.11b feature set? I know I can
restrict the data rates, but this still leaves the capability information in the
IBSS beacons to indicate enhancements from the later standards. So, is there a
way to say: this interface must behave as if it were only 802.11b compatible
even if the underlying hardware supports more?

Regards
  Joerg

