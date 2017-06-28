Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59728 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751511AbdF1PDB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 11:03:01 -0400
Message-ID: <1498662178.12531.6.camel@sipsolutions.net> (sfid-20170628_170311_051195_930C745C)
Subject: Re: [PATCH] mac80211_hwsim: use dyndbg for debug messages
From: Johannes Berg <johannes@sipsolutions.net>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 28 Jun 2017 17:02:58 +0200
In-Reply-To: <20170628131726.15528-1-lkundrak@v3.sk>
References: <20170628131726.15528-1-lkundrak@v3.sk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-06-28 at 15:17 +0200, Lubomir Rintel wrote:
> The mac80211_hwsim doesn't offer a way to disable the debugging
> output.
> Unfortunately, it's pretty chatty, dumping a  lot of stuff into the
> message buffer.

Why is this a problem? It's pretty much a testing tool only, and much
of the point is to have message about it's internal state?

johannes
