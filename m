Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39780 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3FEGeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 02:34:12 -0400
Message-ID: <1370414046.8920.1.camel@jlt4.sipsolutions.net> (sfid-20130605_083415_449648_2715E178)
Subject: Re: [wireless-regdb] [PATCH] regulatory: enable channels 52-64 and
 100-144 for world roaming
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: bzhao@marvell.com, wireless-regdb@lists.infradead.org,
	mcgrof@do-not-panic.com
Date: Wed, 05 Jun 2013 08:34:06 +0200
In-Reply-To: <1368738412-7740-1-git-send-email-johannes@sipsolutions.net>
References: <1368738412-7740-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-05-16 at 23:06 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If allowed in a country, these channels typically require DFS
> so mark them as such. Channel 144 is a bit special, it's coming
> into use now to allow more VHT 80 channels, but world roaming
> with passive scanning is acceptable anyway. It seems fairly
> unlikely that it'll be used as the control channel for a VHT
> AP, but it needs to be present to allow a full VHT connection
> to an AP that uses it as one of the secondary channels.
> 
> Also enable VHT 160 on these channels, and also for channels
> 36-48 to be able to use VHT 160 there.

You guys all get a few more days for comments, then I'm merging this
next Monday. I really think it's the right thing to do, there's no
reason to prohibit passive scanning on radar channels that I know of.

johannes

