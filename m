Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49926 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbaBKL7Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 06:59:25 -0500
Message-ID: <1392119962.4128.2.camel@jlt4.sipsolutions.net> (sfid-20140211_125928_148918_160EECD4)
Subject: Re: [PATCH] mac80211: fix sched_scan restart on recovery
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Date: Tue, 11 Feb 2014 12:59:22 +0100
In-Reply-To: <1392114439-26492-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1392114439-26492-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-11 at 12:27 +0200, Emmanuel Grumbach wrote:
> From: Arik Nemtsov <arik@wizery.com>
> 
> In case we were not suspended, the reconfig function returns without
> configuring the scheduled scan.

Applied.

johannes

