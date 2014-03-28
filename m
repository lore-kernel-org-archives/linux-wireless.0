Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48898 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaC1M7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 08:59:42 -0400
Message-ID: <1396011578.4175.17.camel@jlt4.sipsolutions.net> (sfid-20140328_135945_545076_5A633321)
Subject: Re: [PATCH v2 1/7] cfg80211: fix radar_detect combination checking
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Mar 2014 13:59:38 +0100
In-Reply-To: <1395409941-26303-2-git-send-email-michal.kazior@tieto.com> (sfid-20140321_145808_903691_19859A1D)
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	 <1395409941-26303-1-git-send-email-michal.kazior@tieto.com>
	 <1395409941-26303-2-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140321_145808_903691_19859A1D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-21 at 14:52 +0100, Michal Kazior wrote:
> All bits from radar_detect must match combination
> radar bitmask. Otherwise it is theoretically
> possible to lead into an invalid combination
> provided a driver reports strange combinations.

This seemed fairly obvious, applied.

johannes

