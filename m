Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44131 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab1BXP6j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 10:58:39 -0500
Subject: Re: [PATCH] mac80211: make tx() operation return void
From: Johannes Berg <johannes@sipsolutions.net>
To: sedat.dilek@gmail.com
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTi=sRXPy8tmc4QYDQZfC-CqhGZpKpNeOR6b+OhhQ@mail.gmail.com>
References: <1298554926.4775.4.camel@jlt3.sipsolutions.net>
	 <AANLkTi=sRXPy8tmc4QYDQZfC-CqhGZpKpNeOR6b+OhhQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 16:58:34 +0100
Message-ID: <1298563114.4251.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-02-24 at 16:56 +0100, Sedat Dilek wrote:
> On Thu, Feb 24, 2011 at 2:42 PM, Johannes Berg

> Will this patch go into 2.6.39?
> I have modified it as a v2 to fit latest linux-next ("apply-tested").

Presumably. I'd based it on wireless-testing, but why did you use
linux-next rather than wireless-next? What's the difference anyway?

johannes

