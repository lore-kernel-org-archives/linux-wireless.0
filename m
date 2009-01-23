Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:18742 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbZAWBHh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 20:07:37 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2355496fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 17:07:34 -0800 (PST)
Subject: [BUG] latest wireless-testing (compat-wireless) doesn't work with
 iwl3945
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 03:07:30 +0200
Message-Id: <1232672850.7913.6.camel@maxim-laptop> (sfid-20090123_020741_280830_B868CB38)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I currently use 2.6.28, and don't yet want to switch to 2.6.29-rc, so I
installed vanilla 2.6.28, and compat-wireless of today on top of it
only options I changed, were I enabled rfkill in iwl3945 and crda, which
I did install.

device doesn't associate with my AP (even in open mode)

nothing suspicions in logs, just says it did associate and then it
dropped.

btw, in last versions of iwwifi.git I noticed that hardware encryption
doesn't work anymore, so I enabled swcrypto, now nether it works

Best regards,
	Maxim Levitsky

