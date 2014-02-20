Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783AbaBTIPJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 03:15:09 -0500
Date: Thu, 20 Feb 2014 09:17:32 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: protect skb_queue_len(&ps->bc_buf) by lock
Message-ID: <20140220081732.GB23439@redhat.com> (sfid-20140220_091520_462750_B21CAA65)
References: <1392812916-13656-1-git-send-email-sgruszka@redhat.com>
 <1392812916-13656-2-git-send-email-sgruszka@redhat.com>
 <1392815649.4733.23.camel@jlt4.sipsolutions.net>
 <20140219133546.GE1851@redhat.com>
 <1392821503.4733.26.camel@jlt4.sipsolutions.net>
 <20140219150937.GH1851@redhat.com>
 <1392827818.4733.27.camel@jlt4.sipsolutions.net>
 <20140220075639.GA23439@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140220075639.GA23439@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 20, 2014 at 08:56:39AM +0100, Stanislaw Gruszka wrote:
> On Wed, Feb 19, 2014 at 05:36:58PM +0100, Johannes Berg wrote:
> > Well, OK, so there's some small window of time where the drop code isn't
> > perfect. Does it matter? I'd argue it doesn't - if you're getting close
> > to the drop case then the client is probably misbehaving anyway.
> 
> Ok, let drop those patches. Do you want me to repost first patch with
> just if(old) check to fix kaboom, or you prefer to problem be solved
> properly at once ?

Nevermind, I just saw Emmanuel posted proper patch.

Stanislaw
