Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45755 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab2F1Lpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 07:45:47 -0400
Message-ID: <1340883944.4491.43.camel@jlt3.sipsolutions.net> (sfid-20120628_134551_290382_EA7D38BE)
Subject: Re: [PATCH] respect channels in iface combinations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 28 Jun 2012 13:45:44 +0200
In-Reply-To: <4FEC42D9.5040605@tieto.com>
References: <1340878025-2695-1-git-send-email-michal.kazior@tieto.com>
	  <1340879319.4491.38.camel@jlt3.sipsolutions.net>
	  <4FEC3BEC.2070906@tieto.com>
	 <1340882283.4491.42.camel@jlt3.sipsolutions.net>
	 <4FEC42D9.5040605@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-28 at 13:41 +0200, Michal Kazior wrote:

> >> This is strange. I did develop it with the start_ap patches (my base is
> >> master-2012-06-14 on wireless-next). I may be missing a few from your
> >> mac80211 repo though.
> >
> > Yeah I thought you had. I know what happened - you don't have the "pass
> > channel" patches. Could you check & rebase?
> 
> Yeah. The conflict on preset_chan is because I'm missing Felix's patch 
> ,,cfg80211: fix regression in multi-vif AP start''.
> 
> On the other hand I've had a conflict on my ,,cfg80211: respect iface 
> combinations when starting operation'' while rebasing to mac80211-next. 
> mac80211-next is missing my earlier patch ,,cfg80211: check iface 
> combinations only when iface is running'' which is already in wireless-next.

Ah, that's because that patch went through mac80211.git. I'll merge
wireless-next.git into mac80211-next.git to give you a better base.

johannes

