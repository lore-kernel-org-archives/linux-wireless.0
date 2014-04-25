Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56476 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaDYPoa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 11:44:30 -0400
Message-ID: <1398440053.4152.19.camel@jlt4.sipsolutions.net> (sfid-20140425_174615_344148_D13CC043)
Subject: Re: [PATCH 09/12] cfg80211: change return value of notifier function
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 25 Apr 2014 17:34:13 +0200
In-Reply-To: <a2f03499a7cc33a86a7454e9824bf803f75d1916.1398055854.git.gamerh2o@gmail.com> (sfid-20140421_065521_407012_027D8B66)
References: <cover.1398055853.git.gamerh2o@gmail.com>
	 <a2f03499a7cc33a86a7454e9824bf803f75d1916.1398055854.git.gamerh2o@gmail.com>
	 (sfid-20140421_065521_407012_027D8B66)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-04-21 at 12:53 +0800, Zhao, Gang wrote:
> Return NOTIFY_DONE if we don't care this time's notification, return
> NOTIFY_OK if we successfully handled this time's notification. That's
> the formal way to do it.

That's really quite pointless, but I'll apply it anyway.

johannes

