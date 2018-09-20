Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:38516 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbeITPD6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 11:03:58 -0400
Message-ID: <1537435276.3874.14.camel@sipsolutions.net> (sfid-20180920_112130_398595_74D4AA22)
Subject: Re: [PATCH] mac80211: allow scans on radar channels, unless there
 is CAC or CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <sw@simonwunderlich.de>,
        linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>
Date: Thu, 20 Sep 2018 11:21:16 +0200
In-Reply-To: <20180918141633.10282-1-sw@simonwunderlich.de>
References: <20180918141633.10282-1-sw@simonwunderlich.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-09-18 at 16:16 +0200, Simon Wunderlich wrote:
> Operating on a DFS channel doesn't mean we can't leave it for a short
> time - actually, some features like off-channel CAC work by leaving the
> operation channel to check other channels for availability (although
> off-channel CAC isn't implemented in mac80211). In our case, we want to
> use mesh while doing background surveys on other channels from time to
> time.

Actually ... as far as I can tell it *does* mean that, at least
currently for FCC.

johannes
