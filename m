Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42483 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759440Ab1CDLhS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 06:37:18 -0500
Subject: Re: [PATCH 6/7] mac80211: Parse RSN information element to
 determine if a peer needs authentication
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Javier Cardona <javier@cozybit.com>
In-Reply-To: <1299208307-9428-7-git-send-email-thomas@cozybit.com>
References: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
	 <1299208307-9428-7-git-send-email-thomas@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 12:37:15 +0100
Message-ID: <1299238635.4348.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-03-03 at 19:11 -0800, Thomas Pedersen wrote:
> From: Javier Cardona <javier@cozybit.com>

[...]

If you manage stations in userspace, then this code is unnecessary.
That'd be a big win in my eyes. The only thing the kernel would need to
know is not to create station entries, right?

johannes

