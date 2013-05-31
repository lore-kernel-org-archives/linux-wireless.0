Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41464 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3EaPfV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 May 2013 11:35:21 -0400
Message-ID: <1370014517.14117.7.camel@jlt4.sipsolutions.net> (sfid-20130531_173524_187660_ED943C4F)
Subject: Re: [PATCH] mac80211: advertise userspace MPM only if mesh is
 supported
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: thomas@cozybit.com
Date: Fri, 31 May 2013 17:35:17 +0200
In-Reply-To: <1370013191-25900-1-git-send-email-johannes@sipsolutions.net> (sfid-20130531_171324_115740_2E2B04A3)
References: <1370013191-25900-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130531_171324_115740_2E2B04A3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-05-31 at 17:13 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There's no danger in always advertising it, but it would
> look a bit inconsistent so don't do it unless supported.

Actually, this patch is pointless ... it'd _also_ have to check if the
driver supports mesh. I guess I'll just drop it completely.

johannes

