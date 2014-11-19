Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40098 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755184AbaKSSBQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 13:01:16 -0500
Message-ID: <1416420073.9374.15.camel@sipsolutions.net> (sfid-20141119_190120_115764_F0EA1E18)
Subject: Re: [PATCH v2 1/2] mac80211-hwsim: Factor out netlink attribute
 appending
From: Johannes Berg <johannes@sipsolutions.net>
To: Patrik Flykt <patrik.flykt@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Nov 2014 19:01:13 +0100
In-Reply-To: <1415803360-4073-2-git-send-email-patrik.flykt@linux.intel.com> (sfid-20141112_154252_610154_3687E769)
References: <1415803360-4073-1-git-send-email-patrik.flykt@linux.intel.com>
	 <1415803360-4073-2-git-send-email-patrik.flykt@linux.intel.com>
	 (sfid-20141112_154252_610154_3687E769)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-11-12 at 16:42 +0200, Patrik Flykt wrote:
> Factor out netlink message attribute appending in order to reuse it
> with later code. As a result move netlink skb allocation to the
> calling function.

Applied.

johannes

