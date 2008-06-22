Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:56805 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617AbYFVWap (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2008 18:30:45 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: mac80211: workqueue & RTNL lock
Date: Mon, 23 Jun 2008 00:30:42 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
References: <200806230042.41219.IvDoorn@gmail.com>
In-Reply-To: <200806230042.41219.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806230030.42776.mb@bu3sch.de> (sfid-20080623_003048_407674_2EA4B1D9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 23 June 2008 00:42:41 Ivo van Doorn wrote:
> That function calls flush_workqueue()

Uh wait. It shouldn't call that. Where exactly is this function called?

-- 
Greetings Michael.
