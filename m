Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42479 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759466Ab1CDLgW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 06:36:22 -0500
Subject: Re: [PATCH 5/7] nl80211: Let userspace set the authenticated flag
 for a mesh peer
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Javier Cardona <javier@cozybit.com>
In-Reply-To: <1299208307-9428-6-git-send-email-thomas@cozybit.com>
References: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
	 <1299208307-9428-6-git-send-email-thomas@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 12:36:20 +0100
Message-ID: <1299238580.4348.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-03-03 at 19:11 -0800, Thomas Pedersen wrote:
> From: Javier Cardona <javier@cozybit.com>

[snip (maybe more changelog would be nice)]

So .. a more "traditional" approach, like we do in AP, would be to let
userspace manage the lifetime of STA entries in this case. In managed
mode, we don't, but there mac80211 currently handles the authentication.

I think you should explore doing mesh more like the AP case. OTOH, I
don't know how the managed case with SAE would work.

johannes

