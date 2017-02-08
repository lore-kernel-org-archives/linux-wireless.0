Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41688 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753499AbdBHJHc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 04:07:32 -0500
Message-ID: <1486544731.4603.11.camel@sipsolutions.net> (sfid-20170208_101108_232453_5D5DFE2D)
Subject: Re: [patch] mac80211: check for allocation failure in debugfs code
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Wed, 08 Feb 2017 10:05:31 +0100
In-Reply-To: <20170207132052.GE27416@mwanda>
References: <20170207132052.GE27416@mwanda>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-02-07 at 16:20 +0300, Dan Carpenter wrote:
> kmalloc() can fail.  Also let's move the allocation out of the
> declaration block so it's easier to read.
> 
Applied, thanks.

johannes
