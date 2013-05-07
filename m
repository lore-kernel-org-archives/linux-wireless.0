Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54361 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575Ab3EGNkt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 09:40:49 -0400
Message-ID: <1367934045.8328.20.camel@jlt4.sipsolutions.net> (sfid-20130507_161636_391573_E690763C)
Subject: Re: [RFC 03/12] mac80211: use all MBSS interfaces for path selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>, me@bobcopeland.com,
	open80211s <devel@lists.open80211s.org>
Date: Tue, 07 May 2013 15:40:45 +0200
In-Reply-To: <1367548442-8229-4-git-send-email-thomas@cozybit.com> (sfid-20130503_043618_332593_B0A4ABED)
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
	 <1367548442-8229-4-git-send-email-thomas@cozybit.com>
	 (sfid-20130503_043618_332593_B0A4ABED)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-05-02 at 19:33 -0700, Thomas Pedersen wrote:

>  /**
> - * mesh_nexthop_lookup - put the appropriate next hop on a mesh frame. Calling
> - * this function is considered "using" the associated mpath, so preempt a path
> - * refresh if this mpath expires soon.
> + * mesh_nexthop_lookup - put the appropriate next hop on a mesh frame and
> + * insert the correct outgoing interface on the skb cb. Calling this function
> + * is considered "using" the associated mpath, so preempt a path refresh if
> + * this mpath expires soon.

This is of course completely bogus kernel-doc :)

johannes

