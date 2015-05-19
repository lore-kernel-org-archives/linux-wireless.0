Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57822 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945AbbESH0d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 03:26:33 -0400
Message-ID: <1432020391.7437.2.camel@sipsolutions.net> (sfid-20150519_092640_326858_0C3DEC37)
Subject: Re: [PATCH wireless-next] mac80211: fix double flush workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: Varka Bhadram <varkabhadram@gmail.com>
Cc: linux-wireless@vger.kernel.org, Varka Bhadram <varkab@cdac.in>
Date: Tue, 19 May 2015 09:26:31 +0200
In-Reply-To: <1431671210-6761-1-git-send-email-varkab@cdac.in> (sfid-20150515_082729_656523_7D208EC4)
References: <1431671210-6761-1-git-send-email-varkab@cdac.in>
	 (sfid-20150515_082729_656523_7D208EC4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-05-15 at 11:56 +0530, Varka Bhadram wrote:
> In suspend functionality flushing of the workqueue is done
> with ieee80211_stop_device(). This patch avoid flushing
> the workqueue for two times.

Why do you think this makes sense?

This is done in entirely different places in the code.

johannes

