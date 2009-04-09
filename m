Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:5137 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756841AbZDIQUk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2009 12:20:40 -0400
Subject: Re: [PATCH] mac80211: re-upload keys only after telling driver
 about association
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Bob Copeland <bcopeland@gmail.com>
In-Reply-To: <1239152134.8456.41.camel@johannes.local>
References: <1239152134.8456.41.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 09:26:29 -0700
Message-Id: <1239294389.4684.15.camel@rc-desk> (sfid-20090409_182044_163315_9973D971)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Tue, 2009-04-07 at 17:55 -0700, Johannes Berg wrote:
> In the normal WPA or RSN case keys are only configured after
> associating, so we should do that in that order when resuming
> as well. It shouldn't really matter since we do not send any
> data at either point, but iwlwifi prefers it this way and it
> does seem more natural.

Could you please share the symptom of the problem with iwlwifi without
this patch?

Thank you

Reinette


