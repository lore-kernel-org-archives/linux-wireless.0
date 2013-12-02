Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38437 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab3LBKyn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 05:54:43 -0500
Message-ID: <1385981680.4445.5.camel@jlt4.sipsolutions.net> (sfid-20131202_115451_531906_62E8E66B)
Subject: Re: [PATCH-mac80211] cfg80211: disable CSA for all drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 02 Dec 2013 11:54:40 +0100
In-Reply-To: <1385478446-27868-1-git-send-email-sw@simonwunderlich.de>
References: <1385478446-27868-1-git-send-email-sw@simonwunderlich.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-26 at 16:07 +0100, Simon Wunderlich wrote:
> The channel switch announcement code has some major locking problems
> which can cause a deadlock in worst case. A series of fixes has been
> proposed, but these are non-trivial and need to be tested first.
> Therefore disable CSA completely for 3.13.
> 
> Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
> ---
> This is based on mac80211.git and should go into 3.13 only

It didn't apply cleanly so I guess you didn't base it on the latest
version, but I picked it up.

johannes

