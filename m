Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37338 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755485AbdABK77 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 05:59:59 -0500
Message-ID: <1483354796.4596.9.camel@sipsolutions.net> (sfid-20170102_120002_392084_9842487C)
Subject: Re: [PATCH] mac80211: Fix addition of mesh configuration element
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, masashi.honma@gmail.com
Date: Mon, 02 Jan 2017 11:59:56 +0100
In-Reply-To: <1482769056-28577-1-git-send-email-ilan.peer@intel.com> (sfid-20161226_151931_342648_794604E1)
References: <1482769056-28577-1-git-send-email-ilan.peer@intel.com>
         (sfid-20161226_151931_342648_794604E1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-12-26 at 18:17 +0200, Ilan Peer wrote:
> The code was setting the capabilities byte to zero,
> after it was already properly set previously. Fix it.
> 
> The bug was found while debugging hwsim mesh tests failures
> that happened in commit 76f43b4 (mac80211: Remove invalid flag
> operations in mesh TSF synchronization).
> 
Applied, thanks.

When you have the commit already, please add a Fixes tag, and also use
12 hex digits to abbreviate SHA1s please. (I've done that now)

johannes
