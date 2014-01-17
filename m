Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48134 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaAQSzW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 13:55:22 -0500
Message-ID: <1389984919.10404.7.camel@jlt4.sipsolutions.net> (sfid-20140117_195524_965236_B2C5A074)
Subject: Re: [PATCH] cfg80211: Do not call CRDA when using internal
 regulatory database
From: Johannes Berg <johannes@sipsolutions.net>
To: Chaitanya T K <chaitanya.mgit@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 17 Jan 2014 19:55:19 +0100
In-Reply-To: <1389909758-6807-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20140116_230321_534715_19C9CA89)
References: <1389909758-6807-1-git-send-email-chaitanya.mgit@gmail.com>
	 (sfid-20140116_230321_534715_19C9CA89)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-01-17 at 03:32 +0530, Chaitanya T K wrote:
> When using internal regulatory data base kconfig option
> do not try to call crda, this complely defeats the 
> purposes of enabling internal regulatory db.

In general I don't think you can just break user visible behaviour this
way.

johannes

