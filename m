Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34140 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab3LAJdF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Dec 2013 04:33:05 -0500
Message-ID: <1385890375.4171.0.camel@jlt4.sipsolutions.net> (sfid-20131201_103314_816544_07C50689)
Subject: Re: [PATCH] cfg80211: fix WARN_ON for re-association to the expired
 BSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Ujjal Roy <royujjal@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Sun, 01 Dec 2013 10:32:55 +0100
In-Reply-To: <1385883096-7143-1-git-send-email-royujjal@gmail.com> (sfid-20131201_083145_260096_779C94CC)
References: <1385883096-7143-1-git-send-email-royujjal@gmail.com>
	 (sfid-20131201_083145_260096_779C94CC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-12-01 at 13:01 +0530, Ujjal Roy wrote:
> cfg80211 allows re-association in managed mode and if a user
> wants to re-associate to the same AP network after the time
> period of IEEE80211_SCAN_RESULT_EXPIRE, cfg80211 warns with
> the following message on receiving the connect result event.

This behaviour is intentional to point out driver bugs. I'm not applying
this.

johannes

