Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:34915 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbYCFSWN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 13:22:13 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: handling Qdisc issues
Date: Thu, 6 Mar 2008 19:21:39 +0100
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com
References: <1204822307-5111-1-git-send-email-ron.rindjunsky@intel.com> <200803061830.32316.mb@bu3sch.de> <1204825369.25502.125.camel@johannes.berg>
In-Reply-To: <1204825369.25502.125.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803061921.39868.mb@bu3sch.de> (sfid-20080306_182220_019149_446699FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 06 March 2008 18:42:49 Johannes Berg wrote:
> 
> > > That's my old patch, I think Ron doesn't know anything about b43 :) And
> > > my patch was based before your QoS support patches.
> > 
> > Ah ok. You can just add this #ifdef to the already existing
> > dynamic condition on b43_modparam_qos in the new queue mapping function.
> 
> Yeah, but I wish we didn't actually need the #ifdef in all drivers.
> Since CONFIG_NETDEVICES_MULTIQUEUE is dirt cheap I think we should just
> make mac80211 depend on it, I think we'll end up requiring
> CONFIG_NET_SCHED too.

ack

-- 
Greetings Michael.
