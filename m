Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36518 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab2JALOi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 07:14:38 -0400
Message-ID: <1349090111.10330.24.camel@jlt4.sipsolutions.net> (sfid-20121001_131442_086223_C0A68BB6)
Subject: Re: [PATCH v2 4/5] mac80211: add support for tx to abort low
 priority scan requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Sam Leffler <sleffler@chromium.org>
Cc: Bing Zhao <bzhao@marvell.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Mon, 01 Oct 2012 13:15:11 +0200
In-Reply-To: <CA+yqC4aGJ4wpBNvyZRuPvSMdmQf8o2CHW=S=Uxry3CCT_RxwFw@mail.gmail.com> (sfid-20120928_223812_285836_7DBC4592)
References: <1348772354-15936-1-git-send-email-bzhao@marvell.com>
	 <1348772354-15936-5-git-send-email-bzhao@marvell.com>
	 <1348830401.13298.27.camel@jlt4.sipsolutions.net>
	 <CA+yqC4aGJ4wpBNvyZRuPvSMdmQf8o2CHW=S=Uxry3CCT_RxwFw@mail.gmail.com>
	 (sfid-20120928_223812_285836_7DBC4592)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-09-28 at 13:38 -0700, Sam Leffler wrote:

> > Maybe we should have different flags though ... I mean, this is the
> > first implementation that I hear of that interprets a background scan as
> > "ok to abort at any time"? It seems very unlikely that other
> > implementations would do that. I *think* (like I said before, I don't
> > really know) that ours (Intel's) will just shorten the dwell time, or
> > similar instead.
> 
> Well previous implementations I've done have used this technique for
> many years and you can find them in various products (assuming they
> haven't been totally rewritten) :-)

:-)

You convinced me before though with the abort/not-abort notification
being sufficient, so I think we can do with the low-priority flag and
any kind of implementation.

johannes

