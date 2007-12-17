Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37841 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1763797AbXLQJ4R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 04:56:17 -0500
Subject: Re: [patch 4/9] mac80211: Make PID rate control algorithm the
	default
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stefano Brivio <stefano.brivio@polimi.it>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1197853758.4885.4.camel@johannes.berg>
References: <20071217001956.640555983@gmx.de>
	 <20071217002056.351743954@gmx.de> <1197852547.4885.1.camel@johannes.berg>
	 <20071217015004.2400ab33@morte> <1197852873.4885.2.camel@johannes.berg>
	 <20071217015748.5bb3f7fc@morte>  <1197853758.4885.4.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 10:56:14 +0100
Message-Id: <1197885374.7514.6.camel@localhost> (sfid-20071217_095619_209413_B61EEF0A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2007-12-17 at 02:09 +0100, Johannes Berg wrote:
> > That was my original proposal, but during a recent discussion John
> > suggested not to remove rc80211-simple right now, as it's currently
> > almost working for a lot of people. John, any suggestions?
> 
> Those people can fix the bitrate at 1M if the pid algorithm becomes
> problematic, that's what simple currently does in practice.

Agreed. So what flavour of this patch do you want? John?

Mattias

