Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60013 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab3JUK0I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 06:26:08 -0400
Message-ID: <1382351165.14310.43.camel@jlt4.sipsolutions.net> (sfid-20131021_122612_674576_9AAF63EE)
Subject: Re: [PATCH] mac80211: fix uninitialized variable
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 21 Oct 2013 12:26:05 +0200
In-Reply-To: <1382133420-1545-1-git-send-email-michal.kazior@tieto.com> (sfid-20131018_235928_259245_BE499DB7)
References: <1382133420-1545-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20131018_235928_259245_BE499DB7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-10-18 at 14:57 -0700, Michal Kazior wrote:
> CSA completion could call in a driver
> bss_info_changed() with a garbled `changed` flag
> leading to all sorts of problems.

Applied.

johannes

