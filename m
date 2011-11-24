Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50508 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab1KXUhf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 15:37:35 -0500
Subject: Re: [PATCH v10 2/2] mac80211:  Support ht-cap over-rides.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4ECE9825.8070208@candelatech.com>
References: <1321644720-8245-1-git-send-email-greearb@candelatech.com>
	 <1321644720-8245-2-git-send-email-greearb@candelatech.com>
	 (sfid-20111118_203218_329178_9FB3658A) <1321648257.10266.77.camel@jlt3.sipsolutions.net>
	 <4EC6C36D.4070900@candelatech.com>
	 <1322142597.5366.19.camel@jlt3.sipsolutions.net>
	 <4ECE9825.8070208@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Nov 2011 21:37:32 +0100
Message-ID: <1322167052.5366.56.camel@jlt3.sipsolutions.net> (sfid-20111124_213740_423470_6EE6AA27)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-24 at 11:16 -0800, Ben Greear wrote:
> On 11/24/2011 05:49 AM, Johannes Berg wrote:
> > Please fix:
> >
> > net/mac80211/ht.c:31:6: warning: symbol '__check_htcap_disable' was not
> > declared. Should it be static?
> 
> I sent a patch to make this static, but I do not see the warning.  Are you
> running something other than a standard 'make bzImage modules' to
> see this warning?

Yes, this is a sparse warning, make C=1 or C=2

johannes

