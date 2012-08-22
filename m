Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44341 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab2HVIZx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2012 04:25:53 -0400
Message-ID: <1345621500.4635.4.camel@jlt3.sipsolutions.net> (sfid-20120822_102616_414384_7C6FEC5D)
Subject: Re: [PATCH] mac80211: fix DS to MBSS address translation
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	cedric.voncken@acksys.fr
Date: Wed, 22 Aug 2012 09:45:00 +0200
In-Reply-To: <1345487305-23759-1-git-send-email-thomas@cozybit.com> (sfid-20120820_202834_095293_ED62B34C)
References: <1345487305-23759-1-git-send-email-thomas@cozybit.com>
	 (sfid-20120820_202834_095293_ED62B34C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-08-20 at 11:28 -0700, Thomas Pedersen wrote:
> The destination address of unicast frames forwarded through a mesh gate
> was being replaced with the broadcast address. Instead leave the
> original destination address as the mesh DA. If the nexthop address is
> not in the mpath table it will be resolved. If that fails, the frame
> will be forwarded to known mesh gates.

Applied. I'll send another pull request for 3.6 later this week.

johannes

