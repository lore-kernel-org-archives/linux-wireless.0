Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:35648 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab1FXKi0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 06:38:26 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Qa3mK-0002r9-M1
	for linux-wireless@vger.kernel.org; Fri, 24 Jun 2011 12:38:24 +0200
Received: from proxyext.iabg.de ([proxyext.iabg.de])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jun 2011 12:38:24 +0200
Received: from pommnitz by proxyext.iabg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jun 2011 12:38:24 +0200
To: linux-wireless@vger.kernel.org
From: jpo <pommnitz@yahoo.com>
Subject: Configuring the multicast data rate with iw/nl80211
Date: Fri, 24 Jun 2011 10:38:06 +0000 (UTC)
Message-ID: <loom.20110624T123237-71@post.gmane.org> (sfid-20110624_123830_578948_CB98BCB4)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,
I know that it is now possible to configure the data rate bitmask that the RC
algorithm uses to select data rates for individual peer nodes. However, I could
not figure out, how to specifically assign a broadcast/multicast data rate. Is
this supported? If so, how?

The scenario I'm facing is that I'm perfectly happy to let the RC figure out the
best data rate for the peer nodes up to the supported maximum. However, I need
to multicast video streams as well. For this I have to balance the required data
rate with the distance I can achieve. 

Kind regards
  Joerg

