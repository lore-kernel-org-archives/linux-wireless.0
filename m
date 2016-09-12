Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57542 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932199AbcILKJp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 06:09:45 -0400
Message-ID: <1473674982.29016.10.camel@sipsolutions.net> (sfid-20160912_121108_487936_30752DDA)
Subject: Re: [PATCH] cfg80211: Add HT and VHT information in start_ap
From: Johannes Berg <johannes@sipsolutions.net>
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Xu, Peng" <pxu@qca.qualcomm.com>
Date: Mon, 12 Sep 2016 12:09:42 +0200
In-Reply-To: <1472198948.390.20.camel@sipsolutions.net> (sfid-20160826_100916_928008_E35799B6)
References: <1471284424-12142-1-git-send-email-jouni@qca.qualcomm.com>
         <1471330367.16783.23.camel@sipsolutions.net>
         <20160816123441.GA3678@jouni.qca.qualcomm.com>
         <1472198948.390.20.camel@sipsolutions.net>
         (sfid-20160826_100916_928008_E35799B6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So I haven't seen a response from you guys:

I have no major objections to this. However, a few things:

1) are you planning to add support for this into a kernel driver at
   all, anyway?
2) are you planning to have a driver upstream that contains the now
   necessary parsing?

Depending on the answers, I suppose we could/should merge this:

no  *  : don't merge
yes no : merge
yes yes: don't merge, put parsing into cfg80211

I guess?

We don't have to always draw a too rigid line for non-upstream things, but it's still disappointing that you keep proposing things that are only used for non-upstream drivers.

johannes
