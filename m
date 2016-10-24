Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52930 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932525AbcJXOij (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 10:38:39 -0400
Message-ID: <1477319916.4085.29.camel@sipsolutions.net> (sfid-20161024_163843_189042_A4EA44C3)
Subject: Re: [PATCH v2 2/2] mac80211: passively scan DFS channels if
 requested
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Antonio Quartulli <a@unstable.cc>, linux-wireless@vger.kernel.org
Date: Mon, 24 Oct 2016 16:38:36 +0200
In-Reply-To: <4116422.yZP7iyh9mq@prime>
References: <1447464560-28104-1-git-send-email-antonio@meshcoding.com>
         <3178350.ZYYEYN7rIx@prime> <1477318562.4085.28.camel@sipsolutions.net>
         <4116422.yZP7iyh9mq@prime>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-10-24 at 16:36 +0200, Simon Wunderlich wrote:
> On Monday, October 24, 2016 4:16:02 PM CEST Johannes Berg wrote:
> > 
> > On Mon, 2016-10-24 at 15:42 +0200, Simon Wunderlich wrote:
> > > 
> > > Otherwise, it would be pretty much impossible to perform CSAs to
> > > another DFS channel.
> > 
> > I was told that to do that you'd need another NIC that's pre-
> > CAC'ing another channel.
> 
> Here is the portion from ETSI 301 893 v1.8.1 [1] (the most recent one
> to my knowledege), section 4.7.1.4 which describes operation from
> master devices (Access Points):
> [...]

Yeah I'm pretty sure there are differences in ETSI vs. FCC. Perhaps the
information I was told about was for FCC. But perhaps it's all just
completely wrong :)

johannes
