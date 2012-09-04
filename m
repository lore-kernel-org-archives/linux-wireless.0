Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41495 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454Ab2IDPOQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 11:14:16 -0400
Message-ID: <1346771691.3737.33.camel@jlt4.sipsolutions.net> (sfid-20120904_171429_814335_B9E6739A)
Subject: Re: [PATCH v2] mac80211: clear bssid on auth/assoc failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 04 Sep 2012 17:14:51 +0200
In-Reply-To: <1346769885-4001-1-git-send-email-eliad@wizery.com> (sfid-20120904_164442_606148_0B9304B5)
References: <1346769885-4001-1-git-send-email-eliad@wizery.com>
	 (sfid-20120904_164442_606148_0B9304B5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-04 at 17:44 +0300, Eliad Peller wrote:
> ifmgd->bssid wasn't cleared properly in some
> auth/assoc failure cases, causing mac80211 and
> the low-level driver to go out of sync.
> 
> Clear ifmgd->bssid on failure, and notify the driver.

Applied, thanks.

johannes

