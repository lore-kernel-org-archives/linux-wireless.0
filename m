Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [192.55.52.93] ([192.55.52.93]:52863 "EHLO mga11.intel.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbXHTDKx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 23:10:53 -0400
Subject: Re: [PATCH] Add iwlwifi wireless drivers (resend)
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>,
	Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <1187349981.23489.162.camel@johannes.berg>
References: <1187328536.5763.137.camel@debian.sh.intel.com>
	 <1187349981.23489.162.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 20 Aug 2007 10:56:50 +0800
Message-Id: <1187578610.5763.232.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-08-17 at 13:26 +0200, Johannes Berg wrote:
> I was recently reviewing encryption stuff---can you comment on why you
> don't allow disabling hardware keys? For proper operation you really
> should allow that. 

I don't think there is any special reason, just haven't enabled it yet.
We enable the hwcrypto and find it works good, then we switched to
enable something else. For the end users, I think they'd always want to
use hwcrypto if it is supported by the hardware. For developers, I'd
agree it is useful. I'll add it to the TODO list.

Thanks,
-yi
