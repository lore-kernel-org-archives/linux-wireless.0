Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38439 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab3LBKyu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 05:54:50 -0500
Message-ID: <1385981687.4445.6.camel@jlt4.sipsolutions.net> (sfid-20131202_115457_143337_F7C5E755)
Subject: Re: [PATCH] mac80211: check csa wiphy flag in ibss before switching
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 02 Dec 2013 11:54:47 +0100
In-Reply-To: <1385480718-13702-1-git-send-email-sw@simonwunderlich.de>
References: <1385480718-13702-1-git-send-email-sw@simonwunderlich.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-26 at 16:45 +0100, Simon Wunderlich wrote:
> When external CSA IEs are received (beacons or action messages), a
> channel switch is triggered as well. This should only be allowed on
> devices which actually support channel switches, otherwise disconnect.
> (For the corresponding userspace invocation, the wiphy flag is checked
> in nl80211).

Applied.

johannes

