Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42486 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759440Ab1CDLhh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 06:37:37 -0500
Subject: Re: [PATCH 7/7] mac80211: Check auth status before attempting to
 establish a peer link
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Javier Cardona <javier@cozybit.com>
In-Reply-To: <1299208307-9428-8-git-send-email-thomas@cozybit.com>
References: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
	 <1299208307-9428-8-git-send-email-thomas@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 12:37:35 +0100
Message-ID: <1299238655.4348.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-03-03 at 19:11 -0800, Thomas Pedersen wrote:
> From: Javier Cardona <javier@cozybit.com>

And this patch would also not be necessary since there wouldn't be a
station entry to start with.

johannes

