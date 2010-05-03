Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:57003 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759141Ab0ECNK3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 09:10:29 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1O8vPo-0008RN-02
	for linux-wireless@vger.kernel.org; Mon, 03 May 2010 15:10:28 +0200
Received: from proxyext.iabg.de ([proxyext.iabg.de])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 03 May 2010 15:10:27 +0200
Received: from pommnitz by proxyext.iabg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 03 May 2010 15:10:27 +0200
To: linux-wireless@vger.kernel.org
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: [PATCH] mac80211: improve IBSS scanning
Date: Mon, 3 May 2010 13:10:19 +0000 (UTC)
Message-ID: <loom.20100503T150104-147@post.gmane.org>
References: <1272869388.3614.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@...> writes:
> Note that this can be further improved to start
> the IBSS right away if both frequency and BSSID
> are fixed.

Doing this and switching off beaconing would be the same as
the infamous AH-Demo mode supported by Madwifi and creeping
into the current kernel, no?

see http://madwifi-project.org/wiki/UserDocs/AhdemoInterface
and HTC_M_AHDEMO in enum htc_opmode.

For me, AH-Demo is required to ditch Madwifi, so are you still
opposed to its integration? It seems that the pieces of the
puzzle are almost there now.

Regards
  Joerg

