Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38422 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932672Ab0KLQoD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 11:44:03 -0500
Subject: Re: ath5k/mac80211:  Reproducible deadlock with 64-stations.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Tejun Heo <tj@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CDD6C39.9070400@candelatech.com>
References: <4CDB2488.4040802@candelatech.com>
	 <1289437356.3748.25.camel@jlt3.sipsolutions.net>
	 <4CDBB716.7020802@kernel.org> <4CDC2016.8020200@candelatech.com>
	 <4CDC8EED.60602@candelatech.com>
	 <1289529427.3695.9.camel@jlt3.sipsolutions.net>
	 <4CDD6C39.9070400@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 08:45:23 -0800
Message-ID: <1289580323.3736.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-11-12 at 08:32 -0800, Ben Greear wrote:

> There is a warning early in the boot from lockdep, not related to wifi.
> I fear that is disabling all further lockdep warnings.

That is indeed true -- try to get rid of it. But even so, nobody else is
seeing lockdep warnings afaik, so ...

johannes

