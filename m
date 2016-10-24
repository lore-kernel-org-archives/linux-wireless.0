Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52764 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936517AbcJXOQG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 10:16:06 -0400
Message-ID: <1477318562.4085.28.camel@sipsolutions.net> (sfid-20161024_161619_492331_FC0F4724)
Subject: Re: [PATCH v2 2/2] mac80211: passively scan DFS channels if
 requested
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Antonio Quartulli <a@unstable.cc>, linux-wireless@vger.kernel.org
Date: Mon, 24 Oct 2016 16:16:02 +0200
In-Reply-To: <3178350.ZYYEYN7rIx@prime>
References: <1447464560-28104-1-git-send-email-antonio@meshcoding.com>
         <20161024121129.GA8925@prodigo.lan>
         <1477316004.4085.17.camel@sipsolutions.net> <3178350.ZYYEYN7rIx@prime>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-10-24 at 15:42 +0200, Simon Wunderlich wrote:

> Otherwise, it would be pretty much impossible to perform CSAs to
> another DFS channel.

I was told that to do that you'd need another NIC that's pre-CAC'ing
another channel.

johannes
