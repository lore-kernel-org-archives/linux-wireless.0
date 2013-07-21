Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:33228 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab3GUOOT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jul 2013 10:14:19 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20971.60401.394690.279877@gargle.gargle.HOWL> (sfid-20130721_161422_256874_DC4A0A76)
Date: Sun, 21 Jul 2013 19:40:57 +0530
To: Arik Nemtsov <arik@wizery.com>
Cc: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: Re: [PATCH 2/2] regulatory: take RTNL when restoring settings on CRDA timeout
In-Reply-To: <1374413809-26005-2-git-send-email-arik@wizery.com>
References: <1374413809-26005-1-git-send-email-arik@wizery.com>
	<1374413809-26005-2-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arik Nemtsov wrote:
> The RTNL has to be held since this potentially changes the regdomain.
> Locking was forgotten here due to recent locking simplification changes.

This is already present in the mac80211 tree:
https://git.kernel.org/cgit/linux/kernel/git/jberg/mac80211.git/commit/?id=f77b86d7d3acf9dfcb5ee834628d12207584b2cb

Sujith
