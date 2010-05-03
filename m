Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:56429 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022Ab0ECNpE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 09:45:04 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1O8vxH-0001Vn-FC
	for linux-wireless@vger.kernel.org; Mon, 03 May 2010 15:45:03 +0200
Received: from proxyext.iabg.de ([proxyext.iabg.de])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 03 May 2010 15:45:03 +0200
Received: from pommnitz by proxyext.iabg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 03 May 2010 15:45:03 +0200
To: linux-wireless@vger.kernel.org
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: [PATCH] mac80211: improve IBSS scanning
Date: Mon, 3 May 2010 13:43:03 +0000 (UTC)
Message-ID: <loom.20100503T154149-617@post.gmane.org>
References: <469051.90774.qm@web51402.mail.re2.yahoo.com> <1272893084.3614.37.camel@jlt3.sipsolutions.net> <loom.20100503T153803-630@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@...> writes:
> Hidden SSID is a hack (which doesn't work with IBSS obviously), but this
> kinda seems worse.
 
Actually, it does (work on IBSS, that is). And because I thought what you think
I have the
radiotap traces to prove it. 




