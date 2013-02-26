Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47896 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402Ab3BZVsV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 16:48:21 -0500
Message-ID: <1361915289.8440.29.camel@jlt4.sipsolutions.net> (sfid-20130226_224824_524805_2E1BF10A)
Subject: Re: [PATCH v2 1/2] mac80211:  Stop timers before canceling work
 items.
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Tue, 26 Feb 2013 22:48:09 +0100
In-Reply-To: <20130226160258.GB5256@redhat.com> (sfid-20130226_170252_769794_41DE784C)
References: <1361382069-31729-1-git-send-email-greearb@candelatech.com>
	 <20130226160258.GB5256@redhat.com> (sfid-20130226_170252_769794_41DE784C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-26 at 17:02 +0100, Stanislaw Gruszka wrote:
> On Wed, Feb 20, 2013 at 09:41:08AM -0800, greearb@candelatech.com wrote:
> > From: Ben Greear <greearb@candelatech.com>
> > 
> > Re-order the quiesce code so that timers are
> > always stopped before work-items are flushed.  This was
> > not the problem I saw, but I think it may still be more
> > correct.
> 
> I posted patch which remove quiesce functions, so this one
> can be skipped.

Since I'm not going to apply your patches for 3.8, I still took this.

johannes

