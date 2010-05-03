Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:35196 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455Ab0ECNkq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 09:40:46 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1O8vt6-0007fi-5a
	for linux-wireless@vger.kernel.org; Mon, 03 May 2010 15:40:44 +0200
Received: from proxyext.iabg.de ([proxyext.iabg.de])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 03 May 2010 15:40:44 +0200
Received: from pommnitz by proxyext.iabg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 03 May 2010 15:40:44 +0200
To: linux-wireless@vger.kernel.org
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: [PATCH] mac80211: improve IBSS scanning
Date: Mon, 3 May 2010 13:40:36 +0000 (UTC)
Message-ID: <loom.20100503T153803-630@post.gmane.org>
References: <469051.90774.qm@web51402.mail.re2.yahoo.com> <1272893084.3614.37.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@...> writes:
> Hidden SSID is a hack (which doesn't work with IBSS obviously), but this
> kinda seems worse.

Actually, it does. And because I thought what you think I have the
radiotap traces to prove it. :-)

> Seriously though, why should the upstream kernel support such bad design
> decisions...? :)

Well, because this topic comes up every few months. It seems there
are other people who are attached to AH-demo for their very own reasons.

Regards
  Joerg

