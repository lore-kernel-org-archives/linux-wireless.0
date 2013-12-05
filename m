Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52028 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab3LEOCQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 09:02:16 -0500
Message-ID: <1386252128.4182.3.camel@jlt4.sipsolutions.net> (sfid-20131205_150219_574639_12B14DF6)
Subject: Re: [PATCH] cfg80211: fix WARN_ON for re-association to the expired
 BSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Ujjal Roy <royujjal@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 05 Dec 2013 15:02:08 +0100
In-Reply-To: <1386158254-10647-1-git-send-email-royujjal@gmail.com> (sfid-20131204_125801_012827_2F36E30D)
References: <1386158254-10647-1-git-send-email-royujjal@gmail.com>
	 (sfid-20131204_125801_012827_2F36E30D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-12-04 at 17:27 +0530, Ujjal Roy wrote:
> cfg80211 allows re-association in managed mode and if a user
> wants to re-associate to the same AP network after the time
> period of IEEE80211_SCAN_RESULT_EXPIRE, cfg80211 warns with
> the following message on receiving the connect result event.

Applied.

johannes

