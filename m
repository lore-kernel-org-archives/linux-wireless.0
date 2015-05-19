Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57829 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbbESH3k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 03:29:40 -0400
Message-ID: <1432020579.7437.4.camel@sipsolutions.net> (sfid-20150519_092944_237327_7D93A5A5)
Subject: Re: [PATCH 1/2] nl80211: Add support to configure low ack threshold
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 19 May 2015 09:29:39 +0200
In-Reply-To: <1431600456-10697-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150514_124919_127289_906D16E2)
References: <1431600456-10697-1-git-send-email-rmanohar@qti.qualcomm.com>
	 (sfid-20150514_124919_127289_906D16E2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-05-14 at 16:17 +0530, Rajkumar Manoharan wrote:
> Add a new nl80211 attribute to configure low ack threshold (number of
> consecutive frames) not being acked by station. This threshold is used
> to kickout station by driver through low ack event. This allows user to
> tune the parameter to improve robustness under noisy environment.

If we're making this configurable, why not allow it to be done per
station?

johannes

