Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50180 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758987Ab3B0Mcp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 07:32:45 -0500
Message-ID: <1361968360.8172.5.camel@jlt4.sipsolutions.net> (sfid-20130227_133248_939108_65E9D6FC)
Subject: Re: [PATCH 1/2] cfg80211: advertise extended capabilities to
 userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Piotr Haber <phaber@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 27 Feb 2013 13:32:40 +0100
In-Reply-To: <512DFC54.60602@broadcom.com> (sfid-20130227_133040_714989_9A702E8E)
References: <1360677682-3694-1-git-send-email-johannes@sipsolutions.net>
	 <512DFC54.60602@broadcom.com> (sfid-20130227_133040_714989_9A702E8E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-27 at 13:30 +0100, Piotr Haber wrote:

> seems like this patch pushed wiphy info length over the limit
> for dual band devices.
> So userspace cannot get any info about phy capabilities.

Yeah ... was it this patch? I did revert some others, but I guess it
depends.

> I know there is a patch for nl80211 and iw to allow splitting of this info,
> but it is not in 3.8
> Should we not revert it for stable then?

Yeah we can revert this too, a la the patches already in to remove TCP
wakeup and radar info. What kernel are you testing?

johannes

