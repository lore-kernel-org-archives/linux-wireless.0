Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48922 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbcDSJKW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 05:10:22 -0400
Message-ID: <1461057018.2766.14.camel@sipsolutions.net> (sfid-20160419_111028_030440_555FD6DF)
Subject: Re: [Codel] [PATCHv3 2/5] mac80211: implement fair queueing per txq
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>,
	Eric Dumazet <eric.dumazet@gmail.com>
Cc: make-wifi-fast@lists.bufferbloat.net,
	linux-wireless <linux-wireless@vger.kernel.org>,
	codel@lists.bufferbloat.net, Avery Pennarun <apenwarr@gmail.com>
Date: Tue, 19 Apr 2016 11:10:18 +0200
In-Reply-To: <CA+BoTQkSj788jcdB78XdeXTZdCGoCAKedpg0XnK7bjtuqaAWMA@mail.gmail.com> (sfid-20160418_153625_392021_99464B1E)
References: <1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
	 <1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
	 <1460636302-31161-3-git-send-email-michal.kazior@tieto.com>
	 <1460845384.2075.27.camel@sipsolutions.net>
	 <1460845552.2075.28.camel@sipsolutions.net>
	 <CA+BoTQmuTAjR-cSuJmsAm5Ms3sTrtPT8HxE_tYf1EGOMGeHVcw@mail.gmail.com>
	 <1460982672.10638.111.camel@edumazet-glaptop3.roam.corp.google.com>
	 <CA+BoTQkSj788jcdB78XdeXTZdCGoCAKedpg0XnK7bjtuqaAWMA@mail.gmail.com>
	 (sfid-20160418_153625_392021_99464B1E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-04-18 at 15:36 +0200, Michal Kazior wrote:

> FWIW cfg80211 drivers might become another user of the fq/codel stuff
> in the future.
> 
> Arguably I should make include/net/codel.h not be qdisc specific as
> it is now (and hence re-usable by mac80211) and submit fq.h to
> include/net/. Would that be better (it'll probably take a lot longer
> to propagate over trees, no?)

I think it would be better, and we could sync and take it through my
tree, or I can sync and just pull back davem's tree once it's there; I
don't think code "management" wise it'll be an issue.

> johannes
