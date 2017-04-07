Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52498 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751174AbdDGU1S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Apr 2017 16:27:18 -0400
Message-ID: <1491596832.5800.21.camel@sipsolutions.net> (sfid-20170407_222818_209927_2F466752)
Subject: Re: [RFC 0/3] netlink: extended error reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: pablo@netfilter.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, jiri@resnulli.us
Date: Fri, 07 Apr 2017 22:27:12 +0200
In-Reply-To: <20170407.125511.1233528940652477012.davem@davemloft.net>
References: <20170407193550.GA23424@salvia>
         <20170407.124327.626442219286333933.davem@davemloft.net>
         <1491594406.5800.18.camel@sipsolutions.net>
         <20170407.125511.1233528940652477012.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-04-07 at 12:55 -0700, David Miller wrote:
> 
> One idea.  We use the macro thing to generate a "netlink.pot" file
> and then some userland tree can contain the latest netlink.pot and
> the translations.

Right. For the record - since we just talked about it - I was thinking
of putting it into a special section so that we could easily write a
script to generate the pot file from the kernel binary after doing
"allyesconfig" or collecting it from modules or so.

Thinking of modules though - do we need to adjust the module loading
code to load a new section? I'll have to look into that.

johannes
