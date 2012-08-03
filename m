Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52549 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab2HCTcC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 15:32:02 -0400
Message-ID: <1344022319.4482.15.camel@jlt3.sipsolutions.net> (sfid-20120803_213206_535269_BEEC1E42)
Subject: Re: [PATCH v2 1/4] mac80211: improve cleanup when leaving mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Fri, 03 Aug 2012 21:31:59 +0200
In-Reply-To: <1344021695-12859-1-git-send-email-thomas@cozybit.com> (sfid-20120803_212143_329691_4297F058)
References: <1344021695-12859-1-git-send-email-thomas@cozybit.com>
	 (sfid-20120803_212143_329691_4297F058)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-08-03 at 12:21 -0700, Thomas Pedersen wrote:
> It is not necessary to stop the mesh beacon in the mac80211 ndo_stop
> handler, since cfg80211 has already left the mesh on NETDEV_GOING_DOWN
> notification.

Applied all, thanks.

johannes

