Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:52461 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbYA3QPa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2008 11:15:30 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: should we revert the cfg80211 API patches?
Date: Wed, 30 Jan 2008 17:13:15 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>
References: <1201708352.4149.21.camel@johannes.berg>
In-Reply-To: <1201708352.4149.21.camel@johannes.berg>
MIME-Version: 1.0
Message-Id: <200801301713.15962.mb@bu3sch.de> (sfid-20080130_161535_396697_C2B583A8)
Content-Type: text/plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 30 January 2008 16:52:31 Johannes Berg wrote:
> John,
> 
> It appears that there's more trouble caused by my cfg80211 band API
> patch than people are willing to put up with. Tomas has already asked
> for it to be reverted, and neither Michael (Buesch) nor Stefano want to
> maintain two driver branches (one "stable" 2.6.25 branch and one
> "development" "for the future" branch).

No wait. I always supported that and will support that in the future.

But the problem I see with not merging this patch is that I think
it is _just_ wasted time in the end. If we simply merge it now we
can easily fix bugs in the huge merge window.
If we don't merge it, we are creating a branch of the driver. So
far no problem, really. But, if a bug appears that has to be fixed
differently for the old API and the new API, I'm not going to make
two patches. Simply because this could have beed avoided as a whole
by simply merging that patch _now_. I wish I had unlimited time to
port patches back. But I simply don't. So I am going to port patches
back that are needed, but not those for which we artificially created
the problems.

To say it again. I do support the concept of "stable" and "development"
branches. But I do not support artificial branching that is not needed
at all and can easily be avoided by simply applying that patch.

Just my 2ct.

-- 
Greetings Michael.
