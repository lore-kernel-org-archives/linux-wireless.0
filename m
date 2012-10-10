Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44782 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab2JJIRd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 04:17:33 -0400
Message-ID: <1349857087.4683.32.camel@jlt4.sipsolutions.net> (sfid-20121010_101738_700926_0494EE8E)
Subject: Re: [PATCH v3 0/5] add scan flags support
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Wed, 10 Oct 2012 10:18:07 +0200
In-Reply-To: <1349326066-28501-1-git-send-email-bzhao@marvell.com>
References: <1349326066-28501-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I think this is good, but needs the userspace advertisement.

We can either advertise the scan flags word to userspace and set the
supported flags, but then I'm not sure how to handle scheduled vs.
regular scan. Alternatively we could use nl80211 feature flags (instead
of wiphy flags) which get advertised directly... I'm not really sure
what's better.

What would be the behaviour of flush in a scheduled scan?

johannes

