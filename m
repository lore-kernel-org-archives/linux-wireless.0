Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34026 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750865AbdIOHTU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 03:19:20 -0400
Message-ID: <1505459955.31630.26.camel@sipsolutions.net> (sfid-20170915_091922_486605_00771953)
Subject: Re: ROAM/CONNECT event with PORT_AUTHORIZED
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        Arend van Spriel <arend@broadcom.com>,
        Jouni Malinen <j@w1.fi>
Cc: Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 15 Sep 2017 09:19:15 +0200
In-Reply-To: <94a01366-1af7-4728-59e4-847bfd8476e0@gmail.com> (sfid-20170914_215443_438675_4A9B3055)
References: <1505378361.31630.2.camel@sipsolutions.net>
         <14eb89c4-680b-a1b9-c430-9f92a72bb86c@gmail.com>
         <1505414172.31630.13.camel@sipsolutions.net>
         <6f177c6d-ff79-bc9b-6ed6-e91a1ad96899@gmail.com>
         <1505416964.31630.17.camel@sipsolutions.net>
         <7210eb81-be88-8554-deb8-1926606ef64b@gmail.com>
         <1505418093.31630.21.camel@sipsolutions.net>
         <94a01366-1af7-4728-59e4-847bfd8476e0@gmail.com>
         (sfid-20170914_215443_438675_4A9B3055)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-09-14 at 14:54 -0500, Denis Kenzior wrote:

> If you want roaming to keep oper state UP in all cases, then
> yes.  Does this work on full mac cards as well?

I don't see why not.

> E.g. if I CMD_CONNECT to AP1, then pre-authenticate to AP2 and issue
> a CMD_CONNECT to AP2?

That's not something you can do with full-MAC cards?

And even mac80211 doesn't really support pre-authentication (unless you
mean over-the-DS)

johannes
