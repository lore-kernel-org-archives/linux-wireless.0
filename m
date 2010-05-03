Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:41899 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759106Ab0ECOIX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 10:08:23 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1O8wJq-0004wF-Sq
	for linux-wireless@vger.kernel.org; Mon, 03 May 2010 16:08:22 +0200
Received: from proxyext.iabg.de ([proxyext.iabg.de])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 03 May 2010 16:08:22 +0200
Received: from pommnitz by proxyext.iabg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 03 May 2010 16:08:22 +0200
To: linux-wireless@vger.kernel.org
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: [PATCH] mac80211: improve IBSS scanning
Date: Mon, 3 May 2010 14:08:13 +0000 (UTC)
Message-ID: <loom.20100503T160346-724@post.gmane.org>
References: <469051.90774.qm@web51402.mail.re2.yahoo.com>  <1272893084.3614.37.camel@jlt3.sipsolutions.net>  <loom.20100503T153803-630@post.gmane.org>  <loom.20100503T154149-617@post.gmane.org> <1272895062.3614.39.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@...> writes:
> 
> Interesting. I guess we never rejected it although it's invalid
> according to the standard. Yuck. I think I would like to make nl80211
> reject it, but maybe I'll forget about it and let you use it ;)

Sorry, I don't know about mac80211. This was more a general point.
I thought this woudn't work at all but a co-worker was adamant that
it works fine with Madwifi. So I sat down and observed it with
a monitoring interface and lo and behold: The beacons really contained
the broadcast SSID.

