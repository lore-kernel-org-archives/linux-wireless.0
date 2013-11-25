Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39442 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab3KYVNO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 16:13:14 -0500
Message-ID: <1385413989.4443.64.camel@jlt4.sipsolutions.net> (sfid-20131125_221317_220450_B7DC0676)
Subject: Re: [PATCHv2 0/5] Fix CSA locking issues
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 25 Nov 2013 22:13:09 +0100
In-Reply-To: <1385054393-17238-1-git-send-email-sw@simonwunderlich.de>
References: <1385054393-17238-1-git-send-email-sw@simonwunderlich.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-11-21 at 18:19 +0100, Simon Wunderlich wrote:
> Unfortunately my channel switch announcement patches contained locking issues
> which I didn't notice during my test due to bad configuration. Johannes pointed
> them out, so here is my attempt to fix them.

Applied. Since this didn't apply to mac80211.git, I've taken it into
mac80211-next.git. Please send a patch to 3.13 to disable CSA completely
there, since it's obviously totally broken.

johannes

