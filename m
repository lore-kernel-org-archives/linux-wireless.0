Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45805 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab3DVNaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 09:30:10 -0400
Message-ID: <1366637397.8637.7.camel@jlt4.sipsolutions.net> (sfid-20130422_153034_789881_6FDE3853)
Subject: Re: [PATCH] net-sysfs: Add entry for nl80211 interface type
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: Bing Zhao <bzhao@marvell.com>, linux-netdev@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Date: Mon, 22 Apr 2013 15:29:57 +0200
In-Reply-To: <CAMcMvsjh4y=84hM+dCcFvb1xxSq5c3HqTBg6VyaCZkh5s=E5yA@mail.gmail.com> (sfid-20130418_001419_120365_42D87327)
References: <1366236369-543-1-git-send-email-bzhao@marvell.com>
	 <1366236590.8217.64.camel@jlt4.sipsolutions.net>
	 <CAMcMvsjh4y=84hM+dCcFvb1xxSq5c3HqTBg6VyaCZkh5s=E5yA@mail.gmail.com>
	 (sfid-20130418_001419_120365_42D87327)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-17 at 15:14 -0700, Paul Stewart wrote:
> I believe the documents for "iw" state explicitly that we shouldn't
> screen-scrape it?

Well, you specifically control your system. I'd also be happy to add
some (maybe a bit hidden) commands to print out _just_ the (numeric)
type, to aid scripting? All I'm trying to say with that though is that
you shouldn't rely on specific output formatting, particularly not with
scan results and "iw list" etc.

johannes


