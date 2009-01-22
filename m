Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45028 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207AbZAVDcI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 22:32:08 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 21 Jan 2009 19:32:08 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18807.59364.541103.595456@gargle.gargle.HOWL> (sfid-20090122_043213_859387_362E8AA4)
Date: Thu, 22 Jan 2009 08:58:36 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>
Subject: Re: [PATCH] mac80211: Add capability to enable/disable beaconing
In-Reply-To: <1232542958.6059.1.camel@johannes.local>
References: <18805.33791.193195.755178@gargle.gargle.HOWL>
	<1232448779.20158.4.camel@johannes.local>
	<18805.62728.34610.424793@localhost.localdomain>
	<1232538350.4358.5.camel@johannes.local>
	<1232542958.6059.1.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2009-01-21 at 12:45 +0100, Johannes Berg wrote:
> 
> > How about this? Untested still though.
> 
> That ran into a bug, here's a version that's hopefully better. (second
> patch unchanged)

Tested in IBSS mode, works fine. Thanks a lot.

Sujith
