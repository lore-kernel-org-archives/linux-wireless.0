Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:32792 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932773Ab3EGOMa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 10:12:30 -0400
Received: by mail-ie0-f172.google.com with SMTP id 16so1025136iea.31
        for <linux-wireless@vger.kernel.org>; Tue, 07 May 2013 07:12:29 -0700 (PDT)
Date: Tue, 7 May 2013 10:11:15 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Subject: Re: [RFC 03/12] mac80211: use all MBSS interfaces for path
 selection
Message-ID: <20130507141115.GE1438@localhost> (sfid-20130507_161240_027510_98113C68)
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
 <1367548442-8229-4-git-send-email-thomas@cozybit.com>
 <1367934045.8328.20.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1367934045.8328.20.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 07, 2013 at 03:40:45PM +0200, Johannes Berg wrote:
> >  /**
> > + * mesh_nexthop_lookup - put the appropriate next hop on a mesh frame and
> > + * insert the correct outgoing interface on the skb cb. Calling this function
> > + * is considered "using" the associated mpath, so preempt a path refresh if
> > + * this mpath expires soon.
> 
> This is of course completely bogus kernel-doc :)

Ack, thanks.

-- 
Bob Copeland %% www.bobcopeland.com
