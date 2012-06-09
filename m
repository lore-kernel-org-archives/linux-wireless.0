Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44308 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab2FIIIV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 04:08:21 -0400
Message-ID: <1339229296.4539.6.camel@jlt3.sipsolutions.net> (sfid-20120609_100830_687307_C18C69A7)
Subject: Re: [PATCH 0/2] mac80211: Improvement to initial mesh metric
From: Johannes Berg <johannes@sipsolutions.net>
To: Jason Abele <jason@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	devel@lists.open80211s.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Sat, 09 Jun 2012 10:08:16 +0200
In-Reply-To: <1339187469-12778-1-git-send-email-jason@cozybit.com> (sfid-20120608_223120_850205_9B920F34)
References: <1339187469-12778-1-git-send-email-jason@cozybit.com>
	 (sfid-20120608_223120_850205_9B920F34)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-08 at 13:31 -0700, Jason Abele wrote:
> These patches add a feature to initialize the link rate metric with a guess
> based off of RSSI when insufficient traffic has passed to allow actual
> calculation of the link rate.
> 
> I am submitting this patch set on behalf of our team after
> testing them with the wireless-testing tag master-2012-06-08.
> Requires the patch series noted below to apply cleanly:
> 	[PATCH 0/2] mac80211: mesh remove unused var and fix naming
> 
> formerly sent as 3 and 5 respectively in:
> 	[PATCH v3 0/5] Improvement to initial mesh metric

What changed, and why did you split up the patch series? Are you
expecting them to go to different trees?

johannes

