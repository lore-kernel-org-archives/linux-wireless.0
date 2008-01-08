Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:48378 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752568AbYAHStz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2008 13:49:55 -0500
From: David Brownell <david-b@pacbell.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 6/8] [PATCH] Split up rndis_host.c
Date: Tue, 8 Jan 2008 10:49:49 -0800
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, bjd@jooz.net,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
References: <11983602942818-git-send-email-bjd@jooz.net> <200801080319.23299.david-b@pacbell.net> <1199813561.6762.13.camel@johannes.berg>
In-Reply-To: <1199813561.6762.13.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801081049.49764.david-b@pacbell.net> (sfid-20080108_185004_195160_61AAF97A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 08 January 2008, Johannes Berg wrote:
> 
> > I see that the rndis_wext.c Kconfig won't kick in unless the
> > 802.11 stuff is available ... what additional dependencies
> > does that imply for a fatter rndis_host module?
> 
> No extra modules are currently required for just plain wext [1]. In the
> future, we hope to migrate stuff to cfg80211 though, which is a separate
> module.

Hmmm.  Well, go the current route then ... but come up with a good
plan to split it up later, so that connecting a typical non-wireless
RNDIS device won't incur such needless extra modules.

- Dave


> johannes
> 
> [1] mostly because all the code is simply compiled into the kernel...
> 


