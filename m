Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46850 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab3CES7X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 13:59:23 -0500
Message-ID: <1362509959.638.0.camel@jlt4.sipsolutions.net> (sfid-20130305_195925_908082_445F8ED2)
Subject: Re: [PATCH 6/6] mac80211: init mesh timer for user authed STAs
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Tue, 05 Mar 2013 19:59:19 +0100
In-Reply-To: <1362204172-28307-6-git-send-email-thomas@cozybit.com> (sfid-20130302_070418_159027_710EC375)
References: <1362204172-28307-1-git-send-email-thomas@cozybit.com>
	 <1362204172-28307-6-git-send-email-thomas@cozybit.com>
	 (sfid-20130302_070418_159027_710EC375)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-03-01 at 22:02 -0800, Thomas Pedersen wrote:
> There is a corner case which wasn't being covered:
> userspace may authenticate and allocate stations,
> but still leave the peering up to the kernel.
> 
> Initialize the peering timer if the MPM is not in
> userspace, in a path which is taken by both the kernel and
> userspace when allocating stations.

Applied this one.

johannes

