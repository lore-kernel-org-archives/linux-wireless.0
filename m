Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41018 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215AbaEENPi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2014 09:15:38 -0400
Message-ID: <1399295725.22235.13.camel@jlt4.sipsolutions.net> (sfid-20140505_151541_486949_D26BEE12)
Subject: Re: [PATCH 1/2] cfg80211: add cfg80211_sched_scan_stopped_rtnl
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 05 May 2014 15:15:25 +0200
In-Reply-To: <1398863664-20193-1-git-send-email-eliad@wizery.com> (sfid-20140430_151433_593635_FE701BD3)
References: <1398863664-20193-1-git-send-email-eliad@wizery.com>
	 (sfid-20140430_151433_593635_FE701BD3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-30 at 16:14 +0300, Eliad Peller wrote:
> Add locked-version for cfg80211_sched_scan_stopped.
> This is used for some users that might want to
> call it when rtnl is already locked.

Applied both, but I had to do some fixups, so stable might request a new
version of the patch from you.

johannes

