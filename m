Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47844 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbbHML4v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 07:56:51 -0400
Message-ID: <1439467008.2114.23.camel@sipsolutions.net> (sfid-20150813_135654_294748_48739594)
Subject: Re: [PATCH] cfg80211: propagate set_wiphy failure to userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 13 Aug 2015 13:56:48 +0200
In-Reply-To: <1438592124-30803-1-git-send-email-michal.kazior@tieto.com> (sfid-20150803_105503_295981_6EA4DF93)
References: <1438592124-30803-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20150803_105503_295981_6EA4DF93)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-08-03 at 10:55 +0200, Michal Kazior wrote:
> If driver failed to setup wiphy params (e.g. rts
> threshold, fragmentation treshold) userspace
> wasn't properly notified about this. This could
> lead to user confusion who would think the command
> succeeded even if that wasn't the case.
> 
Applied.

johannes
