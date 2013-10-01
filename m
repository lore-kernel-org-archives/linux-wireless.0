Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59823 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab3JAMPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 08:15:23 -0400
Message-ID: <1380629714.14430.39.camel@jlt4.sipsolutions.net> (sfid-20131001_141527_173714_D70BF8D1)
Subject: Re: [wireless-regdb] [PATCH] regulatory: enable channels 52-64 and
 100-144 for world roaming
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: bzhao@marvell.com, wireless-regdb@lists.infradead.org,
	mcgrof@do-not-panic.com
Date: Tue, 01 Oct 2013 14:15:14 +0200
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

So many months later ... I'm merging this now.

johannes

