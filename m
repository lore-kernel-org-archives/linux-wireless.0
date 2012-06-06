Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54183 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab2FFJO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 05:14:29 -0400
Message-ID: <1338974067.4513.46.camel@jlt3.sipsolutions.net> (sfid-20120606_111431_293477_1D63EED6)
Subject: Re: [RFC 11/14] cfg80211/mac80211: remove .get_channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 11:14:27 +0200
In-Reply-To: <1338203942-5667-12-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
	 <1338203942-5667-12-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-28 at 13:18 +0200, Michal Kazior wrote:
> We do not need it anymore since cfg80211 tracks
> monitor channel and monitor channel type.

Previously though we did handle the corner case of not having a monitor
channel at all by using whatever channel was last set by say a managed
interface or whatever default mac80211 used (channel 1)

johannes

