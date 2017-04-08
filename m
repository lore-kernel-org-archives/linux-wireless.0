Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36246 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751428AbdDHPuK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Apr 2017 11:50:10 -0400
Message-ID: <1491666603.5800.22.camel@sipsolutions.net> (sfid-20170408_175018_106554_32DC24F6)
Subject: Re: [RFC] netlink: send exterr cookie on success
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@redhat.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sat, 08 Apr 2017 17:50:03 +0200
In-Reply-To: <20170408112844.3aa4d448@griffin>
References: <20170407194402.4181-1-johannes@sipsolutions.net>
         <20170408112844.3aa4d448@griffin>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-04-08 at 11:28 -0400, Jiri Benc wrote:
> Perhaps the structure should be named just "netlink_ext" or so? It
> seems it'll pick up some non-error related usage, such as the cookies
> here or, in the future, flags indicating how the message should be
> parsed.

Fair point, I'll call it netlink_ext_ack.

johannes
