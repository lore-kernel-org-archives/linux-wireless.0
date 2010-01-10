Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48918 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925Ab0AJNno (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2010 08:43:44 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: flush workqueue before calling driver ->stop() method
Date: Sun, 10 Jan 2010 14:43:36 +0100
Cc: Lennert Buytenhek <buytenh@wantstofly.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
References: <20100110130752.GG1735@mail.wantstofly.org> <201001101435.26235.mb@bu3sch.de> <1263130839.7773.16.camel@johannes.local>
In-Reply-To: <1263130839.7773.16.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001101443.38872.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 10 January 2010 14:40:39 Johannes Berg wrote:
> See, it's not strictly forbidden to queue work, there's just no

Ok, well. Lennert's mail sounded different to me.

-- 
Greetings, Michael.
