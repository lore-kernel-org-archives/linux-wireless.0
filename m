Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43362 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab3JQLfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 07:35:13 -0400
Message-ID: <1382009704.14410.0.camel@jlt4.sipsolutions.net> (sfid-20131017_133520_526415_8B6C364F)
Subject: Re: [PATCH 3.12 1/3] mac80211: fix honouring rate flags in low-rate
 transmit
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Thu, 17 Oct 2013 13:35:04 +0200
In-Reply-To: <1381843030-12260-1-git-send-email-johannes@sipsolutions.net> (sfid-20131015_151719_896322_452B2366)
References: <1381843030-12260-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20131015_151719_896322_452B2366)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-10-15 at 15:17 +0200, Johannes Berg wrote:
> From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> 
> Transmissions with the IEEE80211_TX_CTL_NO_CCK_RATE flag set
> (which can come from userspace) were no longer guaranteed to
> be transmitted with allowed rates since commit 2103dec14792b
> ("mac80211: select and adjust bitrates according to channel
> mode") due to a missing rate_flags check in that commit. The
> commit also introduced the need to check the 5/10 MHz flags
> but accidentally didn't. Fix it by adding the missing check.

Applied 1 and 2.

johannes

